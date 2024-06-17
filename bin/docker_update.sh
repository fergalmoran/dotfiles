#!/usr/bin/env bash


if [ -f .dockercontext ]; then
  CONTEXT=`cat .dockercontext`
else
  CONTEXT=${1:-noodles}
fi

echo Updating deployment on $CONTEXT
docker --context $CONTEXT compose down -v --remove-orphans && \
  docker --context $CONTEXT compose pull && \
  docker --context $CONTEXT compose up -d && \
  docker --context $CONTEXT compose logs -f
