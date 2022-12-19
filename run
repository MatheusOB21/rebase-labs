#!/bin/bash

docker run \
  --rm \
  --name rebase-challenge-2022 \
  -w /app \
  -v $(pwd):/app \
  -p 3000:3000 \
  -d \
  ruby \
  bash -c "gem install rack sinatra puma && ruby server.rb"