FROM alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4

RUN apk add --no-cache ddclient=~4.0

USER ddclient

ENTRYPOINT ["/usr/bin/ddclient"]
CMD ["--foreground", "--verbose"]
