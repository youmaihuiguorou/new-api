# Use Wukong API with the official OpenAI SDK

If you already use the official OpenAI SDK, the migration is simple: keep the same SDK and replace only the `base_url` and API key.

```python
from openai import OpenAI

client = OpenAI(
    # Replace this with the key created on your Wukong token page
    api_key="sk-xxx",
    # Replace the official base URL with the Wukong relay endpoint
    base_url="https://api.wukong.support/v1"
)

chat_completion = client.chat.completions.create(
    messages=[
        {
            "role": "user",
            "content": "Say this is a test",
        }
    ],
    model="gpt-4o",
)

print(chat_completion)
```

For most OpenAI-compatible workflows, the rest of the code can stay the same. If you need more request examples or parameter details, refer to the official OpenAI documentation and swap in the Wukong endpoint.
