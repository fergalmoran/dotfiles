#!/usr/bin/env bash
CONTEXT=${1:-noodles}
docker --context $CONTEXT compose down -v --remove-orphans && \
  docker --context $CONTEXT compose pull && \
  docker --context $CONTEXT compose up -d && \
  docker --context $CONTEXT compose logs -f
