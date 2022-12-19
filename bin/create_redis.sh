docker run -d \
    --name redis \
    --restart always \
    -p 6379:6379 \
    -v /home/fergalm/working/redis_data:/data \
    redis:alpine
