#!/bin/bash

echo "=== VPS Metadata Collection ==="
echo "Generated at: $(date)"

echo -e "\n--- OS Info ---"
if [ -f /etc/os-release ]; then
    cat /etc/os-release | grep -E "PRETTY_NAME|ID=|VERSION="
else
    uname -a
fi

echo -e "\n--- User Info ---"
echo "User: $(whoami)"
echo "Groups: $(id -Gn)"
echo "Home: $HOME"

echo -e "\n--- System Resources ---"
free -h | grep "Mem:"
df -h / | tail -n 1

echo -e "\n--- Python Environment ---"
if command -v python3 &> /dev/null; then
    echo "Python3: $(python3 --version)"
    echo "Pip3: $(python3 -m pip --version)"
else
    echo "Python3: Not found"
fi

if command -v poetry &> /dev/null; then
    echo "Poetry: $(poetry --version)"
elif [ -f "$HOME/.local/bin/poetry" ]; then
    echo "Poetry: $($HOME/.local/bin/poetry --version) (in ~/.local/bin)"
else
    echo "Poetry: Not found globally or in ~/.local/bin"
fi

echo -e "\n--- Process Managers ---"
if command -v pm2 &> /dev/null; then
    echo "PM2: $(pm2 -v)"
else
    echo "PM2: Not found"
fi

if command -v systemctl &> /dev/null; then
    echo "Systemd: Present"
else
    echo "Systemd: Not found"
fi

echo -e "\n--- Git ---"
if command -v git &> /dev/null; then
    echo "Git: $(git --version)"
else
    echo "Git: Not found"
fi

echo -e "\n--- Connectivity Check ---"
echo "Can reach pypi.org: "
curl -s -I https://pypi.org | head -n 1 || echo "Failed"

echo -e "\n=============================="
