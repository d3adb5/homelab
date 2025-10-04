FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1

RUN apk add --no-cache ddclient=~3.11

USER ddclient

ENTRYPOINT ["/usr/bin/ddclient"]
CMD ["--foreground", "--verbose"]
