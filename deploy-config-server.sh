#!/bin/bash
# deploy-config-server.sh for Kitchana-config-server using docker-compose

set -e

COMPOSE_DIR="/home/ec2-user/outer"

cd "$COMPOSE_DIR" || { echo "Compose directory not found"; exit 1; }

# .env 파일 내 CONFIG_SERVER_TAG 값을 최신 TAG로 업데이트
sed -i "s|^CONFIG_SERVER_TAG=.*|CONFIG_SERVER_TAG=$TAG|" .env

# config-server 컨테이너 강제 재시작
docker-compose -f docker-compose-outer.yml up -d --no-deps --force-recreate config-server
