#!/usr/bin/env bash

# Usage: ./pg_backup.sh -h <host> -u <user> -p <password> -d <backup_dir>
# Example: ./pg_backup.sh -h localhost -u postgres -p password -d /mnt/storage/backups/postgres/
OPTSRING=":h:u:p:d:"
while getopts $OPTSRING opt; do
    case $opt in
    h)
        host=$OPTARG
        ;;
    u)
        user=$OPTARG
        ;;
    p)
        password=$OPTARG
        ;;
    d)
        backup_dir=$OPTARG
        ;;
    \?)
        echo "Invalid option: -$OPTARG" >&2
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        ;;
    esac
done

if [ -z "$host" ] || [ -z "$user" ] || [ -z "$password" ] || [ -z "$backup_dir" ]; then
    echo 'Missing required arguments' >&2
    exit 1
fi

backup_date=$(date +%d-%m-%Y_%H:%M)
number_of_days=15

databases=$(PGPASSWORD=$password psql -h "$host" -U $user -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d')
for i in $databases; do
    if [ "$i" != "template0" ] && [ "$i" != "template1" ] && [ "$i" != "template_postgis" ]; then
        echo Dumping $i to $backup_dir$i\_$backup_date.sql
        PGPASSWORD=$password pg_dump -h $host -U $user $i >$backup_dir$i\_$backup_date.sql
        bzip2 $backup_dir$i\_$backup_date.sql
    fi
done
find $backup_dir -type f -prune -mtime +$number_of_days -exec rm -f {} \;
