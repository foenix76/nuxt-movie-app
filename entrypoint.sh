#!/bin/bash

# 작업 디렉토리 이동
cd /app || exit

npx degit https://github.com/foenix76/nuxt-movie-app .

# 의존성 설치 (production=false로 개발 의존성 포함)
npm i

# 애플리케이션 빌드 (필요한 경우 빌드 명령어 추가)
npm run build

# 애플리케이션 시작
npm start
