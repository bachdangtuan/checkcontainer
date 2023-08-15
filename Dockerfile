# FROM golang:alpine as builder
# RUN apk update && apk add git && apk add ca-certificates
# COPY *.go $GOPATH/src/mypackage/myapp/
# WORKDIR $GOPATH/src/mypackage/myapp/
# RUN go mod init && go mod tidy
# RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/container_exporter

# FROM alpine:3
# COPY --from=builder /go/bin/container_exporter /go/bin/container_exporter
# EXPOSE 19092
# ENTRYPOINT ["/go/bin/container_exporter"]
# CMD ["-listen-address=:19092"]




FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl git ca-certificates


RUN curl -fsSL https://golang.org/dl/go1.17.2.linux-amd64.tar.gz | tar -C /usr/local -xzf -
ENV PATH=$PATH:/usr/local/go/bin


RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce


COPY *.go $GOPATH/src/mypackage/myapp/
WORKDIR $GOPATH/src/mypackage/myapp/


RUN go mod init && go mod tidy


RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/container_exporter


EXPOSE 19092


ENTRYPOINT ["/go/bin/container_exporter"]
CMD ["-listen-address=:19092"]



# sudo docker run -p 19092:19092 --name container-exporter-isofh  -d nguyenngochuy/container_exporter -listen-address=:19092