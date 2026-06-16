FROM alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b

RUN apk add --no-cache ddclient=~4.0

USER ddclient

ENTRYPOINT ["/usr/bin/ddclient"]
CMD ["--foreground", "--verbose"]
