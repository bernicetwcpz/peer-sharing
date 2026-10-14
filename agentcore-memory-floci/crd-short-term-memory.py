import boto3, json, os
from datetime import datetime
from bedrock_agentcore.memory import MemorySessionManager
from bedrock_agentcore.memory.constants import ConversationalMessage, MessageRole

aws_region = os.getenv("AWS_DEFAULT_REGION")
endpoint_url = os.getenv("AWS_ENDPOINT_URL")

control_client = boto3.client(
    'bedrock-agentcore-control',
    region_name=aws_region,
    endpoint_url=endpoint_url
)

# Retrieve the memory created via agentcore-cli
response = control_client.list_memories()
print(json.dumps(response, indent=4, default=str))

memory_id = response['memories'][0]['id']
print(f'Memory ID = {memory_id}')

# Create a session to store memory events
## Timestamped session_id so each run starts with a clean session (no duplicates from earlier runs)
session_manager = MemorySessionManager(
    memory_id=memory_id,
    region_name=aws_region)

session = session_manager.create_memory_session(
    actor_id="User1",
    session_id=f"OrderSupportSession-{datetime.now():%Y%m%d%H%M%S}"
)

# 1. Create events
## Simulates a conversation between an end user (USER) and a chat bot (ASSISTANT), 1 event per message
print('\n--- 1. Create events (add_turns) ---')
events = [
    session.add_turns(messages=[ConversationalMessage(text, role)])
    for text, role in [
        ("Hi, how can I help you today?", MessageRole.ASSISTANT),
        ("Hi, I am a new customer. I just made an order, but it hasn't arrived. The Order number is #35476", MessageRole.USER),
        ("I'm sorry to hear that. Let me look up your order.", MessageRole.ASSISTANT),
    ]
]
for event in events:
    print(f"Created event: {event['eventId']}")

# 2. Get a single event by its ID
print('\n--- 2. Get event (get_event) ---')
event_id = events[0]['eventId']
print(session.get_event(event_id))

# 3. List all events in the session
print('\n--- 3. List events (list_events) ---')
for event in session.list_events():
    print(f"{event['eventId']}: {event['payload']}")

# 4. Delete an event, then list again to confirm it is gone
print('\n--- 4. Delete event (delete_event) ---')
session.delete_event(event_id)
print(f"Deleted event: {event_id}")
for event in session.list_events():
    print(f"{event['eventId']}: {event['payload']}")
