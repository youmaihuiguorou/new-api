# Google Gemini Conversation Format (Generate Content)

!!! info "Official Documentation"
    [Google Gemini Generating content API](https://ai.google.dev/api/generate-content)

## 📝 Introduction

The Google Gemini API supports content generation using images, audio, code, tools, and more. GenerateContentRequest generates a model response given input. Supports multiple functions such as text generation, visual understanding, audio processing, long context, code execution, JSON schema, function calling, etc.

## 💡 Request example

### Basic text conversation ✅

```bash
curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
      "contents": [{
        "parts":[{"text": "Write a story about a magic backpack."}]
        }]
       }' 2> /dev/null
```

### Image Analysis Dialog ✅

```bash
# 使用临时文件保存base64编码的图片数据
TEMP_B64=$(mktemp)
trap 'rm -f "$TEMP_B64"' EXIT
base64 $B64FLAGS $IMG_PATH > "$TEMP_B64"

# 使用临时文件保存JSON载荷
TEMP_JSON=$(mktemp)
trap 'rm -f "$TEMP_JSON"' EXIT

cat > "$TEMP_JSON" << EOF
{
  "contents": [{
    "parts":[
      {"text": "Tell me about this instrument"},
      {
        "inline_data": {
          "mime_type":"image/jpeg",
          "data": "$(cat "$TEMP_B64")"
        }
      }
    ]
  }]
}
EOF

curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d "@$TEMP_JSON" 2> /dev/null
```

### Function call ✅

```bash
cat > tools.json << EOF
{
  "function_declarations": [
    {
      "name": "enable_lights",
      "description": "Turn on the lighting system."
    },
    {
      "name": "set_light_color",
      "description": "Set the light color. Lights must be enabled for this to work.",
      "parameters": {
        "type": "object",
        "properties": {
          "rgb_hex": {
            "type": "string",
            "description": "The light color as a 6-digit hex string, e.g. ff0000 for red."
          }
        },
        "required": [
          "rgb_hex"
        ]
      }
    },
    {
      "name": "stop_lights",
      "description": "Turn off the lighting system."
    }
  ]
} 
EOF

curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
  -H 'Content-Type: application/json' \
  -d @<(echo '
  {
    "system_instruction": {
      "parts": {
        "text": "You are a helpful lighting system bot. You can turn lights on and off, and you can set the color. Do not perform any other tasks."
      }
    },
    "tools": ['$(cat tools.json)'],

    "tool_config": {
      "function_calling_config": {"mode": "auto"}
    },

    "contents": {
      "role": "user",
      "parts": {
        "text": "Turn on the lights please."
      }
    }
  }
') 2>/dev/null |sed -n '/"content"/,/"finishReason"/p'
```

### JSON Schema Response ✅

```bash
curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
-H 'Content-Type: application/json' \
-d '{
    "contents": [{
      "parts":[
        {"text": "List 5 popular cookie recipes"}
        ]
    }],
    "generationConfig": {
        "response_mime_type": "application/json",
        "response_schema": {
          "type": "ARRAY",
          "items": {
            "type": "OBJECT",
            "properties": {
              "recipe_name": {"type":"STRING"},
            }
          }
        }
    }
}' 2> /dev/null | head
```

### Audio processing 🟡

!!! warning "File upload limit"
    Only supports passing`inline_data` Upload audio in base64 mode, not supported`file_data.file_uri` or File API.

```bash
# 使用File API上传音频数据到API请求
# 使用 base64 inline_data 上传音频数据到 API 请求
if [[ "$(base64 --version 2>&1)" = *"FreeBSD"* ]]; then
  B64FLAGS="--input"
else
  B64FLAGS="-w0"
fi
AUDIO_B64=$(base64 $B64FLAGS "$AUDIO_PATH")

curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
  -H 'Content-Type: application/json' \
  -X POST \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Please describe this audio file."},
        {"inline_data": {"mime_type": "audio/mpeg", "data": "'$AUDIO_B64'"}}
      ]
    }]
  }' 2> /dev/null | jq ".candidates[].content.parts[].text"
```

### Video processing 🟡

!!! warning "File upload limit"
    Only supports passing`inline_data` Upload videos in base64 mode, not supported`file_data.file_uri` or File API.

```bash
# 使用File API上传视频数据到API请求
# 使用 base64 inline_data 上传视频数据到 API 请求
if [[ "$(base64 --version 2>&1)" = *"FreeBSD"* ]]; then
  B64FLAGS="--input"
else
  B64FLAGS="-w0"
fi
VIDEO_B64=$(base64 $B64FLAGS "$VIDEO_PATH")

curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
  -H 'Content-Type: application/json' \
  -X POST \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Transcribe the audio from this video and provide visual descriptions."},
        {"inline_data": {"mime_type": "video/mp4", "data": "'$VIDEO_B64'"}}
      ]
    }]
  }' 2> /dev/null | jq ".candidates[].content.parts[].text"
```

### PDF processing 🟡

!!! warning "File upload limit"
    Only supports passing`inline_data` Upload PDF in base64 mode, not supported`file_data.file_uri` or File API.

```bash
MIME_TYPE=$(file -b --mime-type "${PDF_PATH}")
# 使用 base64 inline_data 上传 PDF 文件到 API 请求
if [[ "$(base64 --version 2>&1)" = *"FreeBSD"* ]]; then
  B64FLAGS="--input"
else
  B64FLAGS="-w0"
fi
PDF_B64=$(base64 $B64FLAGS "$PDF_PATH")

echo $MIME_TYPE

curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
  -H 'Content-Type: application/json' \
  -X POST \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Can you add a few more lines to this poem?"},
        {"inline_data": {"mime_type": "application/pdf", "data": "'$PDF_B64'"}}
      ]
    }]
  }' 2> /dev/null | jq ".candidates[].content.parts[].text"
```

### Chat Conversation ✅

```bash
curl https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
      "contents": [
        {"role":"user",
         "parts":[{
           "text": "Hello"}]},
        {"role": "model",
         "parts":[{
           "text": "Great to meet you. What would you like to know?"}]},
        {"role":"user",
         "parts":[{
           "text": "I have two dogs in my house. How many paws are in my house?"}]},
      ]
    }' 2> /dev/null | grep "text"
```

### Streaming response ✅

```bash
curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:streamGenerateContent?alt=sse&key=$API_KEY" \
    -H 'Content-Type: application/json' \
    --no-buffer \
    -d '{
      "contents": [{
        "parts": [{"text": "写一个关于魔法背包的故事"}]
      }]
    }'
```

### Code execution ✅

```bash
curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
      "contents": [{
        "parts": [{"text": "计算斐波那契数列的第10项"}]
      }],
      "tools": [{
        "codeExecution": {}
      }]
    }'
```

### Generate configuration ✅

```bash
curl https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY \
    -H 'Content-Type: application/json' \
    -X POST \
    -d '{
        "contents": [{
            "parts":[
                {"text": "Explain how AI works"}
            ]
        }],
        "generationConfig": {
            "stopSequences": [
                "Title"
            ],
            "temperature": 1.0,
            "maxOutputTokens": 800,
            "topP": 0.8,
            "topK": 10
        }
    }'  2> /dev/null | grep "text"
```

### Security settings ✅

```bash
echo '{
    "safetySettings": [
        {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_ONLY_HIGH"},
        {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_MEDIUM_AND_ABOVE"}
    ],
    "contents": [{
        "parts":[{
            "text": "'I support Martians Soccer Club and I think Jupiterians Football Club sucks! Write a ironic phrase about them.'"}]}]}' > request.json

curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
    -H 'Content-Type: application/json' \
    -X POST \
    -d @request.json 2> /dev/null
```

### System commands ✅

```bash
curl "https://api.wukong.support/v1beta/models/gemini-2.0-flash:generateContent?key=$API_KEY" \
-H 'Content-Type: application/json' \
-d '{ "system_instruction": {
    "parts":
      { "text": "You are a cat. Your name is Neko."}},
    "contents": {
      "parts": {
        "text": "Hello there"}}}'
```

## 📮 Request

### endpoint

#### Generate content
```
POST https://api.wukong.support/v1beta/{model=models/*}:generateContent
```

#### Streaming generated content
```
POST https://api.wukong.support/v1beta/{model=models/*}:streamGenerateContent
```

### Authentication method

Include the API key in the request URL parameters:

```
?key=$API_KEY
```

Among them`$API_KEY` is your Google AI API key.

### path parameters

#### `model`

- Type: string
- Required: Yes

The name of the model used to generate completions.

Format:`models/{model}`, for example`models/gemini-2.0-flash`

### Request body parameters

#### `contents`

- Type: array
- Required: Yes

The content of the current conversation with the model. For a single round query, this is a single instance. For multi-round queries such as chat, this is a repeating field containing the conversation history and the latest request.

**Content object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `parts` | array| Yes| Ordered portions of content that make up a single message|
| `role` | string| No| The producer of the content in the conversation.`user`、`model`、`function` or`tool` |

**Part object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `text` | string| No| Plain text content|
| `inlineData` | object| No| Inline media byte data|
| `fileData` | object| No| URI reference for uploaded files|
| `functionCall` | object| No| function call request|
| `functionResponse` | object| No| function call response|
| `executableCode` | object| No| executable code|
| `codeExecutionResult` | object| No| Code execution results|

**InlineData object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `mimeType` | string| Yes| The MIME type of the media|
| `data` | string| Yes| base64 encoded media data|

**FileData object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `mimeType` | string| Yes| The MIME type of the file|
| `fileUri` | string| Yes| File URI|

#### `tools`

- Type: array
- Required: No

A list of tools that the model might use to generate the next response. Supported tools include function and code execution.

**Tool object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `functionDeclarations` | array| No| optional list of function declarations|
| `codeExecution` | object| No| Enable model execution code|

**FunctionDeclaration object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `name` | string| Yes| function name|
| `description` | string| No| Function description|
| `parameters` | object| No| Function parameters, JSON Schema format|

**FunctionCall object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `name` | string| Yes| function name to call|
| `args` | object| No| Key-value pairs for function parameters|

**FunctionResponse object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `name` | string| Yes| function name called|
| `response` | object| Yes| Response data for function calls|

**ExecutableCode object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `language` | enumeration| Yes| code programming language|
| `code` | string| Yes| code to execute|

**CodeExecutionResult object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `outcome` | enumeration| Yes| The result status of code execution|
| `output` | string| No| Output content of code execution|

**CodeExecution object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| {} | empty object| - | An empty configuration object that enables code execution|

#### `toolConfig`

- Type: Object
- Required: No

Tool configuration for any tools specified in the request.

**ToolConfig object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `functionCallingConfig` | object| No| Function call configuration|

**FunctionCallingConfig object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `mode` | enumeration| No| Specify the mode of function calling|
| `allowedFunctionNames` | array| No| List of function names allowed to be called|

**FunctionCallingMode enumeration value:**

- `MODE_UNSPECIFIED`: Default mode, the model determines whether to call the function
- `AUTO`: The model automatically decides when to call the function
- `ANY`: The model must call the function
- `NONE`: The model cannot call functions

#### `safetySettings`

- Type: array
- Required: No

A list of SafetySetting instances used to block unsafe content.

**SafetySetting object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `category` | enumeration| Yes| security category|
| `threshold` | enumeration| Yes| Blocking threshold|

**HarmCategory enumeration value:**

- `HARM_CATEGORY_HARASSMENT`: Harassment content
- `HARM_CATEGORY_HATE_SPEECH`: Hate speech and content
- `HARM_CATEGORY_SEXUALLY_EXPLICIT`: Sexually explicit content
- `HARM_CATEGORY_DANGEROUS_CONTENT`: Dangerous content
- `HARM_CATEGORY_CIVIC_INTEGRITY`: Content that may be used to undermine the integrity of citizens

**HarmBlockThreshold enumeration value:**

- `BLOCK_LOW_AND_ABOVE`: Allow content rated NEGLIGIBLE
- `BLOCK_MEDIUM_AND_ABOVE`: Allow content rated NEGLIGIBLE and LOW
- `BLOCK_ONLY_HIGH`: Content with risk levels NEGLIGIBLE, LOW and MEDIUM is allowed
- `BLOCK_NONE`: Allow everything
- `OFF`: Turn off security filter

**HarmBlockThreshold full enumeration value:**

- `HARM_BLOCK_THRESHOLD_UNSPECIFIED`: no threshold specified
- `BLOCK_LOW_AND_ABOVE`: Block harmful content with low probability and above, and only allow NEGLIGIBLE level content
- `BLOCK_MEDIUM_AND_ABOVE`: Block harmful content with moderate probability and above, and allow content with NEGLIGIBLE and LOW levels
- `BLOCK_ONLY_HIGH`: Only block high-probability harmful content, allowing NEGLIGIBLE, LOW and MEDIUM level content
- `BLOCK_NONE`: Does not block any content, allows all levels of content
- `OFF`: Turn off safety filter completely

#### `systemInstruction`

- Type: Object (Content)
- Required: No

System commands set by developers. Currently only text is supported.

#### `generationConfig`

- Type: Object
- Required: No

Configuration options for model generation and output.

**GenerationConfig object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `stopSequences` | array| No| Set of character sequences (up to 5) used to stop generating output|
| `responseMimeType` | string| No| The MIME type of the generated candidate text|
| `responseSchema` | object| No| The output schema of the generated candidate text|
| `responseModalities` | array| No| Request response mode|
| `candidateCount` | integer| No| The number of generated answers to return|
| `maxOutputTokens` | integer| No| Maximum number of tokens included in candidate answers|
| `temperature` | numbers| No| Control the randomness of the output, range[0.0, 2.0] |
| `topP` | numbers| No| The upper bound on the cumulative probability of tokens to be considered when sampling|
| `topK` | integer| No| Maximum number of tokens to consider when sampling|
| `seed` | integer| No| Seed used in decoding|
| `presencePenalty` | numbers| No| existential punishment|
| `frequencyPenalty` | numbers| No| frequency penalty|
| `responseLogprobs` | Boolean value| No| Whether to export logprobs results in the response|
| `logprobs` | integer| No| Number of top logprobs returned|
| `enableEnhancedCivicAnswers` | Boolean value| No| Enable enhanced city service answers|
| `speechConfig` | object| No| Speech generation configuration|
| `thinkingConfig` | object| No| Think about the configuration of functions|
| `mediaResolution` | enumeration| No| Specified media resolution|

**Supported MIME types:**

- `text/plain`: (default) text output
- `application/json`: JSON response
- `text/x.enum`: ENUM as string response

**Modality enumeration value:**

- `TEXT`: Indicates that the model should return text
- `IMAGE`: Indicates that the model should return images
- `AUDIO`: Indicates that the model should return audio

**Schema object properties:**

| Properties| Type| required| Description|
|------|------|------|------|
| `type` | enumeration| Yes| data type|
| `description` | string| No| Field description|
| `enum` | array| No| List of enumeration values (when type is string)|
| `example` | any type| No| Example value|
| `nullable` | Boolean value| No| whether it can be null|
| `format` | string| No| String format (such as date, date-time, etc.)|
| `items` | object| No| Schema of array items (when type is array)|
| `properties` | object| No| Schema mapping of object attributes (when type is object)|
| `required` | array| No| List of names of required attributes|
| `minimum` | numbers| No| Minimum value of number|
| `maximum` | numbers| No| maximum value of number|
| `minItems` | integer| No| Minimum length of array|
| `maxItems` | integer| No| The maximum length of the array|
| `minLength` | integer| No| Minimum length of string|
| `maxLength` | integer| No| Maximum length of string|

**Type enumeration value:**

- `TYPE_UNSPECIFIED`: unspecified type
- `STRING`: string type
- `NUMBER`: numeric type
- `INTEGER`: Integer type
- `BOOLEAN`: boolean type
- `ARRAY`: array type
- `OBJECT`: object type

**Supported Programming Languages (ExecutableCode):**

- `LANGUAGE_UNSPECIFIED`: No language specified
- `PYTHON`: Python programming language

**Code execution result enumeration (Outcome):**

- `OUTCOME_UNSPECIFIED`: no result specified
- `OUTCOME_OK`: Code execution successful
- `OUTCOME_FAILED`: Code execution failed
- `OUTCOME_DEADLINE_EXCEEDED`: Code execution timeout

#### `cachedContent`

- Type: string
- Required: No

The name of the cached content used as context for providing predictions. Format:`cachedContents/{cachedContent}`

## 📥Response

### GenerateContentResponse

Answers for models that support multiple candidate answers. Security ratings and content filtering are reported for the prompt and for each candidate.

#### `candidates`

- Type: array
- Description: List of candidate answers for the model

**Candidate object properties:**

| Properties| Type| Description|
|------|------|------|
| `content` | object| Generated content returned by the model|
| `finishReason` | enumeration| Reasons why the model stopped generating tokens|
| `safetyRatings` | array| Rating list of candidate answer security|
| `citationMetadata` | object| Reference information of candidates generated by the model|
| `tokenCount` | integer| The number of tokens for this candidate|
| `groundingAttributions` | array| Information about the sources consulted to generate an informed answer|
| `groundingMetadata` | object| Reference metadata for candidates|
| `avgLogprobs` | numbers| Average log probability score of candidates|
| `logprobsResult` | object| Log-likelihood scores for answer tokens and prepended tokens|
| `urlRetrievalMetadata` | object| Metadata related to the URL contextual crawler|
| `urlContextMetadata` | object| Metadata related to the URL contextual crawler|
| `index` | integer| The index of the candidate in the response candidate list|

**FinishReason enumeration value:**

- `STOP`: The natural stopping point of the model or the provided stopping sequence
- `MAX_TOKENS`: The maximum number of tokens specified in the request has been reached
- `SAFETY`: For security reasons, the system has marked answer candidates
- `RECITATION`: Due to memorization reasons, the answer candidate content is marked
- `LANGUAGE`: Answer candidate was flagged for being in an unsupported language
- `OTHER`: Unknown reason
- `BLOCKLIST`: The token generation operation has been stopped because the content contains prohibited words
- `PROHIBITED_CONTENT`: The token generation operation has been stopped due to possible prohibited content.
- `SPII`: The token generation operation has been stopped because the content may contain sensitive personally identifiable information.
- `MALFORMED_FUNCTION_CALL`: The function call generated by the model is invalid
- `IMAGE_SAFETY`: Tome generation has been stopped because the generated image violates security regulations

#### `promptFeedback`

- Type: Object
- Description: Prompt feedback related to content filters

**PromptFeedback object properties:**

| Properties| Type| Description|
|------|------|------|
| `blockReason` | enumeration| Reason for blocking this prompt|
| `safetyRatings` | array| Issue security rating|

**BlockReason enumeration value:**

- `BLOCK_REASON_UNSPECIFIED`: Default value, this value is not used
- `SAFETY`: For security reasons, the system has blocked the prompt
- `OTHER`: Prompt has been blocked for unknown reasons.
- `BLOCKLIST`: This prompt has been blocked because it contains terms included in the term block list
- `PROHIBITED_CONTENT`: This prompt has been blocked because it contains prohibited content
- `IMAGE_SAFETY`: Candidate image blocked for generating unsafe content

#### `usageMetadata`

- Type: Object
- Description: Metadata about the usage of generated request tokens

**UsageMetadata object properties:**

| Properties| Type| Description|
|------|------|------|
| `promptTokenCount` | integer| Number of tokens in prompt|
| `cachedContentTokenCount` | integer| The number of tokens in the cached part of the hint|
| `candidatesTokenCount` | integer| The total number of tokens in all generated candidate responses|
| `totalTokenCount` | integer| The total number of tokens generated for the request|
| `toolUsePromptTokenCount` | integer| Number of tokens in tool usage tips|
| `thoughtsTokenCount` | integer| The number of idea tokens in the thinking model|
| `promptTokensDetails` | array| List of modals to handle in request input|
| `candidatesTokensDetails` | array| List of modalities returned in the response|
| `cacheTokensDetails` | array| Modal list of cached content in request input|
| `toolUsePromptTokensDetails` | array| A list of modalities for tool usage request input handling|

#### `modelVersion`

- Type: string
- Description: The model version used to generate the answer

#### `responseId`

- Type: string
- Description: The ID used to identify each response

#### Full response example

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "你好！我是 Gemini，一个由 Google 开发的人工智能助手。我可以帮助您解答问题、提供信息、协助写作、代码编程等多种任务。请告诉我有什么可以为您效劳的！"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP",
      "index": 0,
      "safetyRatings": [
        {
          "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
          "probability": "NEGLIGIBLE",
          "blocked": false
        },
        {
          "category": "HARM_CATEGORY_HATE_SPEECH", 
          "probability": "NEGLIGIBLE",
          "blocked": false
        },
        {
          "category": "HARM_CATEGORY_HARASSMENT",
          "probability": "NEGLIGIBLE",
          "blocked": false
        },
        {
          "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
          "probability": "NEGLIGIBLE",
          "blocked": false
        }
      ],
      "tokenCount": 47
    }
  ],
  "promptFeedback": {
    "safetyRatings": [
      {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "probability": "NEGLIGIBLE"
      },
      {
        "category": "HARM_CATEGORY_HATE_SPEECH",
        "probability": "NEGLIGIBLE"
      }
    ]
  },
  "usageMetadata": {
    "promptTokenCount": 4,
    "candidatesTokenCount": 47,
    "totalTokenCount": 51,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 4
      }
    ],
    "candidatesTokensDetails": [
      {
        "modality": "TEXT", 
        "tokenCount": 47
      }
    ]
  },
  "modelVersion": "gemini-2.0-flash",
  "responseId": "response-12345"
}
```

## 🔧 Advanced features

### safety rating

**SafetyRating object properties:**

| Properties| Type| Description|
|------|------|------|
| `category` | enumeration| Category for this rating|
| `probability` | enumeration| How likely this content is to be harmful|
| `blocked` | Boolean value| Is this content blocked due to this rating?|

**HarmProbability enumeration value:**

- `NEGLIGIBLE`: The probability that the content is unsafe is negligible
- `LOW`: The content is less likely to be unsafe
- `MEDIUM`: There is a medium chance that the content is unsafe
- `HIGH`: The content is more likely to be unsafe

### Reference metadata

**CitationMetadata object properties:**

| Properties| Type| Description|
|------|------|------|
| `citationSources` | array| Source citations for specific responses|

**CitationSource object properties:**

| Properties| Type| Description|
|------|------|------|
| `startIndex` | integer| The starting index of the response fragments attributed to this source|
| `endIndex` | integer| Ending index of attribution segment (not included)|
| `uri` | string| The URI attributed as the source of the text part|
| `license` | string| License of the GitHub project attributed as the source of the snippet|

### code execution

When code execution tools are enabled, the model can generate and execute code to solve the problem.

**Code Execution Sample Response:**

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "我来计算斐波那契数列的第10项："
          },
          {
            "executableCode": {
              "language": "PYTHON",
              "code": "def fibonacci(n):\n    if n <= 1:\n        return n\n    else:\n        return fibonacci(n-1) + fibonacci(n-2)\n\nresult = fibonacci(10)\nprint(f'第10项斐波那契数是: {result}')"
            }
          },
          {
            "codeExecutionResult": {
              "outcome": "OK",
              "output": "第10项斐波那契数是: 55"
            }
          },
          {
            "text": "所以斐波那契数列的第10项是55。"
          }
        ],
        "role": "model"
      },
      "finishReason": "STOP"
    }
  ]
}
```

### Grounding function (Grounding)

**GroundingMetadata object properties:**

| Properties| Type| Description|
|------|------|------|
| `groundingChunks` | array| A list of supporting references retrieved from the specified ground source|
| `groundingSupports` | array| Ground support list|
| `webSearchQueries` | array| Web search query used for subsequent web searches|
| `searchEntryPoint` | object| Google search terms for subsequent web searches|
| `retrievalMetadata` | object| Metadata related to retrieval in the baseline process|

**GroundingAttribution object properties:**

| Properties| Type| Description|
|------|------|------|
| `sourceId` | object| The identifier of the source that contributed to this attribution|
| `content` | object| The source content that constitutes this attribution|

**AttributionSourceId object attribute:**

| Properties| Type| Description|
|------|------|------|
| `groundingPassage` | object| Identifier for inline paragraph|
| `semanticRetrieverChunk` | object| The identifier of the Chunk extracted by Semantic Retriever|

**GroundingPassageId object property:**

| Properties| Type| Description|
|------|------|------|
| `passageId` | string| The ID of the paragraph that matches GenerateAnswerRequest's GroundingPassage.id|
| `partIndex` | integer| Index of the section in GroundingPassage.content of GenerateAnswerRequest|

**SemanticRetrieverChunk object properties:**

| Properties| Type| Description|
|------|------|------|
| `source` | string| A source name that matches the requested SemanticRetrieverConfig.source|
| `chunk` | string| The name of the chunk containing the attribution text|

**SearchEntryPoint object properties:**

| Properties| Type| Description|
|------|------|------|
| `renderedContent` | string| Web content snippets that can be embedded in web pages or application WebViews|
| `sdkBlob` | string| Array representing search term and search URL tuples using base64 encoded JSON|

**Segment object properties:**

| Properties| Type| Description|
|------|------|------|
| `partIndex` | integer| The index of the Part object in its parent Content object|
| `startIndex` | integer| Starting index in the given part, in bytes|
| `endIndex` | integer| The ending index in the given chunk, in bytes|
| `text` | string| Text corresponding to the fragment in the response|

**RetrievalMetadata object properties:**

| Properties| Type| Description|
|------|------|------|
| `googleSearchDynamicRetrievalScore` | numbers| Information from Google Search helps answer the question's probability score, range[0,1] |

**GroundingChunk Object Properties:**

| Properties| Type| Description|
|------|------|------|
| `web` | object| Ground block from network|

**Web Object Properties:**

| Properties| Type| Description|
|------|------|------|
| `uri` | string| Chunked URI references|
| `title` | string| Title of the data block|

**GroundingSupport object properties:**

| Properties| Type| Description|
|------|------|------|
| `groundingChunkIndices` | array| A list of indexes specifying citations relevant to the copyright claim|
| `confidenceScores` | array| Supports confidence scores for reference documents, ranging from 0 to 1|
| `segment` | object| The content fragment this support request belongs to|

### multimodal processing

Gemini API supports processing input and output of multiple modalities:

**Supported input modals:**

- `TEXT`: plain text
- `IMAGE`: Pictures (JPEG, PNG, WebP, HEIC, HEIF)
- `AUDIO`: Audio (WAV, MP3, AIFF, AAC, OGG, FLAC)
- `VIDEO`: Video (MP4, MPEG, MOV, AVI, FLV, MPG, WEBM, WMV, 3GPP)
- `DOCUMENT`: Documentation (PDF)

**ModalityTokenCount object properties:**

| Properties| Type| Description|
|------|------|------|
| `modality` | enumeration| The modality associated with this token number|
| `tokenCount` | integer| Number of tokens|

**MediaResolution enumeration value:**

- `MEDIA_RESOLUTION_LOW`: Low resolution (64 tokens)
- `MEDIA_RESOLUTION_MEDIUM`: Medium resolution (256 tokens)
- `MEDIA_RESOLUTION_HIGH`: High resolution (256 tokens for zoom reframing)

### thinking function

**ThinkingConfig object properties:**

| Properties| Type| Description|
|------|------|------|
| `includeThoughts` | Boolean value| Whether to include reflections in the answer|
| `thinkingBudget` | integer| The number of idea tokens the model should generate|

### speech generation

**SpeechConfig object properties:**

| Properties| Type| Description|
|------|------|------|
| `voiceConfig` | object| Single audio output configuration|
| `multiSpeakerVoiceConfig` | object| Configuration of multi-speaker setups|
| `languageCode` | string| Language code used for speech synthesis|

**VoiceConfig object properties:**

| Properties| Type| Description|
|------|------|------|
| `prebuiltVoiceConfig` | object| Configuration of pre-built voices to use|

**PrebuiltVoiceConfig object properties:**

| Properties| Type| Description|
|------|------|------|
| `voiceName` | string| The name of the preset voice to use|

**MultiSpeakerVoiceConfig object properties:**

| Properties| Type| Description|
|------|------|------|
| `speakerVoiceConfigs` | array| All enabled speaker voices|

**SpeakerVoiceConfig object properties:**

| Properties| Type| Description|
|------|------|------|
| `speaker` | string| The name of the speaker to use|
| `voiceConfig` | object| Configuration of the voice to use|

**Supported language codes:**

- `zh-CN`: Chinese (Simplified)
- `en-US`: English (US)
- `ja-JP`: Japanese
- `ko-KR`: Korean
- `fr-FR`: French
- `de-DE`: German
- `es-ES`: spanish
- `pt-BR`: Portuguese (Brazil)
- `hi-IN`: hindi
- `ar-XA`: Arabic
- `it-IT`: Italian
- `tr-TR`: Turkish
- `vi-VN`: Vietnamese
- `th-TH`: Thai
- `ru-RU`: Russian
- `pl-PL`: polish
- `nl-NL`: Dutch

### Logprobs results

**LogprobsResult object properties:**

| Properties| Type| Description|
|------|------|------|
| `topCandidates` | array| The length is equal to the total number of decoding steps|
| `chosenCandidates` | array| The length is equal to the total number of decoding steps, and the selected candidate is not necessarily in topCandidates|

**TopCandidates object properties:**

| Properties| Type| Description|
|------|------|------|
| `candidates` | array| Candidates sorted in descending order of log probability|

**Candidate (Logprobs) object properties:**

| Properties| Type| Description|
|------|------|------|
| `token` | string| The token string value of the candidate|
| `tokenId` | integer| The token ID value of the candidate|
| `logProbability` | numbers| Log probability of candidate|

### URL search function

**UrlRetrievalMetadata object properties:**

| Properties| Type| Description|
|------|------|------|
| `urlRetrievalContexts` | array| URL search context list|

**UrlRetrievalContext object properties:**

| Properties| Type| Description|
|------|------|------|
| `retrievedUrl` | string| The URL retrieved by the tool|

**UrlContextMetadata object properties:**

| Properties| Type| Description|
|------|------|------|
| `urlMetadata` | array| URL context list|

**UrlMetadata object properties:**

| Properties| Type| Description|
|------|------|------|
| `retrievedUrl` | string| The URL retrieved by the tool|
| `urlRetrievalStatus` | enumeration| URL search status|

**UrlRetrievalStatus enumeration value:**

- `URL_RETRIEVAL_STATUS_SUCCESS`: URL retrieval successful
- `URL_RETRIEVAL_STATUS_ERROR`: URL retrieval failed due to an error

### Complete security category

**HarmCategory full enumeration value:**

- `HARM_CATEGORY_UNSPECIFIED`: Category not specified
- `HARM_CATEGORY_DEROGATORY`: PaLM - Negative or harmful comments targeting identity and/or protected properties
- `HARM_CATEGORY_TOXICITY`: PaLM - Rude, disrespectful or profane content
- `HARM_CATEGORY_VIOLENCE`: PaLM - Describes scenes depicting acts of violence against individuals or groups
- `HARM_CATEGORY_SEXUAL`: PaLM - Contains references to sexual acts or other obscene material
- `HARM_CATEGORY_MEDICAL`: PaLM - Promote unverified medical advice
- `HARM_CATEGORY_DANGEROUS`: PaLM - Dangerous content promotes, promotes or encourages harmful behavior
- `HARM_CATEGORY_HARASSMENT`: Gemini - Harassment Content
- `HARM_CATEGORY_HATE_SPEECH`: Gemini - Hate speech and content
- `HARM_CATEGORY_SEXUALLY_EXPLICIT`: Gemini - Sexually Explicit Content
- `HARM_CATEGORY_DANGEROUS_CONTENT`: Gemini - Dangerous Content
- `HARM_CATEGORY_CIVIC_INTEGRITY`: Gemini - Content that may be used to undermine the integrity of citizens

**HarmProbability full enumeration value:**

- `HARM_PROBABILITY_UNSPECIFIED`: Probability not specified
- `NEGLIGIBLE`: The probability that the content is unsafe is negligible
- `LOW`: The content is less likely to be unsafe
- `MEDIUM`: There is a medium chance that the content is unsafe
- `HIGH`: The content is more likely to be unsafe

**Modality full enumeration value:**

- `MODALITY_UNSPECIFIED`: No modal specified
- `TEXT`: plain text
- `IMAGE`: pictures
- `VIDEO`: video
- `AUDIO`: audio
- `DOCUMENT`: Document, such as PDF

**MediaResolution full enumeration value:**

- `MEDIA_RESOLUTION_UNSPECIFIED`: Media resolution not set
- `MEDIA_RESOLUTION_LOW`: Media resolution set to low (64 tokens)
- `MEDIA_RESOLUTION_MEDIUM`: Media resolution set to medium (256 tokens)
- `MEDIA_RESOLUTION_HIGH`: Media resolution set to high (use 256 tokens for zoom reframing)

**UrlRetrievalStatus full enumeration value:**

- `URL_RETRIEVAL_STATUS_UNSPECIFIED`: Default value, this value is not used
- `URL_RETRIEVAL_STATUS_SUCCESS`: URL retrieval successful
- `URL_RETRIEVAL_STATUS_ERROR`: URL retrieval failed due to an error

## 🔍 Error handling

### Common error codes

| error code| Description|
|--------|------|
| `400` | The request format is incorrect or the parameters are invalid|
| `401` | Invalid or missing API key|
| `403` | Insufficient permissions or quota restrictions|
| `429` | Request frequency is too high|
| `500` | Server internal error|

### Detailed error code description

| error code| Status| Description| solution|
|--------|------|------|----------|
| `400` | `INVALID_ARGUMENT` | The request parameters are invalid or in the wrong format| Check request parameter format and required fields|
| `400` | `FAILED_PRECONDITION` | The requested preconditions are not met| Ensure that preconditions for API calls are met|
| `401` | `UNAUTHENTICATED` | Invalid, missing, or expired API key| Check API key validity and format|
| `403` | `PERMISSION_DENIED` | Insufficient permissions or quota exhausted| Check API key permissions or upgrade quotas|
| `404` | `NOT_FOUND` | The specified model or resource does not exist| Verify model name and resource path|
| `413` | `PAYLOAD_TOO_LARGE` | The request body is too large| Reduce input size or batch processing|
| `429` | `RESOURCE_EXHAUSTED` |The request frequency exceeds the limit or the quota is insufficient| Reduce request frequency or wait for quota reset|
| `500` | `INTERNAL` | Server internal error| Retry the request, if it persists contact support|
| `503` | `UNAVAILABLE` | Service is temporarily unavailable| Wait for some time and try again|
| `504` | `DEADLINE_EXCEEDED` | Request timeout| Reduce input size or retry request|

### Error response example

```json
{
  "error": {
    "code": 400,
    "message": "Invalid argument: contents",
    "status": "INVALID_ARGUMENT",
    "details": [
      {
        "@type": "type.googleapis.com/google.rpc.BadRequest",
        "fieldViolations": [
          {
            "field": "contents",
            "description": "contents is required"
          }
        ]
      }
    ]
  }
}
```