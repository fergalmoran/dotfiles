docker run -d \
    --name postgres \
    --restart always \
    -e POSTGRES_PASSWORD=hackme \
    -p 5432:5432 \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v /home/fergalm/working/pg_data:/var/lib/postgresql/data \
    postgres:14 -c log_statement=all
