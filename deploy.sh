#!/bin/bash

# Configuration
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
APP_NAME="telegram-shell-bot"

echo "=== Deploying $APP_NAME ==="
echo "Directory: $APP_DIR"

# Check for Poetry
if ! command -v poetry &> /dev/null; then
    echo "Error: Poetry is not installed. Please install it first."
    echo "Try: curl -sSL https://install.python-poetry.org | python3 -"
    exit 1
fi

# Install Dependencies
echo "--> Installing dependencies..."
cd "$APP_DIR" || exit
poetry install --no-root
if [ $? -ne 0 ]; then
    echo "Error: Dependency installation failed."
    exit 1
fi

# PM2 Management
echo "--> Managing PM2 process..."
if pm2 describe "$APP_NAME" > /dev/null; then
    echo "Restarting existing process..."
    pm2 restart "$APP_NAME"
else
    echo "Starting new process..."
    # Start using the config file
    pm2 start telegram-shell-bot.yml
fi

# Save PM2 list
pm2 save

echo "=== Deployment Complete ==="
pm2 status "$APP_NAME"
