FROM node:14.16.0 as builder

WORKDIR /app

COPY . .
# RUN npx degit https://github.com/foenix76/nuxt-movie-app .

# 의존성 설치 (production=false로 개발 의존성 포함)
RUN npm install --production=false

# 애플리케이션 빌드 (필요한 경우 빌드 명령어 추가)
RUN npm run build

# 2단계: 프로덕션 이미지 생성
FROM node:14.16.0

# 작업 디렉토리 설정
WORKDIR /app

# 빌드 단계에서 생성된 파일을 복사
COPY --from=builder /app .

# 프로덕션 환경에서 필요한 의존성만 설치
RUN npm install --production=true

# 환경 변수 설정 (필요한 경우)
ENV HOST 0.0.0.0

# 애플리케이션 포트 노출
EXPOSE 3000

# 애플리케이션 시작
CMD ["npm", "start"]