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

# Hotfix for Python 3.12: Force upgrade APScheduler
# python-telegram-bot v13 pins APScheduler==3.6.3 which is broken on Py3.12
echo "--> Applying hotfix for APScheduler on Python 3.12..."
poetry run pip install "APScheduler>=3.10"

# PM2 Management
echo "--> Managing PM2 process..."
# Always delete to ensure config reload
if pm2 describe "$APP_NAME" > /dev/null; then
    echo "Removing old process to apply new configuration..."
    pm2 delete "$APP_NAME"
fi

echo "Starting process from config..."
pm2 start telegram-shell-bot.yml

# Save PM2 list
pm2 save

echo "=== Deployment Complete ==="
pm2 status "$APP_NAME"
