FROM node:14.16.0 as builder

WORKDIR /app

COPY . .

# 의존성 설치 (production=false로 개발 의존성 포함)
RUN npm install --production=false

# 애플리케이션 빌드 (필요한 경우 빌드 명령어 추가)
RUN npm run build

# 환경 변수 설정 (필요한 경우)
ENV HOST 0.0.0.0

# 애플리케이션 포트 노출
EXPOSE 3000

# 애플리케이션 시작
CMD ["npm", "start"]