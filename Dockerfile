FROM golang:alpine as builder
RUN apk update && apk add git && apk add ca-certificates
COPY *.go $GOPATH/src/mypackage/myapp/
WORKDIR $GOPATH/src/mypackage/myapp/
RUN go mod init && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/container_exporter

FROM alpine:3
COPY --from=builder /go/bin/container_exporter /go/bin/container_exporter
EXPOSE 19092
ENTRYPOINT ["/go/bin/container_exporter"]
CMD ["-listen-address=:19092"]