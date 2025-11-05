# Nightmare

## Overview
Nightmare is an AI stack utilizing [Ollama models](https://ollama.com/search) running on the host to orchestrate security testing using a Kali Linux container pre-loaded with [HexStrike-AI](https://github.com/0x4m4/hexstrike-ai/tree/master).

## Prerequisites
- Docker and Docker Compose
- Ollama installed and hosting a model of your choice

## Building and Running

### 1. Building everything
```bash
$ docker compose build
```

### 2. Configuring the environment
Create a new .env file in the project root and set the following variables in it:
```
ROOT_PASSWORD=
MCP_API_KEY=
```

### 3. Running the stack
```bash
$ docker compose up -d
```

### 2. Accessing Open Web UI
- Navigate to `http://localhost:6903` in your browser
- Log in or create a new local account

### 3. Configuring the tool server

1. Click your account icon in the top right of the Open Web UI interface
2. Go to AdminPanel and then to the Settings tab
3. Click External Tools on the left
4. Import assets/mcp.json and set Auth to owui_data/your MCP_API_KEY variable to in .env.

*Note: You will need to manually enable the HexStrike tool in each new chat using the diamond-shaped "Integrations" button below the message bar.*

### 4. Configuring the system prompt

1. Go to Workspace in the left sidebar and then to the Prompts tab
2. Add a new prompt using the content of assets/sysprompt.txt

Once added, this prompt can be initalized in each chat by typing a forward slash and selecting it from the list.

### 5. Stopping the Environment
```bash
$ docker compose down
```

## Additional access to the environment

### Kali SSH
Port 6901 is exposed to allow SSH connections to the Kali container to allow for manual testing in the same environment.

```bash
$ ssh root@localhost -p 6901
```

### Kali shared directory
The host and the Kali machine share the vault/ directory within the project root. This is intended as a workspace folder and will persist until you delete it.

### OpenAPI spec
HexStrike does not natively support OpenAPI, so included in the Kali container is an MCPO proxy. If for some reason you need access to the HexStrike spec, it can be accessed at [http://localhost:6902/docs](http://localhost:6902/docs).

## Troubleshooting
If you experience issues with filesystem permissions when accessing vault/ from the host, try using sudo. If you run into further issues with filesystem permissions, try tweaking or removing the `:z` suffix from the bind mounts in docker-compose.yaml. These are in place for SELinux users to correct permissions.

Kali's VPN connection is handled by Gluetun. If the VPN crashes, gets stuck in a loop, or otherwise has errors, try restarting the gluetun container or the whole stack.

## Contributing
Feel free to submit issues and pull requests.
