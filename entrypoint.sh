#!/bin/bash

# Start Xvfb
Xvfb :99 -screen 0 1920x1080x24 &
export DISPLAY=:99

# Run danser with the provided arguments
exec /app/danser "$@" 