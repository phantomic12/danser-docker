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
    unzip

# Set the working directory
WORKDIR /app

# Download and extract danser-go 0.11.0
RUN wget https://github.com/Wieku/danser-go/releases/download/0.11.0/danser-0.11.0-linux.zip && \
    unzip danser-0.11.0-linux.zip && \
    rm danser-0.11.0-linux.zip && \
    mv danser /usr/local/bin/danser-go && \
    mv ffmpeg/* /usr/local/bin/ && \
    mv *.so /usr/local/lib/ && \
    rm -rf ffmpeg

# Create a non-root user
RUN adduser -D -g '' danser
USER danser

# Create a script to start Xvfb and run danser-go
COPY --chown=danser:danser entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"] 