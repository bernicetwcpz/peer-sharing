# learnings
Shared learnings using emulators to demonstrate concepts

# Getting Started
Each folder in this repository is a mini exercise to grasp specific topics and used as foundation for discussion.

The goal is to reduce the setup fatigue as much as possible for learners through the use of emulators such as floci. After gaining familiarity, the learners can proceed with the respective cloud provider (e.g AWS)

# Prerequisites
- It is assumed the environment setup is on MacOS (Sorry Windows user)
- So a lot of commands for tool installation will be aligned to using Homebrew or bash scripts
- You do NOT need to install Python yourself. `uv` downloads the Python version each exercise needs

## 1. Install tools (once)
Installs uv, node, awscli, colima, docker and docker-compose from the [Brewfile](./Brewfile). Colima is registered as a login service, so Docker is available after every reboot
- Skip any tool you already have (e.g. node via nvm/mise), `check.sh` only cares that it is on your PATH
```bash
cd /path/to/peer-sharing
brew bundle
npm install -g @aws/agentcore
```
- The first Colima start can take a few minutes
- To stop Colima when you are done with the exercises: `brew services stop colima`

## 2. Start a fresh floci and verify (every exercise / new terminal)
All exercises share one floci from the [docker-compose.yml](./docker-compose.yml) at the repo root. Floci keeps no data, so recreating it gives every exercise a clean state
```bash
cd /path/to/peer-sharing
# export FLOCI_PORT=4599   # only if port 4566 is already used (e.g. by another floci)
source env-config.sh       # points AWS CLI / SDK / agentcore-cli at floci, needed in every new terminal
docker compose up -d --force-recreate floci
./check.sh                 # every line should be OK, follow the "fix" hint for any FAIL
```

## 3. Stop floci (after the exercise)
```bash
cd /path/to/peer-sharing
docker compose down
source env-config.sh --cleanup
```

# Exercises

- [agentcore-memory-floci](./agentcore-memory-floci/): This covers some basic interactions with AWS AgentCore Memory in terms of short-term memory, long-term memory along with the use of agentcore-cli. Most information are based on the [AWS Official Documentation](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agentcore-sdk-memory.html)