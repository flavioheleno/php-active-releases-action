FROM alpine:3.21.3@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c

ARG VERSION=latest

RUN apk add --no-cache \
    curl=8.12.1-r1 \
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
