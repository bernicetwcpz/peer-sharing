# AgentCore Memory Hands-on with floci
> As of time of writing (Oct 2026), floci don't support emulating long term memory

- The guide focused on guiding the audience to setup their environment using the examples shown in AWS Official Documentation - [Get started with AgentCore Memory](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/memory-get-started.html) on the use of agentcore-cli and the CRUD operations short-term memory only with AgentCore SDK

- Might be worth reading the implementation of [memory](https://github.com/aws/bedrock-agentcore-sdk-python/tree/main/src/bedrock_agentcore/memory) from [Bedrock AgentCore SDK](https://github.com/aws/bedrock-agentcore-sdk-python/tree/main/src/bedrock_agentcore/memory) to understand the classes and how they are used to create the agents

- Learners are recommended to refer to the AWS labs for more [detailed samples on AgentCore Memory](https://github.com/awslabs/agentcore-samples/tree/main/01-features/04-manage-context-of-your-agent/memory/00-getting-started) on an actual AWS account 

- If cost is a concern, refer to [Amazon Bedrock AgentCore pricing](https://aws.amazon.com/bedrock/agentcore/pricing/)

---

## Prerequisites
- Complete the [Prerequisites in the root README](../README.md#prerequisites): install tools, start a fresh floci, and `./check.sh` shows all OK




## Table of Contents
- [1. Setup](#1-setup)
- [2. Hands-on](#2-hands-on)
  - [Use of agentcore-cli](#use-of-agentcore-cli)
  - [CRUD operations with short-term memory with Bedrock AgentCore SDK](#crud-operations-with-short-term-memory-with-bedrock-agentcore-sdk)
- [3. Cleanup](#3-cleanup)

---

## 1. Setup

1. Clone the repository
```bash
git clone https://github.com/bernicetwcpz/peer-sharing.git
cd /path/to/peer-sharing
```

2. Follow the [root README](../README.md#prerequisites) to start a fresh floci and pass `./check.sh`

3. Navigate to agentcore-memory-floci folder. If you did this exercise before, delete the old CLI project, since the fresh floci no longer has its resources
```bash
cd agentcore-memory-floci
rm -rf MemoryQuickstart
```

## 2. Hands-on

### Use of agentcore-cli
> Docs Reference: https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/memory-get-started.html


1. Create a AgentCore CLI project

```bash
# --no-agent skips the creation of agent as well as runs the project scaffolding non-interactively
agentcore create --project-name MemoryQuickstart --no-agent

cd MemoryQuickstart
```

2. Create memory with semantic strategy. 
- This example is quoted from [Get Started with AgentCore Memory](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/memory-get-started.html)
- Running just `agentcore` command will provide an interactive CLI interface
```bash
agentcore add memory --name CustomerSupportSemantic --strategies SEMANTIC
agentcore deploy
```

3. Press `Enter/Y` to confirm to proceed with the CDK bootstrapping which involves CloudFormation
- All this will be provision within the floci environment
- You can check the deployment status with the command below
```bash
agentcore status --json
```


### CRD operations (no updates) with short-term memory with Bedrock AgentCore SDK


1. Navigate back to agentcore-memory-floci folder
```bash
cd /path/to/agentcore-memory-floci
```

2. Run `crd-short-term-memory.py` with `uv` to demo the short-term memory event lifecycle
- No need to install Python or create a venv: `uv run` reads `pyproject.toml` / `uv.lock`, downloads the Python pinned in `.python-version` and installs `bedrock-agentcore` on first run
- Create events → `session.add_turns()` (3 messages simulating USER/ASSISTANT chat)
- Get an event → `session.get_event(event_id)`
- List events → `session.list_events()`
- Delete an event → `session.delete_event(event_id)`, then lists again to confirm
- Each run uses a new timestamped `session_id`, so re-runs don't stack duplicate events
```bash
uv run crd-short-term-memory.py
```


## 3. Cleanup
1. Cleanup the memory
```bash
cd /path/to/MemoryQuickstart
agentcore remove memory --name CustomerSupportSemantic 
agentcore deploy
agentcore status --json
```

2. Stop floci and cleanup environment variables, see [root README](../README.md#3-stop-floci-after-the-exercise)
