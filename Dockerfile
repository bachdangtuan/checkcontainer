FROM golang:alpine as builder
RUN apk update && apk add git && apk add ca-certificates
COPY go.mod $GOPATH/src/mypackage/myapp/
COPY go.sum $GOPATH/src/mypackage/myapp/
WORKDIR $GOPATH/src/mypackage/myapp/
RUN go mod download

COPY *.go $GOPATH/src/mypackage/myapp/

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/container_exporter

FROM alpine:3
COPY --from=builder /go/bin/container_exporter /go/bin/container_exporter
EXPOSE 19092
ENTRYPOINT ["/go/bin/container_exporter"]
CMD ["-listen-address=:19092"]





# FROM docker:latest


# RUN apk add --no-cache go


# COPY *.go /src/mypackage/myapp/
# WORKDIR /src/mypackage/myapp/


# ENV GO111MODULE=on
# RUN go mod init mypackage/myapp && go mod tidy


# RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/container_exporter


# EXPOSE 19092


# ENTRYPOINT ["/go/bin/container_exporter"]
# CMD ["-listen-address=:19092"]




# sudo docker run -p 19092:19092 --name dangcap_pro  -d bachdangtuan-app10 -listen-address=:19092
# sudo docker run -p 19092:19092 --name exporter-isofh -v "/var/run/docker.sock:/var/run/docker.sock"  -d democheck -listen-address=:19092