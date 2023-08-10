FROM golang:alpine as builder
RUN apk update && apk add git && apk add ca-certificates
COPY *.go $GOPATH/src/mypackage/myapp/
WORKDIR $GOPATH/src/mypackage/myapp/
RUN go mod init && go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/check_container

FROM alpine:3
COPY --from=builder /go/bin/check_container /go/bin/check_container
EXPOSE 14444
ENTRYPOINT ["/go/bin/check_container"]
CMD ["-check-container-isofh=:14444"]




