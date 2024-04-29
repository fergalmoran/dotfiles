#!/usr/bin/env bash

source ~/.prv/env

backup_dir="/mnt/storage/backups/postgres/kubes/"
nightly_dir="/mnt/storage/backups/postgres/latest/"
backup_date=`date +%d-%m-%Y_%H:%M`
number_of_days=15
host="daphne.l.fergl.ie"
user=postgres

databases=`PGPASSWORD=$CLUSTER_MASTER_PGPWD psql -h "$host" -U $user -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'`
for i in $databases; do  if [ "$i" != "template0" ] && [ "$i" != "template1" ] && [ "$i" != "template_postgis" ]; then    
    echo Dumping $i to $backup_dir$i\_$backup_date.sql    
    PGPASSWORD=$CLUSTER_MASTER_PGPWD pg_dump -h $host -U $user $i > $backup_dir$i\_$backup_date.sql
    bzip2 $backup_dir$i\_$backup_date.sql
  fi
done
find $backup_dir -type f -prune -mtime +$number_of_days -exec rm -f {} \;
