# Use alpine as the base image
FROM alpine:latest

# Install runtime dependencies including Xvfb and OpenGL
RUN apk add --no-cache \
    ffmpeg \
    xvfb \
    mesa-dri-gallium \
    mesa-egl \
    mesa-gles \
    xrandr \
    wget \
    tar

# Set the working directory
WORKDIR /app

# Download and extract the latest danser-go release
RUN wget https://github.com/Wieku/danser-go/releases/latest/download/danser-go_linux_amd64.tar.gz && \
    tar -xzf danser-go_linux_amd64.tar.gz && \
    rm danser-go_linux_amd64.tar.gz && \
    mv danser-go_linux_amd64/danser-go /usr/local/bin/ && \
    rm -rf danser-go_linux_amd64

# Create a non-root user
RUN adduser -D -g '' danser
USER danser

# Create a script to start Xvfb and run danser-go
COPY --chown=danser:danser entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"] 