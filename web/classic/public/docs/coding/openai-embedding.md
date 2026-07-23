# OpenAI 嵌入格式（Embeddings）

### 简介

获取给定输入文本的向量表示，这些向量可以被机器学习模型和算法轻松使用。相关指南请参阅 [Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)。

!> 本站所有支持的向量模型均使用此格式请求响应，如谷歌的```text-embedding-004```、```gemini-embedding-exp-03-07```

需要注意的是:

- 某些模型可能对输入的总 token 数有限制

- 您可以使用[示例 Python 代码](https://github.com/openai/openai-cookbook/blob/main/examples/How_to_count_tokens_with_tiktoken.ipynb)来计算 token 数量

- 例如：text-embedding-ada-002 模型的输出向量维度为 1536

### 创建文本嵌入:

```
curl https://api.wukong.support/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "input": "The food was delicious and the waiter...",
    "model": "text-embedding-ada-002",
    "encoding_format": "float"
  }'
  
```

### 响应示例:

```
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "embedding": [
        0.0023064255,
        -0.009327292,
        // ... (1536 个浮点数,用于 ada-002)
        -0.0028842222
      ],
      "index": 0
    }
  ],
  "model": "text-embedding-ada-002",
  "usage": {
    "prompt_tokens": 8,
    "total_tokens": 8
  }
}
```

### 批量创建嵌入:

```
curl https://api.wukong.support/v1/embeddings \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "input": ["The food was delicious", "The waiter was friendly"],
    "model": "text-embedding-ada-002",
    "encoding_format": "float"
  }'
  
```

### 响应示例:

```
{
  "object": "list",
  "data": [
    {
      "object": "embedding",
      "embedding": [
        0.0023064255,
        // ... (1536 个浮点数)
      ],
      "index": 0
    },
    {
      "object": "embedding",
      "embedding": [
        -0.008815289,
        // ... (1536 个浮点数)  
      ],
      "index": 1
    }
  ],
  "model": "text-embedding-ada-002",
  "usage": {
    "prompt_tokens": 12,
    "total_tokens": 12
  }
}
```


### 错误响应
当请求出现问题时，API 将返回一个错误响应对象，HTTP 状态码在 4XX-5XX 范围内。

### 常见错误状态码
- 401 Unauthorized: API 密钥无效或未提供
- 400 Bad Request: 请求参数无效，例如输入为空或超出 token 限制
- 429 Too Many Requests: 超出 API 调用限制
- 500 Internal Server Error: 服务器内部错误

### 错误响应示例:

```
{
  "error": {
    "message": "The input exceeds the maximum length. Please reduce the length of your input.",
    "type": "invalid_request_error",
    "param": "input",
    "code": "context_length_exceeded"
  }
}
```





