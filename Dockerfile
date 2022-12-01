FROM golang:1.19.3-alpine3.16@sha256:e3c076c378a7301550c741711d6d5d3b1e490104bbb5751b58a7de70820c3ec2 AS builder
ARG VERSION=dev-snapshot
RUN mkdir /build
RUN apk add --update make
WORKDIR /build
ADD . /build
RUN make BUILD_VERSION=${VERSION}

FROM alpine:3.17.0@sha256:8914eb54f968791faf6a8638949e480fef81e697984fba772b3976835194c6d4 AS runner
LABEL org.opencontainers.image.source="https://github.com/DataDog/stratus-red-team/"
COPY --from=builder /build/bin/stratus /stratus
RUN apk add --update git # git is needed for Terraform to download external modules at runtime
ENTRYPOINT ["/stratus"]
CMD ["--help"]
