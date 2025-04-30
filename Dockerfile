# Use Ubuntu as the base image
FROM ubuntu:22.04

# Add build argument for Danser version
ARG DANSER_VERSION=0.11.0

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    xvfb \
    libgl1-mesa-dev \
    libopengl0 \
    libx11-6 \
    libxcursor1 \
    libxrandr2 \
    libxinerama1 \
    libxi6 \
    libxext6 \
    libxfixes3 \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Download and install Danser
RUN wget https://github.com/Wieku/danser-go/releases/download/${DANSER_VERSION}/danser-${DANSER_VERSION}-linux.zip \
    && unzip danser-${DANSER_VERSION}-linux.zip \
    && rm danser-${DANSER_VERSION}-linux.zip \
    && chmod +x danser

# Create necessary directories
RUN mkdir -p /app/songs /app/skins /app/output

# Create a non-root user
RUN useradd -m -s /bin/bash danser && \
    mkdir -p /home/danser/.danser && \
    chown -R danser:danser /home/danser/.danser

# Create output directory
RUN mkdir -p /app/output && \
    chown -R danser:danser /app/output

# Create a script to start Xvfb and run danser-go
COPY --chown=danser:danser entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER danser
WORKDIR /app

# Default command (can be overridden)
CMD ["danser-go", "--help"]

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"] 