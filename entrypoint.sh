#!/bin/sh

# Start Xvfb on display :1
Xvfb :1 -screen 0 1920x1080x24 &
sleep 1

# Set the DISPLAY environment variable
export DISPLAY=:1

# Run danser-go with the provided arguments
exec danser-go "$@" 