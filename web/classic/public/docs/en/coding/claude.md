# Anthropic conversation format (Messages)

!!! info "Official Documentation"
    - [Anthropic Messages](https://docs.anthropic.com/en/api/messages)
    - [Anthropic Streaming Messages](https://docs.anthropic.com/en/api/messages-streaming)

## 📝 Introduction

Given a set of structured input message lists containing text and/or image content, the model generates the next message in the conversation. The Messages API can be used for a single query or for stateless multi-turn conversations.

## 💡 Request example

### Basic text conversation ✅

```bash
curl https://api.wukong.support/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $API_KEY" \
     --data \
'{
    "model": "claude-sonnet-4-5-20250929",
    "max_tokens": 1024,
    "messages": [
        {"role": "user", "content": "Hello, world"}
    ]
}'
```

**Response example:**
```json
{
  "content": [
    {
      "text": "Hi! My name is Claude.",
      "type": "text"
    }
  ],
  "id": "msg_013Zva2CMHLNnXjNJKqJ2EF",
  "model": "claude-sonnet-4-5-20250929", 
  "role": "assistant",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "type": "message",
  "usage": {
    "input_tokens": 2095,
    "output_tokens": 503
  }
}
```

### Image Analysis Dialog ✅

```bash
curl https://api.wukong.support/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $API_KEY" \
     --data \
'{
    "model": "claude-sonnet-4-5-20250929",
    "messages": [
        {
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": "image/jpeg",
                        "data": "/9j/4AAQSkZJRg..."
                    }
                },
                {
                    "type": "text",
                    "text": "这张图片里有什么?"
                }
            ]
        }
    ]
}'
```

**Response example:**
```json
{
  "content": [
    {
      "text": "这张图片显示了一只橙色的猫咪正在窗台上晒太阳。猫咪看起来很放松，眯着眼睛享受阳光。窗外可以看到一些绿色的植物。",
      "type": "text"
    }
  ],
  "id": "msg_013Zva2CMHLNnXjNJKqJ2EF",
  "model": "claude-sonnet-4-5-20250929",
  "role": "assistant",
  "stop_reason": "end_turn",
  "stop_sequence": null,
  "type": "message",
  "usage": {
    "input_tokens": 3050,
    "output_tokens": 892
  }
}
```

### Tool call ✅

```bash
curl https://api.wukong.support/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $API_KEY" \
     --data \
'{
    "model": "claude-sonnet-4-5-20250929",
    "messages": [
        {
            "role": "user", 
            "content": "今天北京的天气怎么样?"
        }
    ],
    "tools": [
        {
            "name": "get_weather",
            "description": "获取指定位置的当前天气",
            "input_schema": {
                "type": "object",
                "properties": {
                    "location": {
                        "type": "string",
                        "description": "城市名称,如:北京"
                    }
                },
                "required": ["location"]
            }
        }
    ]
}'
```

**Response example:**
```json
{
  "content": [
    {
      "type": "tool_use",
      "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
      "name": "get_weather",
      "input": { "location": "北京" }
    }
  ],
  "id": "msg_013Zva2CMHLNnXjNJKqJ2EF",
  "model": "claude-sonnet-4-5-20250929",
  "role": "assistant",
  "stop_reason": "tool_use",
  "stop_sequence": null,
  "type": "message",
  "usage": {
    "input_tokens": 2156,
    "output_tokens": 468
  }
}
```

### Streaming response ✅

```bash
curl https://api.wukong.support/v1/messages \
     --header "anthropic-version: 2023-06-01" \
     --header "content-type: application/json" \
     --header "x-api-key: $API_KEY" \
     --data \
'{
    "model": "claude-sonnet-4-5-20250929",
    "messages": [
        {
            "role": "user",
            "content": "讲个故事"
        }
    ],
    "stream": true
}'
```

**Response example:**
```json
{
  "type": "message_start",
  "message": {
    "id": "msg_013Zva2CMHLNnXjNJKqJ2EF",
    "model": "claude-sonnet-4-5-20250929",
    "role": "assistant",
    "type": "message"
  }
}
{
  "type": "content_block_start",
  "index": 0,
  "content_block": {
    "type": "text"
  }
}
{
  "type": "content_block_delta",
  "index": 0,
  "delta": {
    "text": "从前"
  }
}
{
  "type": "content_block_delta",
  "index": 0,
  "delta": {
    "text": "有一只"
  }
}
{
  "type": "content_block_delta",
  "index": 0,
  "delta": {
    "text": "小兔子..."
  }
}
{
  "type": "content_block_stop",
  "index": 0
}
{
  "type": "message_delta",
  "delta": {
    "stop_reason": "end_turn",
    "usage": {
      "input_tokens": 2045,
      "output_tokens": 628
    }
  }
}
{
  "type": "message_stop"
}
```

## 📮 Request

### endpoint

```
POST /v1/messages
```

### Authentication method

Include the following in the request header for API key authentication:

```
x-api-key: $API_KEY
```

Among them`$API_KEY` is your API key. You can obtain API keys through the console, and each key is limited to one workspace.

### Request header parameters

#### `anthropic-beta`

- Type: string
- Required: No

Specify the beta version to use, a comma separated list is supported such as`beta1,beta2`, or specify the request header multiple times.

#### `anthropic-version`

- Type: string
- Required: Yes

Specify the API version to use.

### Request body parameters

#### `max_tokens`

- Type: integer
- Required: Yes

The maximum number of tokens generated. Different models have different restrictions, see the model documentation for details. range`x > 1`。

#### `messages`

- Type: array of objects
- Required: Yes

Enter the message list. The model is trained to alternate conversations between the user and the assistant. When creating a new message, you can specify a previous conversation turn using the messages parameter, and the model will generate the next message in the conversation. Consecutive user or assistant messages are merged into a single turn.

Each message must contain`role` and`content` field. You can specify a single user role message, or include multiple user and assistant messages. If the last message uses the helper role, the response content will continue directly from the content of that message, which can be used to constrain the model's response.

**Single user message example:**
```json
[{"role": "user", "content": "Hello, Claude"}]
```

**Multiple rounds of dialogue example:**
```json
[
  {"role": "user", "content": "你好。"},
  {"role": "assistant", "content": "你好！我是 Claude。有什么可以帮你的吗？"},
  {"role": "user", "content": "请用简单的话解释什么是 LLM？"}
]
```

**Example of partially populated response:**
```json
[
  {"role": "user", "content": "太阳的希腊语名字是什么? (A) Sol (B) Helios (C) Sun"},
  {"role": "assistant", "content": "正确答案是 ("}
]
```

The content of each message can be a string or an array of content blocks. Using a string is shorthand for an array of content blocks of type "text". The following two ways of writing are equivalent:

```json
{"role": "user", "content": "Hello, Claude"}
```

```json
{
  "role": "user", 
  "content": [{"type": "text", "text": "Hello, Claude"}]
}
```

Starting with the Claude 3 model, you can also send image content blocks:

```json
{
  "role": "user",
  "content": [
    {
      "type": "image",
      "source": {
        "type": "base64",
        "media_type": "image/jpeg",
        "data": "/9j/4AAQSkZJRg..."
      }
    },
    {
      "type": "text",
      "text": "这张图片里有什么?"
    }
  ]
}
```

> Currently supported image formats include: base64, image/jpeg, image/png, image/gif and image/webp.

##### `messages.role`

- Type: enum string
- Required: Yes
- Optional values: user, assistant

Note: There is no "system" role in the Messages API. If you need system prompts, please use the top-level system parameter.

##### `messages.content`

- Type: string or array of objects
- Required: Yes

Message content can be one of the following types:

###### Text content (Text)

```json
{
  "type": "text",          // 必需，枚举值: "text"
  "text": "Hello, Claude", // 必需，最小长度: 1
  "cache_control": {
    "type": "ephemeral"    // 可选，枚举值: "ephemeral"
  }
}
```

###### Image content (Image)

```json
{
  "type": "image",         // 必需，枚举值: "image"
  "source": {             // 必需
    "type": "base64",     // 必需，枚举值: "base64"
    "media_type": "image/jpeg", // 必需，支持: image/jpeg, image/png, image/gif, image/webp
    "data": "/9j/4AAQSkZJRg..."  // 必需，base64 编码的图片数据
  },
  "cache_control": {
    "type": "ephemeral"    // 可选，枚举值: "ephemeral"
  }
}
```

###### Tool Use

```json
{
  "type": "tool_use",      // 必需，枚举值: "tool_use"，默认值
  "id": "toolu_xyz...",    // 必需，工具使用的唯一标识符
  "name": "get_weather",   // 必需，工具名称，最小长度: 1
  "input": {              // 必需，工具的输入参数对象
    // 工具输入参数，具体格式由工具的 input_schema 定义
  },
  "cache_control": {
    "type": "ephemeral"    // 可选，枚举值: "ephemeral"
  }
}
```

###### Tool Result

```json
{
  "type": "tool_result",   // 必需，枚举值: "tool_result"
  "tool_use_id": "toolu_xyz...",  // 必需
  "content": "结果内容",   // 必需，可以是字符串或内容块数组
  "is_error": false,      // 可选，布尔值
  "cache_control": {
    "type": "ephemeral"    // 可选，枚举值: "ephemeral"
  }
}
```

When content is an array of content blocks, each content block can be text or an image:

```json
{
  "type": "tool_result",
  "tool_use_id": "toolu_xyz...",
  "content": [
    {
      "type": "text",      // 必需，枚举值: "text"
      "text": "分析结果",   // 必需，最小长度: 1
      "cache_control": {
        "type": "ephemeral" // 可选，枚举值: "ephemeral"
      }
    },
    {
      "type": "image",     // 必需，枚举值: "image"
      "source": {         // 必需
        "type": "base64", // 必需，枚举值: "base64"
        "media_type": "image/jpeg",
        "data": "..."
      },
      "cache_control": {
        "type": "ephemeral"
      }
    }
  ]
}
```

###### Document

```json
{
  "type": "document",      // 必需，枚举值: "document"
  "source": {             // 必需
    // 文档源数据
  },
  "cache_control": {
    "type": "ephemeral"    // 可选，枚举值: "ephemeral"
  }
}
```

Note:
1. Each type can contain optional`cache_control` Field used to control the caching behavior of content
2. Minimum length of text content is 1
3. The type field of all types is a required enumeration string
4. The content field of the tool results supports a string or an array of content blocks containing text/images

#### `model`

- Type: string
- Required: Yes

The model name to use, as detailed in the model documentation. range`1 - 256` characters.

#### `metadata`

- Type: Object
- Required: No

An object describing request metadata. Contains the following optional fields:

- `user_id`: The external identifier of the user associated with the request. Should be a uuid, hash, or other opaque identifier. Do not include any identifying information such as name, email, or phone number. Maximum length: 256.

#### `stop_sequences`

- Type: string array
- Required: No

Custom text sequence to stop generation.

#### `stream`

- Type: boolean
- Required: No

Whether to use server-sent events (SSE) to incrementally return response content.

#### `system`

- Type: string
- Required: No

A system prompt that provides context and instructions for Claude. This is a way of providing context and a specific goal or role to the model. Note that this is different from the role in messages, there is no "system" role in the Messages API.

#### `temperature`

- Type: number
- Required: No
- Default: 1.0

Controls generation randomness, 0.0 - 1.0. range`0 < x < 1`. It is recommended to use values ​​close to 0.0 for analytical/multiple choice type tasks and values ​​close to 1.0 for creative and generative tasks.

Note: Even if temperature is set to 0.0, the results will not be completely certain.

#### 🆕 `thinking`

- Type: Object
- Required: No

Configure Claude's extended thinking capabilities. When enabled, the response will contain a content block showing Claude's thought process before giving his final answer. A minimum budget of 1,024 tokens is required and counts towards your max_tokens limit.

Can be set to one of two modes:

##### 1. enable mode

```json
{
  "type": "enabled",
  "budget_tokens": 2048
}
```

- `type`: required, enumeration value: "enabled"
- `budget_tokens`: required, integer. Determines the number of tokens that Claude can use for its internal reasoning process. A larger budget allows the model to conduct deeper analysis of complex problems and improve the quality of responses. Must be ≥1024 and less than max_tokens. range`x > 1024`。

##### 2. disabled mode

```json
{
  "type": "disabled"
}
```

- `type`: required, enumeration value: "disabled"

#### `tool_choice`

- Type: Object
- Required: No

Controls how the model uses the provided tools. Can be one of three types:

##### 1. Auto mode (automatic selection)

```json
{
  "type": "auto",  // 必需，枚举值: "auto"
  "disable_parallel_tool_use": false  // 可选，默认 false。如果为 true，模型最多只会使用一个工具
}
```

##### 2. Any mode (any tool)

```json
{
  "type": "any",  // 必需，枚举值: "any"
  "disable_parallel_tool_use": false  // 可选，默认 false。如果为 true，模型将恰好使用一个工具
}
```

##### 3. Tool mode (specified tool)

```json
{
  "type": "tool",  // 必需，枚举值: "tool"
  "name": "get_weather",  // 必需，指定要使用的工具名称
  "disable_parallel_tool_use": false  // 可选，默认 false。如果为 true，模型将恰好使用一个工具
}
```

Note:
1. Auto mode: the model can decide whether to use tools on its own
2. Any mode: The model must use tools, but any available tool can be selected
3. Tool mode: The model must use the specified tool

#### `tools`

- Type: array of objects
- Required: No

Defines the tools that the model may use. Tools can be custom tools or built-in tool types:

##### 1. Custom tools (Tool)

Each custom tool definition contains:

- `type`: Optional, enumeration value: "custom"
- `name`: Tool name, required, 1-64 characters
- `description`: Tool description, it is recommended to be as detailed as possible
- `input_schema`: JSON Schema definition of tool input, required
- `cache_control`: Cache control, optional, type is "ephemeral"

Example:
```json
[
  {
    "type": "custom",
    "name": "get_weather",
    "description": "获取指定位置的当前天气",
    "input_schema": {
      "type": "object",
      "properties": {
        "location": {
          "type": "string",
          "description": "城市名称,如:北京"
        }
      },
      "required": ["location"]
    }
  }
]
```

##### 2. ComputerUseTool

```json
{
  "type": "computer_20241022",  // 必需
  "name": "computer",           // 必需，枚举值: "computer"
  "display_width_px": 1024,     // 必需，显示宽度(像素)
  "display_height_px": 768,     // 必需，显示高度(像素)
  "display_number": 0,          // 可选，X11 显示编号
  "cache_control": {
    "type": "ephemeral"         // 可选
  }
}
```

##### 3. Bash Tool (BashTool)

```json
{
  "type": "bash_20241022",      // 必需
  "name": "bash",               // 必需，枚举值: "bash"
  "cache_control": {
    "type": "ephemeral"         // 可选
  }
}
```

##### 4. Text Editor Tool (TextEditor)

```json
{
  "type": "text_editor_20241022", // 必需
  "name": "str_replace_editor",   // 必需，枚举值: "str_replace_editor"
  "cache_control": {
    "type": "ephemeral"           // 可选
  }
}
```

When the model uses a tool, the tool_use content block is returned:

```json
[
  {
    "type": "tool_use",
    "id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    "name": "get_weather",
    "input": { "location": "北京" }
  }
]
```

You can execute a tool and return the result via the tool_result content block:

```json
[
  {
    "type": "tool_result",
    "tool_use_id": "toolu_01D7FLrfh4GYq7yT1ULFeyMV",
    "content": "北京当前天气晴朗，温度 25°C"
  }
]
```

#### `top_k`

- Type: integer
- Required: No
- Range: x > 0

Sample from the top K options of token. Used to remove low probability "long tail" responses. Recommended for use only in advanced use cases, which usually only require adjusting the temperature.

#### `top_p`

- Type: number
- Required: No
- Range: 0< x < 1

Use nucleus sampling. Calculate the cumulative distribution of each subsequent token in descending order of probability, truncating when the probability specified by top_p is reached. It is recommended to adjust only one of temperature or top_p, not both.

## 📥Response

### successful response

Returns a chat completion object containing the following fields:

#### `content`

- Type: array of objects
- Required: Yes

The content generated by the model consists of multiple content blocks. Each content block has a type that determines its shape. Content blocks can be one of the following types:

##### Text content block (Text)

```json
{
  "type": "text",          // 必需，枚举值: "text"，默认值
  "text": "你好，我是 Claude。" // 必需，最大长度: 5000000，最小长度: 1
}
```

##### Tool Use content block (Tool Use)

```json
{
  "type": "tool_use",      // 必需，枚举值: "tool_use"，默认值
  "id": "toolu_xyz...",    // 必需，工具使用的唯一标识符
  "name": "get_weather",   // 必需，工具名称，最小长度: 1
  "input": {              // 必需，工具的输入参数对象
    // 工具输入参数，具体格式由工具的 input_schema 定义
  }
}
```

Example:
```json
// 文本内容示例
[{"type": "text", "text": "你好，我是 Claude。"}]

// 工具使用示例
[{
  "type": "tool_use",
  "id": "toolu_xyz...",
  "name": "get_weather",
  "input": { "location": "北京" }
}]

// 混合内容示例
[
  {"type": "text", "text": "根据天气查询结果："},
  {
    "type": "tool_use",
    "id": "toolu_xyz...",
    "name": "get_weather",
    "input": { "location": "北京" }
  }
]
```

If the last message requested was a helper role, the response content continues directly from that message. For example:

```json
// 请求
[
  {"role": "user", "content": "太阳的希腊语名字是什么? (A) Sol (B) Helios (C) Sun"},
  {"role": "assistant", "content": "正确答案是 ("}
]

// 响应
[{"type": "text", "text": "B)"}]
```

#### `id`

- Type: string
- Required: Yes

The unique identifier of the response.

#### `model`

- Type: string
- Required: Yes

The model name to use.

#### `role`

- Type: enum string
- Required: Yes
- Default value: assistant

The session role that generated the message, always "assistant".

#### `stop_reason`

- Type: enum string or null
- Required: Yes

Reason to stop generation, possible values include:

- `"end_turn"`: The model reaches a natural stopping point
- `"max_tokens"`: Requested max_tokens or model's maximum limit exceeded
- `"stop_sequence"`: Generated one of the custom stop sequences
- `"tool_use"`: The model calls one or more tools

In non-streaming mode, this value is always non-null. In streaming mode, null in the message_start event, non-null otherwise.

#### `stop_sequence`

- Type: string or null
- Required: Yes

Generated custom stop sequence. If the model encounters one of the sequences specified in the stop_sequences parameter, this field will contain the matching stop sequence. If not stopped due to a stopping sequence, null.

#### `type`

- Type: enum string
- Required: Yes
- Default value: message
- Optional value: message

Object type, always "message" for Messages.

#### `usage`

- Type: Object
- Required: Yes

Usage statistics related to billing and current limiting. Contains the following fields:

- `input_tokens`: The number of input tokens used, required, range x > 0
- `output_tokens`: Number of output tokens used, required, range x > 0
- `cache_creation_input_tokens`: Number of input tokens used to create the cache entry (if applicable), required, range x > 0
- `cache_read_input_tokens`: number of input tokens read from cache (if applicable), required, range x > 0

Note: Because the API converts and parses requests internally, the token count may not exactly correspond to the actual visible content of the request and response. For example, output_tokens will be non-zero even for an empty string response.

### error response

When there is a problem with a request, the API will return an error response object with an HTTP status code in the 4XX-5XX range.

#### Common error status codes

- `401 Unauthorized`: API key is invalid or not provided
- `400 Bad Request`: Invalid request parameters
- `429 Too Many Requests`: API call limit exceeded
- `500 Internal Server Error`: Server internal error

Error response example:

```json
{
  "error": {
    "type": "invalid_request_error",
    "message": "Invalid API key provided",
    "code": "invalid_api_key"
  }
}
```

Main error types:

- `invalid_request_error`: Request parameter error
- `authentication_error`: Authentication related errors
- `rate_limit_error`: Request frequency exceeds limit
- `server_error`: Server internal error