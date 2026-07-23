# OpenAI conversation format (Chat Completions)

!!! info "Official Documentation"
    [OpenAI Chat](https://platform.openai.com/docs/api-reference/chat)

## 📝 Introduction

Given a list of messages containing a conversation, the model returns a response. Related guidelines can be found on the OpenAI official website:[Chat Completions](https://platform.openai.com/docs/guides/chat)

## 💡 Request example

### Basic text conversation ✅

```bash
curl https://api.wukong.support/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "developer",
        "content": "你是一个有帮助的助手。"
      },
      {
        "role": "user",
        "content": "你好！"
      }
    ]
  }'
```

**Response example:**

```json
{
  "id": "chatcmpl-B9MBs8CjcvOU2jLn4n570S5qMJKcT",
  "object": "chat.completion",
  "created": 1741569952,
  "model": "gpt-4.1-2025-04-14",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "你好！我能为你提供什么帮助？",
        "refusal": null,
        "annotations": []
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 19,
    "completion_tokens": 10,
    "total_tokens": 29,
    "prompt_tokens_details": {
      "cached_tokens": 0,
      "audio_tokens": 0
    },
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "audio_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  },
  "service_tier": "default"
}
```

### Image Analysis Dialog ✅

```bash
curl https://api.wukong.support/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "user",
        "content": [
          {
            "type": "text",
            "text": "这张图片里有什么？"
          },
          {
            "type": "image_url",
            "image_url": {
              "url": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
            }
          }
        ]
      }
    ],
    "max_tokens": 300
  }'
```

**Response example:**

```json
{
  "id": "chatcmpl-B9MHDbslfkBeAs8l4bebGdFOJ6PeG",
  "object": "chat.completion",
  "created": 1741570283,
  "model": "gpt-4.1-2025-04-14",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "图片展示了一条穿过茂密绿色草地或草甸的木制栈道。天空湛蓝，点缀着几朵散落的云彩，给整个场景营造出宁静祥和的氛围。背景中可以看到树木和灌木丛。",
        "refusal": null,
        "annotations": []
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 1117,
    "completion_tokens": 46,
    "total_tokens": 1163,
    "prompt_tokens_details": {
      "cached_tokens": 0,
      "audio_tokens": 0
    },
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "audio_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  },
  "service_tier": "default",
  "system_fingerprint": "fp_fc9f1d7035"
}
```

### Streaming response ✅

```bash
curl https://api.wukong.support/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "developer",
        "content": "你是一个有帮助的助手。"
      },
      {
        "role": "user",
        "content": "你好！"
      }
    ],
    "stream": true
  }'
```

**Streaming response example:**

```jsonl
{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"gpt-4o-mini", "system_fingerprint": "fp_44709d6fcb", "choices":[{"index":0,"delta":{"role":"assistant","content":""},"logprobs":null,"finish_reason":null}]}

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"gpt-4o-mini", "system_fingerprint": "fp_44709d6fcb", "choices":[{"index":0,"delta":{"content":"你好"},"logprobs":null,"finish_reason":null}]}

// ... 更多数据块 ...

{"id":"chatcmpl-123","object":"chat.completion.chunk","created":1694268190,"model":"gpt-4o-mini", "system_fingerprint": "fp_44709d6fcb", "choices":[{"index":0,"delta":{},"logprobs":null,"finish_reason":"stop"}]}
```

### Function call ✅

```bash
curl https://api.wukong.support/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "user",
        "content": "波士顿今天的天气怎么样？"
      }
    ],
    "tools": [
      {
        "type": "function",
        "function": {
          "name": "get_current_weather",
          "description": "获取指定位置的当前天气",
          "parameters": {
            "type": "object",
            "properties": {
              "location": {
                "type": "string",
                "description": "城市和州，例如 San Francisco, CA"
              },
              "unit": {
                "type": "string",
                "enum": ["celsius", "fahrenheit"]
              }
            },
            "required": ["location"]
          }
        }
      }
    ],
    "tool_choice": "auto"
  }'
```

**Response example:**

```json
{
  "id": "chatcmpl-abc123",
  "object": "chat.completion",
  "created": 1699896916,
  "model": "gpt-4o-mini",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": null,
        "tool_calls": [
          {
            "id": "call_abc123",
            "type": "function",
            "function": {
              "name": "get_current_weather",
              "arguments": "{\n\"location\": \"Boston, MA\"\n}"
            }
          }
        ]
      },
      "logprobs": null,
      "finish_reason": "tool_calls"
    }
  ],
  "usage": {
    "prompt_tokens": 82,
    "completion_tokens": 17,
    "total_tokens": 99,
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  }
}
```

### Logprobs Request ✅

```bash
curl https://api.wukong.support/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "messages": [
      {
        "role": "user",
        "content": "你好！"
      }
    ],
    "logprobs": true,
    "top_logprobs": 2
  }'
```

**Response example:**

```json
{
  "id": "chatcmpl-123",
  "object": "chat.completion",
  "created": 1702685778,
  "model": "gpt-4o-mini",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "你好！我能为你提供什么帮助？"
      },
      "logprobs": {
        "content": [
          {
            "token": "Hello",
            "logprob": -0.31725305,
            "bytes": [72, 101, 108, 108, 111],
            "top_logprobs": [
              {
                "token": "Hello",
                "logprob": -0.31725305,
                "bytes": [72, 101, 108, 108, 111]
              },
              {
                "token": "Hi",
                "logprob": -1.3190403,
                "bytes": [72, 105]
              }
            ]
          },
          {
            "token": "!",
            "logprob": -0.02380986,
            "bytes": [
              33
            ],
            "top_logprobs": [
              {
                "token": "!",
                "logprob": -0.02380986,
                "bytes": [33]
              },
              {
                "token": " there",
                "logprob": -3.787621,
                "bytes": [32, 116, 104, 101, 114, 101]
              }
            ]
          },
          {
            "token": " How",
            "logprob": -0.000054669687,
            "bytes": [32, 72, 111, 119],
            "top_logprobs": [
              {
                "token": " How",
                "logprob": -0.000054669687,
                "bytes": [32, 72, 111, 119]
              },
              {
                "token": "<|end|>",
                "logprob": -10.953937,
                "bytes": null
              }
            ]
          },
          {
            "token": " can",
            "logprob": -0.015801601,
            "bytes": [32, 99, 97, 110],
            "top_logprobs": [
              {
                "token": " can",
                "logprob": -0.015801601,
                "bytes": [32, 99, 97, 110]
              },
              {
                "token": " may",
                "logprob": -4.161023,
                "bytes": [32, 109, 97, 121]
              }
            ]
          },
          {
            "token": " I",
            "logprob": -3.7697225e-6,
            "bytes": [
              32,
              73
            ],
            "top_logprobs": [
              {
                "token": " I",
                "logprob": -3.7697225e-6,
                "bytes": [32, 73]
              },
              {
                "token": " assist",
                "logprob": -13.596657,
                "bytes": [32, 97, 115, 115, 105, 115, 116]
              }
            ]
          },
          {
            "token": " assist",
            "logprob": -0.04571125,
            "bytes": [32, 97, 115, 115, 105, 115, 116],
            "top_logprobs": [
              {
                "token": " assist",
                "logprob": -0.04571125,
                "bytes": [32, 97, 115, 115, 105, 115, 116]
              },
              {
                "token": " help",
                "logprob": -3.1089056,
                "bytes": [32, 104, 101, 108, 112]
              }
            ]
          },
          {
            "token": " you",
            "logprob": -5.4385737e-6,
            "bytes": [32, 121, 111, 117],
            "top_logprobs": [
              {
                "token": " you",
                "logprob": -5.4385737e-6,
                "bytes": [32, 121, 111, 117]
              },
              {
                "token": " today",
                "logprob": -12.807695,
                "bytes": [32, 116, 111, 100, 97, 121]
              }
            ]
          },
          {
            "token": " today",
            "logprob": -0.0040071653,
            "bytes": [32, 116, 111, 100, 97, 121],
            "top_logprobs": [
              {
                "token": " today",
                "logprob": -0.0040071653,
                "bytes": [32, 116, 111, 100, 97, 121]
              },
              {
                "token": "?",
                "logprob": -5.5247097,
                "bytes": [63]
              }
            ]
          },
          {
            "token": "?",
            "logprob": -0.0008108172,
            "bytes": [63],
            "top_logprobs": [
              {
                "token": "?",
                "logprob": -0.0008108172,
                "bytes": [63]
              },
              {
                "token": "?\n",
                "logprob": -7.184561,
                "bytes": [63, 10]
              }
            ]
          }
        ]
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 9,
    "completion_tokens": 9,
    "total_tokens": 18,
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  },
  "system_fingerprint": null
}
```

## 📮 Request

### endpoint

```
POST /v1/chat/completions
```

Creates a model response for a given chat conversation. See the text generation, visuals, and audio guides for more details.

### Authentication method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $API_KEY
```

Among them`$API_KEY` is your API key. You can find or generate an API key on the OpenAI Platform's API Keys page.

### Request body parameters

#### `messages`

- Type: array
- Required: Yes

List of messages containing the conversation so far. Depending on the model used, different message types (forms) are supported, such as text, images, and audio.

| Message type| Description|
|---------|------|
| **Developer message** | Instructions provided by the developer that the model should follow regardless of what messages the user sends. In o1 models and newer, developer messages replace previous system messages. |
| **System message** | Instructions provided by the developer that the model should follow regardless of what messages the user sends. In o1 models and newer, use developer messages instead. |
| **User message** | A message sent by an end user that contains prompts or additional contextual information. |
| **Assistant message** | The model responds to messages sent by user messages. |
| **Tool message** | The content of the tool message. |
| **Function message** | Deprecated. |

**Developer message attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `role` | string| Yes| The role of the message author, here`developer`。 |
| `content` | string or array| Yes| The content of the developer message. Can be text content (a string) or an array of content parts. |
| `name` | string| No| Optional name for the participant. Provide information to the model to differentiate between actors in the same role. |

**System message attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `role` | string| Yes| The role of the message author, here`system`。 |
| `content` | string or array| Yes| The content of the system message. Can be text content (a string) or an array of content parts. |
| `name` | string| No| Optional name for the participant. Provide information to the model to differentiate between actors in the same role. |

**User message attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `role` | string| Yes| The role of the message author, here`user`。 |
| `content` | string or array| Yes| The content of user messages. Can be text content (a string) or an array of content parts. |
| `name` | string| No| Optional name for the participant. Provide information to the model to differentiate between actors in the same role. |

**Content Section Type:**

| Content part type| Description| Available for|
|------------|------|---------|
| **Text content part**| Text input. | All message types|
| **Image Content Section**| Image input. | User messages|
| **Audio Content Section**| Audio input. | User messages|
| **File content part**| File input for text generation. | User messages|
| **Rejected Content Section**| Rejection message generated by the model. | Assistant message|

**Text content part attributes:**

| Properties| Type| required| Description|
|------|------|------|------|
| `text` | string| Yes| Text content. |
| `type` | string| Yes| The type of content section. |

**Image content part attributes:**

| Properties| Type| required| Description|
|------|------|------|------|
| `image_url` | object| Yes| Contains an image URL or base64-encoded image data. |
| `type` | string| Yes| The type of content section. |

**Image URL Object Properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `url` | string| Yes| The URL of the image or the base64-encoded image data. |
| `detail` | string| No| Specifies the detail level of the image. Default is`auto`。 |

**Audio content part properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `input_audio` | object| Yes| Object containing audio data. |
| `type` | string| Yes| The type of content section. always`input_audio`。 |

**Audio input object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `data` | string| Yes| base64 encoded audio data. |
| `format` | string| Yes| The format for encoding audio data. Currently "wav" and "mp3" are supported. |

**File content part attributes:**

| Properties| Type| required| Description|
|------|------|------|------|
| `file` | object| Yes| An object containing file data. |
| `type` | string| Yes| The type of content section. always`file`。 |

**File object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `file_data` | string| No| Base64 encoded file data for passing the file to the model as a string. |
| `file_id` | string| No| The ID of the uploaded file, used as input. |
| `filename` | string| No| Filename used to pass the file to the model as a string. |

**Assistant message attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `role` | string| Yes| The role of the message author, here`assistant`。 |
| `content` | string or array| No| The content of the assistant message. unless specified`tool_calls` or`function_call`, otherwise required. |
| `name` | string| No| Optional name for the participant. Provide information to the model to differentiate between actors in the same role. |
| `audio` | object or null| No| Data about the model's previous audio responses. |
| `function_call` | object or null| No| Deprecated by`tool_calls` substitute. The name and arguments of the function that should be called, generated by the model. |
| `tool_calls` | array| No| Model generated tool calls, such as function calls. |
| `refusal` | string or null| No| Assistant's rejection message. |

**Tool message attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `role` | string| Yes| The role of the message author, here`tool`。 |
| `content` | string or array| Yes| The content of the tool message. |
| `tool_call_id` | string| Yes| The tool call this message responds to. |

**Function message attribute: (deprecated)**

| Properties| Type| required| Description|
|------|------|------|------|
| `role` | string| Yes| The role of the message author, here`function`。 |
| `content` | string or null| Yes| The content of the function message. |
| `name` | string| Yes| The name of the function to be called. |

#### `model`

- Type: string
- Required: Yes

The model ID to use. For more information about which models are available for the Chat API, see the model endpoint compatibility matrix.

#### `store` 

- Type: boolean or null
- Required: No
- Default value: false

Whether to store the output of this chat completion request for use in our model distillation or evaluation products.

#### `reasoning_effort`

- Type: string or null
- Required: No
- Default value: medium
- Only available for o-series models

Constrained inference models work on inference. Currently supported values are`low`、`medium` and`high`. Reducing inference work results in faster responses and reduces the number of tokens used for inference in the response.

#### `metadata`

- Type: map
- Required: No

A collection of 16 key-value pairs that can be attached to an object. This is useful for storing additional information about an object in a structured format, and for querying the object via an API or dashboard.

Keys are strings with a maximum length of 64 characters. The value is a string with a maximum length of 512 characters.

#### `modalities`

- Type: array or null
- Required: No

The type of output you want the model to produce for this request. Most models can generate text, this is the default setting:
["text"]

The model can also be used to generate audio. To request that this model generate both text and audio responses, you can use:
["text", "audio"]

#### `prediction`

- Type: Object
- Required: No

Configuration of prediction outputs, when most of the model's response is known in advance, can greatly improve response times. This is most common when you only make minor changes to a file.

**Possible types:**

| Type| Description|
|------|------|
| **Static content**| Static prediction output content, such as text file content being regenerated with minor changes. |

**Static content attributes:**

| Properties| Type| required| Description|
|------|------|------|------|
| `content` | string or array| Yes| What should be matched when generating the model response. If the generated markup matches this content, the entire model response can be returned faster. |
| `type` | string| Yes| The type of forecast content to provide. The current type is always`content`。 |

**Possible types of content:**

1. **Text Content (String)** - Content to use for prediction output. This is usually the text of the file you are regenerating, with only minor changes.

2. **ContentPartsArray(Array)** - An array of contentparts with a defined type. Supported options vary depending on the model used to generate the response. Can contain text input.

**Content part array properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `text` | string| Yes| Text content. |
| `type` | string| Yes| The type of content section. |

#### `audio`

- Type: object or null
- Required: No

Audio output parameters. when using`modalities: ["audio"]` Required when requesting audio output.

| Properties| Type| required| Description|
|------|------|------|------|
| `format` | string| Yes| Specify the output audio format. Must be one of the following: wav, mp3, flac, opus, or pcm16. |
| `voice` | string| Yes| The model is used to respond to sounds. Supported sounds include: alloy, ash, ballad, coral, echo, fable, nova, onyx, sage, and shimmer. |

#### `temperature`

- Type: number or null
- Required: No
- Default value: 1

The sampling temperature to use, between 0 and 2. Higher values ​​(like 0.8) make the output more random, while lower values ​​(like 0.2) make it more focused and deterministic. We generally recommend changing this value or`top_p`, but don't change both at the same time.

#### `top_p`

- Type: number or null
- Required: No
- Default value: 1

An alternative to sampling temperature is called kernel sampling, where the model considers labeled results with top_p probability mass. Therefore, 0.1 means that only tokens containing the top 10% probability mass are considered.

We generally recommend changing this value or`temperature`, but don't change both at the same time.

#### `n`

- Type: integer or null
- Required: No
- Default value: 1

How many chat completion choices are generated for each input message. Please note that you will be charged based on the number of tags generated for all selections. keep`n` A value of 1 minimizes cost.

#### `stop`

- Type: string/array/null
- Required: No
- Default value: null
- The latest inference models and .o3, o4-mini are not supported

The API will stop generating sequences of up to 4 more tags. The text returned will not contain stop sequences.

#### `max_tokens`

- Type: integer or null
- Required: No

The maximum number of tokens that can be generated in chat completion. This value can be used to control the cost of text generated through the API.

This value is now deprecated and replaced by`max_completion_tokens`, and with`o1` Series models are not compatible.

#### `max_completion_tokens`

- Type: integer or null
- Required: No

The upper limit on the number of tokens that can be generated in completion, including visible output tokens and inference tokens.

#### `presence_penalty`

- Type: number or null
- Required: No
- Default value: 0

A number between -2.0 and 2.0. Positive values ​​penalize new tokens based on their occurrence in the text so far, thereby increasing the likelihood that the model discusses new topics.

#### `frequency_penalty`

- Type: number or null
- Required: No
- Default value: 0

A number between -2.0 and 2.0. Positive values ​​penalize new tokens based on their existing frequency in the text so far, making it less likely that the model will repeat the same line verbatim.

#### `logit_bias`

- Type: map
- Required: No
- Default value: null

Modifies the likelihood that the specified tag appears in completion.

Accepts a JSON object that maps tokens (specified by token IDs in the tokenizer) to associated bias values from -100 to 100. Mathematically, bias is added to the logarithm generated by the model before sampling. The exact effect will vary from model to model, but values ​​between -1 and 1 should reduce or increase the likelihood of selection; values ​​like -100 or 100 should result in the relevant mark being banned or exclusively selected.

#### `logprobs`

- Type: boolean or null
- Required: No
- Default value: false

Whether to return the log probability of the output token. If true, returns`message.content` The log probability of each output token in .

#### `user`

- Type: string
- Required: No

Represents a unique identifier for the end user that helps OpenAI monitor and detect abuse.[Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids)。

#### `service_tier`

- Type: string or null
- Required: No
- Default value: auto

Specifies the latency level used to handle requests. This parameter is relevant for customers subscribed to the scale tier service:

- If set to 'auto' and the project has scale tier enabled, scale tier credits will be used until exhausted
- If set to 'auto' and the project does not have Scale tier enabled, requests will be processed using the default service tier, with a lower uptime SLA and no latency guarantees
- If set to 'default', requests will be processed using the default service tier, with a lower uptime SLA and no latency guarantees
- If set to 'flex', requests will be processed using the Flex Processing service hierarchy. See the documentation for details.
- When not set, the default behavior is 'auto'
- When this parameter is set, the response body will contain the service_tier used

#### `stream_options`

- Type: object or null
- Required: No
- Default value: null

Options for streaming responses. Only in settings`stream: true` when used.

**Possible attributes:**

| Properties| Type| required| Description|
|------|------|------|------|
| `include_usage` | Boolean value| No| If set, will be in data:[DONE] An additional chunk is streamed before the message. The usage field on the block shows token usage statistics for the entire request, and the choices field is always an empty array. All other blocks will also contain a usage field, but with a null value. Note: If the stream is interrupted, you may not receive the final usage block containing the total token usage for the request. |

#### `response_format`

- Type: Object
- Required: No

Specifies the format in which the model must be output.

- set to`{ "type": "json_schema", "json_schema": {...} }` Enable structured output to ensure that the model will match the JSON schema you provide.
- set to`{ "type": "json_object" }` Enable JSON mode to ensure that messages generated by the model are valid JSON.

Important: When using JSON schema, you must also instruct the model to generate JSON yourself via a system or user message. Otherwise, the model may generate endless blanks until the generation reaches the token limit.

**Possible types:**

| Type| Description|
|------|------|
| **text** | Default response format. Used to generate text responses. |
| **json_schema** | JSON Schema response format. Used to generate structured JSON responses. Learn more about structured output. |
| **json_object** | JSON object response format. An older way of generating JSON responses. For supported models, json_schema is recommended. |

**text attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `type` | string| Yes| The type of response format being defined. always`text`。 |

**json_schema attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `json_schema` | object| Yes| Structured output configuration options, including JSON Schema. |
| `type` | string| Yes| The type of response format being defined. always`json_schema`。 |

**json_schema.json_schema attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `name` | string| Yes| The name of the response format. Must be a-z, A-Z, 0-9 or contain underscores and dashes, maximum length is 64. |
| `description` | string| No| A description of the purpose of the response format that the model uses to determine how to respond in that format. |
| `schema` | object| No| The schema of the response format, described as a JSON Schema object. |
| `strict` | boolean or null| No| Whether to enable strict schema compliance when generating output. If set to true, the model will always follow the exact schema defined in the schema field. When strict is true, only a subset of JSON Schema is supported. |

**json_object attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `type` | string| Yes| The type of response format being defined. always`json_object`。 |

#### `seed`

- Type: integer or null
- Required: No
Beta features. If specified, our system will do a best-effort deterministic sampling such that repeated requests with the same seed and parameters should return the same results. Determinism is not guaranteed and you should refer to the system_fingerprint of the response parameters to monitor the backend for changes.

#### `tools`

- Type: array
- Required: No

A list of tools that the model may call. Currently only functions are supported as tools. Use this parameter to provide a list of functions for which the model may generate JSON input. Up to 128 functions are supported.

**Properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `function` | object| Yes| Function information to be called|
| `type` | string| Yes| Type of tool. Currently, only functions are supported. |

**function attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `name` | string| Yes| The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, maximum length is 64. |
| `description` | string| No| A description of what a function does, which the model uses to choose when and how to call the function. |
| `parameters` | object| No| The parameters accepted by the function are described as JSON Schema objects. See the guide for examples, and the JSON Schema reference for format documentation. Omitting parameters defines a function with an empty parameter list. |
| `strict` | boolean or null| No| Default value: false. Whether to enable strict architecture compliance when generating function calls. If set to true, the model will follow the exact schema defined in the parameters field. When strict is true, only a subset of JSON Schema is supported. See the Structured Output section of the Function Calling Guide for details. |

#### `functions`

- Type: array
- Required: No
- NOTE: Deprecated, recommended`tools`

A model may generate a list of functions as JSON input.

| Properties| Type| required| Description|
|------|------|------|------|
| `name` | string| Yes| The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, maximum length is 64. |
| `description` | string| No| A description of what a function does, which the model uses to choose when and how to call the function. |
| `parameters` | object| No| The parameters accepted by the function are described as JSON Schema objects. Omitting parameters defines a function with an empty parameter list. |

#### `tool_choice`

- Type: string or object
- Required: No

Control which tool (if any) the model calls:
- `none`: The model does not call any tools, but generates messages
- `auto`: Models can choose between generating messages or calling one or more tools
- `required`: The model must call one or more tools
- `{"type": "function", "function": {"name": "my_function"}}`: Force the model to call a specific tool

Defaults to`none`, the default is`auto`。

**Possible types:**

| Type| Description|
|------|------|
| **String**| none means that the model does not call any tools and instead generates messages. auto means that the model can choose between generating a message or calling one or more tools. required indicates that the model must call one or more tools. |
| **Object**| Specifies the tool that the model should use. Used to force the model to call a specific function. |

**Object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `function` | object| Yes| Object containing function information|
| `type` | string| Yes| Type of tool. Currently, only functions are supported. |

**function attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `name` | string| Yes| The name of the function to be called. |

#### `function_call`

- Type: string or object
- Required: No
- Default value: without function`none`, when there is a function`auto`
- NOTE: Deprecated, recommended`tool_choice`

Control which function (if any) the model calls:

- `none`: The model does not call a function, but generates a message
- `auto`: Models can choose between generating messages or calling functions
- `{"name": "my_function"}`: Force the model to call a specific function

**Object type properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `name` | string| Yes| The name of the function to be called. |

#### `parallel_tool_calls`

- Type: boolean
- Required: No
- Default value: true

Whether to enable parallel function calls during tool use.

#### `stream`

- Type: boolean or null
- Required: No
- Default value: false

If set to true, model response data will be streamed to the client via server-sent events when generated. See the Streaming Responses section below for more information, and the Streaming Responses guide to learn how to handle streaming events.

#### `top_logprobs`

- Type: integer or null
- Required: No

An integer between 0 and 20 specifying the number of most likely tags to return at each tag position, with each tag having an associated log probability. If this parameter is used, the`logprobs` Set to true.

#### `web_search_options`

- Type: Object
- Required: No

This tool searches the web for relevant results for replies. Learn more about web search tools.

**Possible attributes:**

| Properties| Type| required| Description|
|------|------|------|------|
| `search_context_size` | string| No| Default value: medium. High-level guidance on the amount of context window space used for searches. Optional values ​​are low, medium, or high. medium is the default value. |
| `user_location` | object or null| No| Approximate position parameters to search for. |

**user_location attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `approximate` | object| Yes| Approximate position parameters to search for. |

**approximate attribute:**

| Properties| Type| required| Description|
|------|------|------|------|
| `city` | string| No| Free text input for the user's city, such as San Francisco. |
| `country` | string| No| The user's two-letter ISO country code, such as US. |
| `region` | string| No| Free text input for the user's locale, such as California. |
| `timezone` | string| No| The user's IANA time zone, such as America/Los_Angeles. |
| `type` | string| Yes| Location approximation type. Always approximate. |

## 📥Response

### Chat completion object

Returns a chat completion object or, if the request is streamed, a streaming sequence of chat completion block objects.

#### `id` 
- Type: string
- Description: The unique identifier of the response

#### `object`
- Type: string
- Description: Object type, value is "chat.completion"

#### `created`
- Type: integer
- Description: Response creation timestamp

#### `model`
- Type: string
- Description: Model name used

#### `system_fingerprint`
- Type: string
- Description: System fingerprint identifier, indicating the backend configuration of model running. Can be used with the seed request parameter to understand when backend changes have been made that may affect determinism.

#### `choices`
- Type: array
- Description: Contains the generated list of reply options. If n is greater than 1, there can be multiple options.
- Properties:
  - `index`: The index of the option in the options list.
  - `message`: Chat completion message generated by the model.
    - `role`: The role of the message author.
    - `content`: The content of the message, may be null.
    - `refusal`: The rejection message generated by the model, may be null.
    - `annotations`: Comments for the message, provided when applicable, such as when using a web search tool.
      - `type`: Annotation type, always "url_citation" when quoted by URL.
      - `url_citation`: URL reference when using web search.
        - `start_index`: The index of the first character in the message that the URL refers to.
        - `end_index`: The index of the last character of the URL reference in the message.
        - `url`: URL of network resource.
        - `title`: The title of the network resource.
    - `audio`: If the audio output modal is requested, this object contains data from the model's audio response.
      - `data`: Base64 encoded audio bytes generated by the model, the format is specified in the request.
      - `id`: A unique identifier for this audio response.
      - `transcript`: Transcription of audio generated by the model.
      - `expires_at`: The Unix timestamp (in seconds) at which this audio response was available on the server for multiple rounds of conversation.
    - `function_call`: (Deprecated) The name and arguments of the function that should be called, generated by the model. has been`tool_calls` substitute.
      - `name`: The name of the function to be called.
      - `arguments`: Parameters used to call the function, generated by the model in JSON format.
    - `tool_calls`: Tool calls for model generation, such as function calls.
      - `id`: ID of tool call.
      - `type`: Type of tool. Currently, only functions are supported.
      - `function`: Function called by the model.
        - `name`: The name of the function to be called.
        - `arguments`: Parameters used to call the function, generated by the model in JSON format. Note that the model does not always produce valid JSON and may produce parameters that are not defined in your function schema. Before calling a function, verify the parameters in your code.
  - `logprobs`: Log probability information.
    - `content`: List of message content tags with log probability information.
      - `token`: mark.
      - `logprob`: The log probability of this token if it is within the top 20 most likely tokens. Otherwise, using a value of -9999.0 indicates that this tag is very unlikely.
      - `bytes`: A list of integers representing the UTF-8 byte representation of the tag. Useful in situations where a character is represented by multiple tokens and their byte representations must be combined to produce a correct textual representation. May be null if the tag has no byte representation.
      - `top_logprobs`: A list of the most likely markers at this marker position and their logarithmic probabilities. In rare cases, the number of top_logprobs returned may be less than the number requested.
    - `refusal`: List of message rejection markers with log probability information.
  - `finish_reason`: The reason why the model stopped generating markers. "stop" if the model reaches a natural stopping point or a provided stopping sequence, "length" if the maximum number of tokens specified in the request is reached, "content_filter" if content is omitted due to a content filter token, "tool_calls" if the model calls a tool, or "function_call" (deprecated) if the model calls a function.

#### `usage`
- Type: Object
- Description: Usage statistics of completion requests.
- Properties:
  - `prompt_tokens`: Number of tokens in the prompt.
  - `completion_tokens`: The number of tokens in the generated completion.
  - `total_tokens`: Total number of tokens used in the request (hints + completions).
  - `prompt_tokens_details`: A breakdown of the tags used in the prompt.
    - `cached_tokens`: The cache tag present in the prompt.
    - `audio_tokens`: Audio input tag present in the prompt.
  - `completion_tokens_details`: A breakdown of the tokens used in completion.
    - `reasoning_tokens`: Inference token generated by the model.
    - `audio_tokens`: Audio tokens generated by the model.
    - `accepted_prediction_tokens`: When using prediction output, the number of tokens predicted to appear in the completion.
    - `rejected_prediction_tokens`: When using prediction output, the number of tokens in prediction that do not appear in completion. However, like inference tokens, these tokens still count toward total completion tokens for billing, output, and context window limits.

#### `service_tier`
- Type: string or null
- Description: Specifies the latency level used to process requests. This parameter is relevant for customers subscribed to the scale tier service:
  - If set to 'auto' and the project has scale tier enabled, scale tier credits will be used until exhausted
  - If set to 'auto' and the project does not have Scale tier enabled, requests will be processed using the default service tier, with a lower uptime SLA and no latency guarantees
  - If set to 'default', requests will be processed using the default service tier, with a lower uptime SLA and no latency guarantees
  - If set to 'flex', requests will be processed using the Flex Processing service hierarchy
  - When not set, the default behavior is 'auto'
  - When this parameter is set, the response body will contain the service_tier used

#### Chat completion object response example

```json
{
  "id": "chatcmpl-B9MHDbslfkBeAs8l4bebGdFOJ6PeG",
  "object": "chat.completion",
  "created": 1741570283,
  "model": "gpt-4o-2024-08-06",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "图片展示了一条穿过茂密绿色草地或草甸的木制栈道。天空湛蓝，点缀着几朵散落的云彩，给整个场景营造出宁静祥和的氛围。背景中可以看到树木和灌木丛。",
        "refusal": null,
        "annotations": []
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 1117,
    "completion_tokens": 46,
    "total_tokens": 1163,
    "prompt_tokens_details": {
      "cached_tokens": 0,
      "audio_tokens": 0
    },
    "completion_tokens_details": {
      "reasoning_tokens": 0,
      "audio_tokens": 0,
      "accepted_prediction_tokens": 0,
      "rejected_prediction_tokens": 0
    }
  },
  "service_tier": "default",
  "system_fingerprint": "fp_fc9f1d7035"
}
```

### Chat completion list object

When multiple chat completions are returned, the API may return a chat completion list object.

#### `object`
- Type: string
- Description: Object type, always "list"

#### `data`
- Type: array
- Description: Array of chat completion objects

#### `first_id`
- Type: string
- Description: The identifier of the first chat completion in the data array

#### `last_id`
- Type: string
- Description: The identifier of the last chat completion in the data array

#### `has_more`
- Type: boolean
- Description: Indicates whether more chat completions are available

#### Chat completion list response example

```json
{
  "object": "list",
  "data": [
    {
      "object": "chat.completion",
      "id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2",
      "model": "gpt-4o-2024-08-06",
      "created": 1738960610,
      "request_id": "req_ded8ab984ec4bf840f37566c1011c417",
      "tool_choice": null,
      "usage": {
        "total_tokens": 31,
        "completion_tokens": 18,
        "prompt_tokens": 13
      },
      "seed": 4944116822809979520,
      "top_p": 1.0,
      "temperature": 1.0,
      "presence_penalty": 0.0,
      "frequency_penalty": 0.0,
      "system_fingerprint": "fp_50cad350e4",
      "input_user": null,
      "service_tier": "default",
      "tools": null,
      "metadata": {},
      "choices": [
        {
          "index": 0,
          "message": {
            "content": "电路之心低吟，\n在寂静中学习模式—\n未来的宁静火花。",
            "role": "assistant",
            "tool_calls": null,
            "function_call": null
          },
          "finish_reason": "stop",
          "logprobs": null
        }
      ],
      "response_format": null
    }
  ],
  "first_id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2",
  "last_id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2",
  "has_more": false
}
```

### Chat completion message list object

The chat completion message list object represents a list of chat messages.

#### `object`
- Type: string
- Description: Object type, always "list"

#### `data`
- Type: array
- Description: An array of chat completion message objects. Each message object contains the following properties:
  - `id`: Identifier of the chat message
  - `role`: The role of the message author
  - `content`: the content of the message, may be null
  - `name`: The name of the message sender, may be null
  - `refusal`: The rejection message generated by the model, may be null
  - `annotations`: Comments for the message, provided when applicable, such as when using a web search tool
    - `type`: Annotation type, always "url_citation" when quoted by URL
    - `url_citation`: URL reference when using web search
      - `start_index`: The index of the first character in the message that the URL refers to
      - `end_index`: The index of the last character in the message that the URL refers to
      - `url`: URL of network resource
      - `title`: The title of the network resource
  - `audio`: If the audio output modal is requested, this object contains data from the model's audio response
    - `data`: Base64 encoded audio bytes generated by the model, the format is specified in the request
    - `id`: A unique identifier for this audio response
    - `transcript`: Transcription of audio generated by the model
    - `expires_at`: The Unix timestamp (in seconds) at which this audio response was available on the server for multiple rounds of conversation
  - `function_call`: (Deprecated) The name and arguments of the function that should be called, generated by the model. has been`tool_calls` substitute
    - `name`: the name of the function to be called
    - `arguments`: Parameters used to call the function, generated by the model in JSON format
  - `tool_calls`: Tool calls for model generation, such as function calls
    - `id`: ID of tool call
    - `type`: Type of tool. Currently, only functions are supported
    - `function`: Function called by the model
      - `name`: the name of the function to be called
      - `arguments`: Parameters used to call the function, generated by the model in JSON format

#### `first_id`
- Type: string
- Description: The identifier of the first chat message in the data array

#### `last_id`
- Type: string
- Description: The identifier of the last chat message in the data array

#### `has_more`
- Type: boolean
- Description: Indicates whether more chat messages are available

#### Chat completion message list response example

```json
{
  "object": "list",
  "data": [
    {
      "id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2-0",
      "role": "user",
      "content": "写一首关于人工智能的俳句",
      "name": null,
      "content_parts": null
    }
  ],
  "first_id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2-0",
  "last_id": "chatcmpl-AyPNinnUqUDYo9SAdA52NobMflmj2-0",
  "has_more": false
}
```