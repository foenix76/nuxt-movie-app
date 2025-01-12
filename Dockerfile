FROM node:14.16.0 as builder

WORKDIR /app

# 스크립트 복사
COPY entrypoint.sh /entrypoint.sh

# 소스 다운로드
# 의존성 설치 (production=false로 개발 의존성 포함)
# 애플리케이션 빌드 (필요한 경우 빌드 명령어 추가)
ENTRYPOINT ["/entrypoint.sh"]

# 환경 변수 설정 (필요한 경우)
ENV HOST 0.0.0.0

# 애플리케이션 포트 노출
EXPOSE 3000
