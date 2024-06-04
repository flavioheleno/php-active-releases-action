FROM alpine:3.20

ARG VERSION=latest

RUN apk add --no-cache \
    curl=8.7.1-r0 \
    jq=1.7.1-r0

COPY entrypoint.sh /entrypoint.sh

LABEL maintainer="Flavio Heleno <flaviohbatista@gmail.com>" \
      org.opencontainers.image.authors="flaviohbatista@gmail.com" \
      org.opencontainers.image.base.name="ghcr.io/flavioheleno/php-active-releases-action:${VERSION}" \
      org.opencontainers.image.source="https://github.com/flavioheleno/php-active-releases-action" \
      org.opencontainers.image.title="php-active-releases-action" \
      org.opencontainers.image.description="This action retrieves a list of active PHP Releases" \
      org.opencontainers.image.url="https://github.com/flavioheleno/php-active-releases-action" \
      org.opencontainers.image.vendor="Flavio Heleno" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.licenses="MIT"

ENTRYPOINT ["/entrypoint.sh"]
