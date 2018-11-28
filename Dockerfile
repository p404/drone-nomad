FROM golang:1.9-alpine
WORKDIR /go/src/github.com/hashicorp
RUN apk add --no-cache \
        gcc \
        git \
        musl-dev \
    && git clone https://github.com/hashicorp/nomad \
    && cd nomad \
    && git checkout v0.8.2 \
    && go install .

WORKDIR /go/src/github.com/p404/drone-nomad
COPY . ./
RUN go install .

FROM alpine:3.6
RUN apk add --no-cache ca-certificates \
    && rm -rf /var/cache/apk/*

COPY --from=0 /go/bin/drone-nomad /bin/
COPY --from=0 /go/bin/nomad /bin/
ENTRYPOINT ["/bin/drone-nomad"]
