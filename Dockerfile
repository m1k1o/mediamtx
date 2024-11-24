FROM golang:1.23-alpine3.20 AS build-base

RUN apk add --no-cache zip make git tar
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./

ENV CGO_ENABLED=0
RUN go generate ./...
RUN go build -ldflags "-s -w" -o bin main.go

FROM alpine:3.20
RUN apk add --no-cache ffmpeg
ARG TARGETPLATFORM
COPY --from=build-base /app/bin /mediamtx
ENTRYPOINT [ "/mediamtx" ]
