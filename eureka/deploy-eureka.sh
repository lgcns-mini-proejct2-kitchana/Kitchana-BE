#!/bin/bash
# deploy-eureka.sh for Kitchana-eureka using docker-compose

set -e

# docker-compose.yml 파일이 위치한 디렉토리 (필요에 따라 수정)
COMPOSE_DIR="/home/ec2-user/inner"

cd "$COMPOSE_DIR" || { echo "Compose directory not found"; exit 1; }

# .env 파일 내 EUREKA_TAG 값을 최신 TAG로 업데이트
sed -i "s|^EUREKA_TAG=.*|EUREKA_TAG=$TAG|" .env

# eureka 컨테이너 강제 재시작
docker-compose -f docker-compose-inner.yml up -d --no-deps --force-recreate eureka
