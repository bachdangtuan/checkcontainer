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





# Sử dụng hình ảnh Docker làm cơ sở
FROM docker:latest

# Cài đặt Golang từ gói đã biên dịch sẵn cho hình ảnh Docker
RUN apk add --no-cache go

# Sao chép mã nguồn của ứng dụng Go vào trong container
COPY *.go /src/mypackage/myapp/
WORKDIR /src/mypackage/myapp/

# Khởi tạo module và làm sạch các phụ thuộc
ENV GO111MODULE=on
RUN go mod init mypackage/myapp && go mod tidy

# Biên dịch ứng dụng Go thành tệp nhị phân và đặt nó vào thư mục /go/bin
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/container_exporter

# Mở cổng 19092 để ứng dụng có thể lắng nghe
EXPOSE 19092

# Đặt điểm khởi động (entrypoint) và tham số mặc định cho ứng dụng
ENTRYPOINT ["/go/bin/container_exporter"]
CMD ["-listen-address=:19092"]




# sudo docker run -p 19092:19092 --name container-exporter-isofh  -d nguyenngochuy/container_exporter -listen-address=:19092