#!/bin/bash
# deploy-api-gateway.sh for Kitchana-api-gateway using docker-compose

set -e

COMPOSE_DIR="/home/ec2-user/outer"

cd "$COMPOSE_DIR" || { echo "Compose directory not found"; exit 1; }

# .env 파일 내 API_GATEWAY_TAG 값을 최신 TAG로 업데이트
sed -i "s|^API_GATEWAY_TAG=.*|API_GATEWAY_TAG=$TAG|" .env

# api-gateway 컨테이너 강제 재시작
docker-compose -f docker-compose-outer.yml up -d --no-deps --force-recreate api-gateway
