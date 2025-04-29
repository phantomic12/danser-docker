# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    xvfb \
    mesa-utils \
    libgl1-mesa-glx \
    libgl1-mesa-dri \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Download and extract danser-go 0.11.0
RUN wget https://github.com/Wieku/danser-go/releases/download/0.11.0/danser-0.11.0-linux.zip && \
    unzip danser-0.11.0-linux.zip && \
    rm danser-0.11.0-linux.zip && \
    mv danser /usr/local/bin/danser-go && \
    mv ffmpeg/* /usr/local/bin/ && \
    mv *.so /usr/local/lib/ && \
    rm -rf ffmpeg && \
    chmod +x /usr/local/bin/danser-go

# Create a non-root user
RUN useradd -m -s /bin/bash danser && \
    mkdir -p /home/danser/.danser && \
    chown -R danser:danser /home/danser/.danser

# Create output directory
RUN mkdir -p /app/output && \
    chown -R danser:danser /app/output

# Create a script to start Xvfb and run danser-go
COPY --chown=danser:danser entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

USER danser
WORKDIR /app

# Set the entrypoint
ENTRYPOINT ["/app/entrypoint.sh"] 