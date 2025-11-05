#!/bin/bash

set -e

# Set root password
echo "root:${ROOT_PASSWORD}" | chpasswd

# Start SSH daemon in the background
/usr/sbin/sshd

# Start Hexstrike AI server and MCPO
source /opt/hexstrike-ai/hexstrike-env/bin/activate
python3 /opt/hexstrike-ai/hexstrike_server.py --port 8888 &
mcpo --port 8000 --api-key "${MCP_API_KEY}" -- python3 /opt/hexstrike-ai/hexstrike_mcp.py --server http://localhost:8888