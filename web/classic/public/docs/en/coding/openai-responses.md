# OpenAI response format (Responses)

!!! info "Official Documentation"
    [OpenAI Responses](https://platform.openai.com/docs/api-reference/responses)

## 📝 Introduction

OpenAI's most advanced model response interface. Supports text and image input, as well as text output. Create a stateful interaction with the model, using the output of previous responses as input. The ability to extend the model through built-in tools such as file search, web search, computer usage, and more. Use function calls to allow models to access external systems and data.

Related guidelines can be found on the OpenAI official website:[Responses](https://platform.openai.com/docs/guides/responses)

## 💡 Request example

### Basic text response ✅

```bash
curl https://api.wukong.support/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": "讲一个三句话的关于独角兽的睡前故事。"
  }'
```

**Response example:**

```json
{
  "id": "resp_67ccd2bed1ec8190b14f964abc0542670bb6a6b452d3795b",
  "object": "response",
  "created_at": 1741476542,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1",
  "output": [
    {
      "type": "message",
      "id": "msg_67ccd2bf17f0819081ff3bb2cf6508e60bb6a6b452d3795b",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "在一个宁静的月夜下，一只名叫璐米娜的独角兽发现了一个倒映着星星的隐藏水池。当她将独角浸入水中时，水池开始闪烁，显现出通往一个有着无尽夜空的魔法世界的路径。充满好奇，璐米娜为所有做梦的人许下愿望，希望他们能找到自己的隐藏魔法，当她回头望去，她的蹄印像星尘一样闪烁。",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 36,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 87,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 123
  },
  "user": null,
  "metadata": {}
}
```

### Image Analysis Response ✅

```bash
curl https://api.wukong.support/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": [
      {
        "role": "user",
        "content": [
          {"type": "input_text", "text": "描述这张图片中的内容"},
          {
            "type": "input_image",
            "image_url": "https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
          }
        ]
      }
    ]
  }'
```

**Response example:**

```json
{
  "id": "resp_67ccd3a9da748190baa7f1570fe91ac604becb25c45c1d41",
  "object": "response",
  "created_at": 1741476777,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1",
  "output": [
    {
      "type": "message",
      "id": "msg_67ccd3acc8d48190a77525dc6de64b4104becb25c45c1d41",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "这张图片展示了一条木制栈道或小径穿过茂密的绿色草地，上方是点缀着几朵云的蓝天。场景呈现出一个宁静的自然区域，可能是公园或自然保护区。背景中有树木和灌木丛。整个景观展现出和谐的自然环境，栈道为游客提供了一条穿过湿地或草原而不影响周围生态系统的路径。",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 328,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 52,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 380
  },
  "user": null,
  "metadata": {}
}
```

### Internet search tools ✅

```bash
curl https://api.wukong.support/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "tools": [{ "type": "web_search_preview" }],
    "input": "今天有什么积极正面的新闻?"
  }'
```

**Response example:**

```json
{
  "id": "resp_67ccf18ef5fc8190b16dbee19bc54e5f087bb177ab789d5c",
  "object": "response",
  "created_at": 1741484430,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1",
  "output": [
    {
      "type": "web_search_call",
      "id": "ws_67ccf18f64008190a39b619f4c8455ef087bb177ab789d5c",
      "status": "completed"
    },
    {
      "type": "message",
      "id": "msg_67ccf190ca3881909d433c50b1f6357e087bb177ab789d5c",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "截至今天，2025年3月9日，一则值得关注的积极新闻是中国科学家在可再生能源领域取得重大突破，成功研发出一种新型高效太阳能电池，转化率达到了创纪录的35%，这可能会极大推动清洁能源的普及和应用。这项技术预计将使太阳能发电成本降低约40%，为全球减少碳排放提供了新的解决方案。",
          "annotations": [
            {
              "type": "url_citation",
              "start_index": 42,
              "end_index": 100,
              "url": "https://example.com/renewable-energy-breakthrough/?utm_source=chatgpt.com",
              "title": "中国科学家在可再生能源领域取得重大突破"
            },
            {
              "type": "url_citation",
              "start_index": 101,
              "end_index": 150,
              "url": "https://example.com/solar-cell-efficiency-record/?utm_source=chatgpt.com",
              "title": "新型高效太阳能电池转化率创纪录"
            },
            {
              "type": "url_citation",
              "start_index": 151,
              "end_index": 200,
              "url": "https://example.com/clean-energy-cost-reduction/?utm_source=chatgpt.com",
              "title": "太阳能发电成本有望降低40%"
            }
          ]
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "web_search_preview",
      "domains": [],
      "search_context_size": "medium",
      "user_location": {
        "type": "approximate",
        "city": null,
        "country": "US",
        "region": null,
        "timezone": null
      }
    }
  ],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 328,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 356,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 684
  },
  "user": null,
  "metadata": {}
}
```

### File search tool ✅

```bash
curl https://api.wukong.support/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "tools": [{
      "type": "file_search",
      "vector_store_ids": ["vs_1234567890"],
      "max_num_results": 20
    }],
    "input": "古代棕龙有哪些特性和属性?"
  }'
```

**Response example:**

```json
{
  "id": "resp_67ccf4c55fc48190b71bd0463ad3306d09504fb6872380d7",
  "object": "response",
  "created_at": 1741485253,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1",
  "output": [
    {
      "type": "file_search_call",
      "id": "fs_67ccf4c63cd08190887ef6464ba5681609504fb6872380d7",
      "status": "completed",
      "queries": [
        "古代棕龙的特性和属性"
      ],
      "results": null
    },
    {
      "type": "message",
      "id": "msg_67ccf4c93e5c81909d595b369351a9d309504fb6872380d7",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "根据资料，古代棕龙具有以下特性和属性：\n\n1. 物理特征：古代棕龙体型庞大，体长可达25-30米，翼展约35米。它们的鳞片呈深棕色至铜色，随着年龄增长会变得更加暗沉。头部有特征性的双角和脊刺，下颚强壮，适合撕裂猎物。\n\n2. 能力：它们能喷吐强力的酸液，对目标造成严重腐蚀伤害。古代棕龙还拥有出色的掘地能力，常在沙漠或山地挖掘复杂的巢穴系统。\n\n3. 智力：被认为是龙族中最为狡猾和有耐心的品种，智力极高，精通多种语言，并具有复杂的战术思维。\n\n4. 栖息地：主要栖息在干旱的山地和沙漠地区，喜欢炎热干燥的环境。\n\n5. 宝藏：古代棕龙以其庞大的宝藏闻名，特别喜爱收集铜币、红宝石和火焰魔法物品。\n\n6. 寿命：是所有龙种中寿命最长的之一，可活2000-2500年，随着年龄增长其力量和魔法能力也会增强。\n\n7. 性格：极度领地意识强，性格暴躁易怒，对侵入者毫不留情，但也以其罕见的耐心著称，能为复仇等待几个世纪。",
          "annotations": [
            {
              "type": "file_citation",
              "index": 80,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 233,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 345,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 420,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 520,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 580,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 655,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            },
            {
              "type": "file_citation",
              "index": 781,
              "file_id": "file-4wDz5b167pAf72nx1h9eiN",
              "filename": "dragons.pdf"
            }
          ]
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "file_search",
      "filters": null,
      "max_num_results": 20,
      "ranking_options": {
        "ranker": "auto",
        "score_threshold": 0.0
      },
      "vector_store_ids": [
        "vs_1234567890"
      ]
    }
  ],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 18307,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 348,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 18655
  },
  "user": null,
  "metadata": {}
}
```

### Streaming response ✅

```bash
curl https://api.wukong.support/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "instructions": "你是一个有帮助的助手。",
    "input": "你好！",
    "stream": true
  }'
```

**Streaming response example:**

```
event: response.created
data: {"type":"response.created","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"in_progress","error":null,"incomplete_details":null,"instructions":"你是一个有帮助的助手。","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}

event: response.in_progress
data: {"type":"response.in_progress","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"in_progress","error":null,"incomplete_details":null,"instructions":"你是一个有帮助的助手。","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":null,"user":null,"metadata":{}}}

event: response.output_item.added
data: {"type":"response.output_item.added","output_index":0,"item":{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"in_progress","role":"assistant","content":[]}}

event: response.content_part.added
data: {"type":"response.content_part.added","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"part":{"type":"output_text","text":"","annotations":[]}}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"你好"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"！"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":" 我"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"能"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"为"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"您"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"提供"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"什么"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"帮助"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"吗"}

event: response.output_text.delta
data: {"type":"response.output_text.delta","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"delta":"？"}

event: response.output_text.done
data: {"type":"response.output_text.done","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"text":"你好！ 我能为您提供什么帮助吗？"}

event: response.content_part.done
data: {"type":"response.content_part.done","item_id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","output_index":0,"content_index":0,"part":{"type":"output_text","text":"你好！ 我能为您提供什么帮助吗？","annotations":[]}}

event: response.output_item.done
data: {"type":"response.output_item.done","output_index":0,"item":{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"completed","role":"assistant","content":[{"type":"output_text","text":"你好！ 我能为您提供什么帮助吗？","annotations":[]}]}}

event: response.completed
data: {"type":"response.completed","response":{"id":"resp_67c9fdcecf488190bdd9a0409de3a1ec07b8b0ad4e5eb654","object":"response","created_at":1741290958,"status":"completed","error":null,"incomplete_details":null,"instructions":"你是一个有帮助的助手。","max_output_tokens":null,"model":"gpt-4.1-2025-04-14","output":[{"id":"msg_67c9fdcf37fc8190ba82116e33fb28c507b8b0ad4e5eb654","type":"message","status":"completed","role":"assistant","content":[{"type":"output_text","text":"你好！ 我能为您提供什么帮助吗？","annotations":[]}]}],"parallel_tool_calls":true,"previous_response_id":null,"reasoning":{"effort":null,"summary":null},"store":true,"temperature":1.0,"text":{"format":{"type":"text"}},"tool_choice":"auto","tools":[],"top_p":1.0,"truncation":"disabled","usage":{"input_tokens":37,"output_tokens":11,"output_tokens_details":{"reasoning_tokens":0},"total_tokens":48},"user":null,"metadata":{}}}
```

### Function call ✅

```bash
curl https://api.wukong.support/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "gpt-4.1",
    "input": "波士顿今天的天气如何？",
    "tools": [
      {
        "type": "function",
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
          "required": ["location", "unit"]
        }
      }
    ],
    "tool_choice": "auto"
  }'
```

**Response example:**

```json
{
  "id": "resp_67ca09c5efe0819096d0511c92b8c890096610f474011cc0",
  "object": "response",
  "created_at": 1741294021,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "gpt-4.1-2025-04-14",
  "output": [
    {
      "type": "function_call",
      "id": "fc_67ca09c6bedc8190a7abfec07b1a1332096610f474011cc0",
      "call_id": "call_unLAR8MvFNptuiZK6K6HCy5k",
      "name": "get_current_weather",
      "arguments": "{\"location\":\"波士顿, MA\",\"unit\":\"celsius\"}",
      "status": "completed"
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": null,
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [
    {
      "type": "function",
      "description": "获取指定位置的当前天气",
      "name": "get_current_weather",
      "parameters": {
        "type": "object",
        "properties": {
          "location": {
            "type": "string",
            "description": "城市和州，例如 San Francisco, CA"
          },
          "unit": {
            "type": "string",
            "enum": [
              "celsius",
              "fahrenheit"
            ]
          }
        },
        "required": [
          "location",
          "unit"
        ]
      },
      "strict": true
    }
  ],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 291,
    "output_tokens": 23,
    "output_tokens_details": {
      "reasoning_tokens": 0
    },
    "total_tokens": 314
  },
  "user": null,
  "metadata": {}
}
```

### Reasoning ability ✅

```bash
curl https://api.wukong.support/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "o3-mini",
    "input": "一只啄木鸟能啄多少木头?",
    "reasoning": {
      "effort": "high"
    }
  }'
```

**Response example:**

```json
{
  "id": "resp_67ccd7eca01881908ff0b5146584e408072912b2993db808",
  "object": "response",
  "created_at": 1741477868,
  "status": "completed",
  "error": null,
  "incomplete_details": null,
  "instructions": null,
  "max_output_tokens": null,
  "model": "o1-2024-12-17",
  "output": [
    {
      "type": "message",
      "id": "msg_67ccd7f7b5848190a6f3e95d809f6b44072912b2993db808",
      "status": "completed",
      "role": "assistant",
      "content": [
        {
          "type": "output_text",
          "text": "这是一个源自英文绕口令"How much wood would a woodchuck chuck if a woodchuck could chuck wood"的问题。在现实中，啄木鸟(woodpecker)和土拨鼠(woodchuck)是不同的动物，而且土拨鼠实际上并不"啄(chuck)"木头。\n\n从科学角度看，啄木鸟每天确实会啄树木以寻找食物、建造巢穴或进行通讯。一只啄木鸟平均每天可能啄树约8000-12000次，视物种和具体目的而定。如果我们将这转换为木材量，假设每次啄击移除约0.1-0.2立方厘米的木材，那么一只啄木鸟理论上每天可能移除约800-2400立方厘米的木材。\n\n然而，啄木鸟主要是为了觅食和筑巢而啄木，而不是单纯地移除木材，所以这个计算只是一个有趣的理论估算。",
          "annotations": []
        }
      ]
    }
  ],
  "parallel_tool_calls": true,
  "previous_response_id": null,
  "reasoning": {
    "effort": "high",
    "summary": null
  },
  "store": true,
  "temperature": 1.0,
  "text": {
    "format": {
      "type": "text"
    }
  },
  "tool_choice": "auto",
  "tools": [],
  "top_p": 1.0,
  "truncation": "disabled",
  "usage": {
    "input_tokens": 81,
    "input_tokens_details": {
      "cached_tokens": 0
    },
    "output_tokens": 1035,
    "output_tokens_details": {
      "reasoning_tokens": 832
    },
    "total_tokens": 1116
  },
  "user": null,
  "metadata": {}
}
```

## 📮 Request

### endpoint

```
POST /v1/responses
```

Create model responses. Provide text or image input to produce text or JSON output. Let the model call your own custom code or use built-in tools such as web search or file search to use your own data as input to the model response.

### Authentication method

Include the following in the request header for API key authentication:

```
Authorization: Bearer $API_KEY
```

Among them`$API_KEY` is your API key.

### Request body parameters

#### input

**Type**: string or array
**Required**: Yes

Text, image, or file input provided to the model to generate a response.

##### possible types

| Type| Description|
|------|------|
| string| Text input, equivalent to text input with user role|
| input array| A list of one or more inputs containing different content types|

##### input message object

| Properties| Type| required| Description|
|------|------|------|------|
| content | string or array| Yes| Text, image, or audio input provided to the model to generate a response. Can also include previous helper responses|
| role | string| Yes| Enter the role of the message. Optional values:`user`、`assistant`、`system` or`developer` |
| type | string| No| Type of input message, always`message` |

##### Content item type

###### Text input

| Properties| Type| required| Description|
|------|------|------|------|
| text | string| Yes| Text input provided to the model|
| type | string| Yes| Type of input, always`input_text` |

###### Image input

| Properties| Type| required| Description|
|------|------|------|------|
| detail | string| Yes| The level of detail of the image to send to the model. Optional values:`high`、`low` or`auto`. Default is`auto` |
| type | string| Yes| Type of input, always`input_image` |
| file_id | string| No| The file ID to send to the model|
| image_url | string| No| The image URL to send to the model. Can be a full URL or a base64 encoded image in a data URL|

###### File input

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| Type of input, always`input_file` |
| file_data | string| No| The contents of the file to send to the model|
| file_id | string| No| The file ID to send to the model|
| filename | string| No| The filename to send to the model|

##### Output type

###### Output text

| Properties| Type| required| Description|
|------|------|------|------|
| text | string| Yes| Text output generated by the model|
| type | string| Yes| The type of output item, always`output_text` |
| annotations | array| Yes| Comments on text output|

###### Annotation type

Document reference:

| Properties| Type| required| Description|
|------|------|------|------|
| file_id | string| Yes| File ID|
| index | integer| Yes| The index of the file in the file list|
| type | string| Yes| The type of file reference, always`file_citation` |

URL reference:

| Properties| Type| required| Description|
|------|------|------|------|
| end_index | integer| Yes| The index of the last character in the message that the URL refers to|
| start_index | integer| Yes| The index of the first character in the message that the URL refers to|
| title | string| Yes| The title of the web resource|
| type | string| Yes| The type of URL reference, always`url_citation` |
| url | string| Yes| URL of network resource|

File path:

| Properties| Type| required| Description|
|------|------|------|------|
| file_id | string| Yes| File ID|
| index | integer| Yes| The index of the file in the file list|
| type | string| Yes| Type of file path, always`file_path` |

###### reject response

| Properties| Type| required| Description|
|------|------|------|------|
| refusal | string| Yes| Model rejection explanation|
| type | string| Yes| Type of rejection, always`refusal` |

##### Tool call type

###### File search tool call

| Properties| Type| required| Description|
|------|------|------|------|
| id | string| Yes| Unique ID for file search tool calls|
| queries | array| Yes| Query to search for files|
| status | string| Yes| The status of the file search tool call. Possible values include:`in_progress`、`searching`、`incomplete` or`failed` |
| type | string| Yes| The type of file search tool call, always`file_search_call` |
| results | array or null| No| Results of file search tool calls|

###### Internet search tool call

| Properties| Type| required| Description|
|------|------|------|------|
| id | string| Yes| The unique ID called by the web search tool|
| status | string| Yes| Status of web search tool calls|
| type | string| Yes| The type of web search tool call, always`web_search_call` |

###### function tool call

| Properties| Type| required| Description|
|------|------|------|------|
| arguments | string| Yes| JSON string of arguments passed to the function|
| call_id | string| Yes| The unique ID of the function tool call generated by the model|
| name | string| Yes| The name of the function to run|
| type | string| Yes| The type of function utility call, always`function_call` |
| id | string| No| The unique ID of the function tool call|
| status | string| No| The status of the project. Possible values:`in_progress`、`completed`or`incomplete` |

###### computer tool call

| Properties| Type| required| Description|
|------|------|------|------|
| action | object| Yes| Computer interaction operations, such as clicking, dragging, etc.|
| call_id | string| Yes| Identifier used when responding to tool invocation output|
| id | string| Yes| The unique ID called by the computer|
| pending_safety_checks | array| Yes| Pending security check called by computer|
| status | string| Yes| The status of the project. Possible values:`in_progress`、`completed`or`incomplete` |
| type | string| Yes| The type of computer call, always`computer_call` |

Computer operation type:

| Operation type| Description|
|---------|------|
| click | Mouse click operation|
| double_click | Mouse double-click operation|
| drag | Drag and drop operation|
| keypress | Key operation|
| move | Mouse movement operation|
| screenshot | Screenshot operation|
| scroll | scrolling operation|
| type | Text input operations|
| wait | Waiting for operation|

###### Computer tool call output

| Properties| Type| required| Description|
|------|------|------|------|
| call_id | string| Yes| The ID of the computer tool call that produced the output|
| output | object| Yes| Computer screenshot image for computer usage tools|
| type | string| Yes| The type of output for computer tool calls, always`computer_call_output` |
| acknowledged_safety_checks | array| No| Security checks reported by the API that have been confirmed by the developer|
| id | string| No| The ID of the computer tool call output|
| status | string| No| Enter the status of the message. Possible values:`in_progress`、`completed`or`incomplete` |

###### Function tool call output

| Properties| Type| required| Description|
|------|------|------|------|
| call_id | string| Yes| The unique ID of the function tool call generated by the model|
| output | string| Yes| JSON string output by function tool call|
| type | string| Yes| The type of output of the function tool call, which is always`function_call_output` |
| id | string| No| The unique ID output by the function tool call|
| status | string| No| The status of the project. Possible values:`in_progress`、`completed`or`incomplete` |

##### inference related items

| Properties| Type| required| Description|
|------|------|------|------|
| id | string| Yes| The unique identifier of the inference content|
| summary | array| Yes| Reasoning about text content|
| type | string| Yes| The type of object, always`reasoning` |
| encrypted_content | string or null| No| The encrypted content of the inference item - when used`reasoning.encrypted_content` Contains parameters that are populated when generating a response|
| status | string| No| The status of the project. Possible values:`in_progress`、`completed`or`incomplete` |

Summary of reasoning:

| Properties| Type| required| Description|
|------|------|------|------|
| text | string| Yes| A short summary of the inference used by the model when generating the response|
| type | string| Yes| The type of object, always`summary_text` |

##### project reference

| Properties| Type| required| Description|
|------|------|------|------|
| id | string| Yes| The ID of the project to reference|
| type | string| No| The type of item to reference, always`item_reference` |

#### model

**Type**: string
**Required**: Yes

The model ID used to generate the response, such as gpt-4.1 or o3. OpenAI offers a variety of models with varying capabilities, performance characteristics, and price points. See the model guide to browse and compare available models.

#### include

**Type**: array or null
**Required**: No

Specifies additional output data to include in the model response. Currently supported values include:

| value| Description|
|------|------|
| `file_search_call.results` | Contains search results for file search tool calls|
| `message.input_image.image_url` | Contains the image URL from the input message|
| `computer_call_output.output.image_url` | Contains the image URL in the computer call output|
| `reasoning.encrypted_content` | Include an encrypted version of the inference token in the inference item output|

#### instructions

**Type**: string or null
**Required**: No

Insert a system (or developer) message as the first item in the model context.

when with`previous_response_id` When used together, directives from the previous response are not carried over to the next response. This makes it easy to switch system (developer) messages in new responses.

#### max_output_tokens

**Type**: integer or null
**Required**: No

The upper limit on the number of tokens that can be generated for a response, including visible output tokens and inference tokens.

#### metadata

**Type**: Object
**Required**: No

A collection of 16 key-value pairs that can be attached to an object. This is useful for storing additional information about an object in a structured format, and for querying the object via an API or dashboard.

Keys are strings with a maximum length of 64 characters. The value is a string with a maximum length of 512 characters.

#### parallel_tool_calls

**Type**: boolean or null
**Required**: No
**Default value**: true

Whether to allow the model to run tool calls in parallel.

#### previous_response_id

**Type**: string or null
**Required**: No

The unique ID of the model's previous response. Use this parameter to create a multi-turn conversation. Learn more about conversation status.

#### reasoning

**Type**: object or null
**Required**: No
**Available only for o-series models**

Configuration options for inference models.

| Properties| Type| required| Description|
|------|------|------|------|
| effort | string or null| No| Reasoning effort, optional values:`low`, `medium`, `high`. The default value is`medium`. Reducing inference effort results in faster responses and reduces the number of tokens used for inference in the response|
| summary | string or null| No| Summary of inference performed by the model. This is useful for debugging and understanding the model's inference process. Optional values:`auto`, `concise`, `detailed` |
| generate_summary | string or null| No| **DEPRECATED**: Please use`summary` substitute. Summary of inference performed by the model. Optional values:`auto`, `concise`, `detailed` |

#### service_tier

**Type**: string or null
**Required**: No
**Default**: auto

Specifies the latency level used to handle requests. This parameter is relevant for customers subscribed to the scale tier service:

| value| Description|
|------|------|
| `auto` | If the project has Scale tier enabled, scale tier credits will be used until exhausted; if the project does not have Scale tier enabled, requests will be processed using the default service tier, with a lower uptime SLA and no latency guarantees|
| `default` | Requests will be processed using the default service tier, with a low uptime SLA and no latency guarantees|
| `flex` | Requests will be processed using the Flex Processing service layer. For more information please refer to the official documentation|

When this parameter is not set, the default behavior is`auto`。

When this parameter is set, the response body will contain the used`service_tier`。

#### store

**Type**: boolean or null
**Required**: No
**Default value**: true

Whether to store the generated model response for later retrieval via the API.

#### stream

**Type**: boolean or null
**Required**: No
**Default value**: false

If set to true, model response data will be streamed to the client using server-sent events when generated.

#### temperature

**Type**: number or null
**Required**: No
**Default**: 1

The sampling temperature to use, between 0 and 2. Higher values ​​(like 0.8) make the output more random, while lower values ​​(like 0.2) make it more focused and deterministic. We generally recommend changing this value or`top_p`, but don't change both at the same time.

#### text

**Type**: Object
**Required**: No

Configuration options for model text responses. Can be plain text or structured JSON data.

| Properties| Type| required| Description|
|------|------|------|------|
| format | object| No| Specify the format in which the model must be output|

Configuration`{ "type": "json_schema" }` Enable structured output to ensure the model will match the JSON schema you provide. See the Structured Output Guide for more information.

The default format is`{ "type": "text" }`, there are no other options.

**Not recommended for gpt-4o and newer models**:
set to`{ "type": "json_object" }` Enables older JSON mode to ensure messages generated by the model are valid JSON. For supported models, it is preferred to use`json_schema`。

##### Text format type

###### Text

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| The defined response format type. always`text` |

###### JSON Schema

| Properties| Type| required| Description|
|------|------|------|------|
| name | string| Yes| The name of the response format. Must contain a-z, A-Z, 0-9, or include underscores and dashes, maximum length is 64|
| schema | object| Yes| The schema of the response format, described as a JSON Schema object|
| type | string| Yes| The defined response format type. always`json_schema` |
| description | string| No| A description of the purpose of the response format, which is used by the model to determine how to respond in that format|
| strict | boolean or null| No| Whether to enable strict mode compliance when generating output. Default is`false`. If set to`true`, the model will always follow the exact schema defined in the schema field. Only a subset of JSON Schema is supported in strict mode|

###### JSON Object

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| The defined response format type. always`json_object` |

Note: The model will not generate JSON without a system or user message instructing the model to do so. For supported models it is recommended to use`json_schema`。

#### tool_choice

**Type**: string or object
**Required**: No

How the model chooses the tool (or tools) to use when generating a response. See`tools` Parameters Learn how to specify tools that your model can call.

##### possible types

###### Tool choice mode

**Type**: string

Controls whether and which tools the model calls.

| value| Description|
|------|------|
| `none` | The model does not call any tools, but instead generates a message|
| `auto` | Models can choose between generating messages or calling one or more tools|
| `required` | The model must call one or more tools|

###### Hosted tool

**Type**: Object

Indicates that the model should use built-in tools to generate responses.

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| The type of hosting tool the model should use. Allowed values are:`file_search`、`web_search_preview`、`computer_use_preview` |

###### Function tool

**Type**: Object

Use this option to force the model to call a specific function.

| Properties| Type| required| Description|
|------|------|------|------|
| name | string| Yes| function name to call|
| type | string| Yes| For function calls, the type is always`function` |

#### tools

**Type**: Array
**Required**: No

An array of tools that the model may call when generating a response. You can set`tool_choice` Parameters to specify which tool to use.

The two types of tools you can provide to your model are:

- **Built-in Tools**: Tools provided by OpenAI to extend model capabilities, such as web search or file search.
- **Function Call (Custom Tool)**: A function defined by you that enables the model to call your own code.

##### File search tool (File search)

**Type**: Object

A tool to search for relevant content in uploaded files.

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| Type of file search tool, always`file_search` |
| vector_store_ids | array| Yes| List of vector storage IDs to search for|
| filters | object| No| Filter to apply|
| max_num_results | integer| No| The maximum number of results returned. This number should be between 1 and 50 (inclusive)|
| ranking_options | object| No| Search ranking options|

###### filter type

**Comparison Filter**

| Properties| Type| required| Description|
|------|------|------|------|
| key | string| Yes| The key to compare the value with|
| type | string| Yes| Specify comparison operator:`eq`, `ne`, `gt`, `gte`, `lt`, `lte`<br>- eq: equal to<br>- ne: not equal to<br>- gt: greater than<br>- gte: greater than or equal to<br>- lt: less than<br>- lte: less than or equal to|
| value | String/Number/Boolean| Yes| The value to compare with the property key; supports string, number, or boolean types|

**Compound Filter**

| Properties| Type| required| Description|
|------|------|------|------|
| filters | array| Yes| Array of filters to combine. Items can be comparison filters or composite filters|
| type | string| Yes| Operation type:`and` or`or` |

###### Ranking options

| Properties| Type| required| Description|
|------|------|------|------|
| ranker | string| No| Ranker used by file search|
| score_threshold | numbers| No| Score threshold for file searches, a number between 0 and 1. Numbers closer to 1 will try to return only the most relevant results, but may return fewer results|

##### Function tool (Function)

**Type**: Object

Define functions in your own code that the model can optionally call.

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| Type of function tool, always`function` |
| name | string| Yes| function name to call|
| parameters | object| Yes| JSON schema object describing function parameters|
| strict | Boolean value| Yes| Whether to force strict parameter validation. Default is`true` |
| description | string| No| Description of the function. The model uses this to determine whether to call the function|

##### Web search preview

**Type**: Object

This tool searches the web for relevant results for responses.

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| Types of web search tools. Optional values:`web_search_preview` or`web_search_preview_2025_03_11` |
| search_context_size | string| No| High-level guidance on the amount of context window space used for searches. Optional values:`low`, `medium`, `high`. Default is`medium` |
| user_location | object| No| User's location|
| domains | array| No| List of domain names to limit searches|

###### user location

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| Location approximation type. always`approximate` |
| city | string| No| Free text input for the user's city, such as "San Francisco"|
| country | string| No| The user's two-letter ISO country code, such as "US"|
| region | string| No| Free text input for the user's locale, such as "California"|
| timezone | string| No| The user's IANA time zone, for example "America/Los_Angeles"|

##### Computer use preview

**Type**: Object

Tools for controlling virtual computers.

| Properties| Type| required| Description|
|------|------|------|------|
| type | string| Yes| Types of computer tools. always`computer_use_preview` |
| display_height | integer| Yes| computer monitor height|
| display_width | integer| Yes| computer monitor width|
| environment | string| Yes| The type of computer environment to control|

#### top_p

**Type**: number or null
**Required**: No
**Default**: 1

An alternative to sampling temperature is called kernel sampling, where the model considers labeled results with top_p probability mass. Therefore, 0.1 means that only tokens containing the top 10% probability mass are considered.

We generally recommend changing this value or`temperature`, but don't change both at the same time.

#### truncation

**Type**: string or null
**Required**: No
**Default value**: disabled

Truncation strategy for model responses:

| value| Description|
|------|------|
| `auto` | If the context of this response and the previous response exceeds the model's context window size, the model will truncate the response to fit the context window by removing entries in the middle of the conversation|
| `disabled` | If the model response would exceed the model's context window size, the request will fail with a 400 error|

#### user

**Type**: string
**Required**: No

Represents a unique identifier for the end user that helps OpenAI monitor and detect abuse.

## 📥Response

Returns a response object.

### successful response

Returns a response object, or a streaming sequence of response objects if the request was streamed.

#### id 
- Type: string
- Description: The unique identifier of the response

#### object
- Type: string
- Description: Object type, value is "response"

#### created_at
- Type: integer
- Description: Response creation timestamp

#### status
- Type: string
- Description: Response status, such as "completed", "in_progress", etc.

#### error
- Type: object or null
- Description: If an error occurs, include the error message

#### incomplete_details
- Type: object or null
- Description: Contains details if the response is incomplete

#### instructions
- Type: string or null
- Description: System instructions provided to the model

#### max_output_tokens
- Type: integer or null
- Description: Maximum number of output tags

#### model
- Type: string
- Description: Model name used

#### output
- Type: array
- Description: Contains generated responses and tool calls
- May include:
  - message object (`type`: "message"）
  - Tool usage object (`type`: "tool_use"）

#### parallel_tool_calls
- Type: boolean
- Description: Whether to enable parallel tool calls

#### previous_response_id
- Type: string or null
- Description: ID of the previous response (for multi-round conversations)

#### reasoning
- Type: Object
- Description: Inference related information

#### store
- Type: boolean
- Description: Whether to store this response

#### temperature
- Type: number
- Description: Sampling temperature used

#### text
- Type: Object
- Description: Text output format configuration

#### tool_choice
- Type: string
- Description: Tool Selection Strategy

#### tools
- Type: array
- Description: List of available tools

#### top_p
- Type: number
- Description: Kernel sampling threshold

#### truncation
- Type: string
- Description: Truncation strategy

#### usage
- Type: Object
- Description: token usage statistics
- Properties:
  - `input_tokens`: Enter the number of tokens used
  - `input_tokens_details`: Enter token details
  - `output_tokens`: Output the number of tokens used
  - `output_tokens_details`: Output token details
  - `total_tokens`:Total number of tokens

#### user
- Type: string or null
- Description: User identifier

#### metadata
- Type: Object
- Description: Additional metadata information
