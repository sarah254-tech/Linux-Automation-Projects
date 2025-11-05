FROM alpine:latest
COPY . /app
WORKDIR /app
CMD ["echo", "Linux Automation Project"]