# OpenAI Embeddings

### Introduction

Get vector representations of the given input text that can be easily used by machine learning models and algorithms. See related guidance[Embeddings Guide](https://platform.openai.com/docs/guides/embeddings)。

!> All vector models supported by this site use this format to request responses, such as Google's```text-embedding-004```、```gemini-embedding-exp-03-07```

Things to note are:

- Some models may have limits on the total number of input tokens

- You can use[Example Python code](https://github.com/openai/openai-cookbook/blob/main/examples/How_to_count_tokens_with_tiktoken.ipynb)To calculate the number of tokens

- For example: the output vector dimension of the text-embedding-ada-002 model is 1536

### Create a text embed:

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

### Response example:

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

### Create embeds in batches:

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

### Response example:

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


### error response
When there is a problem with a request, the API will return an error response object with an HTTP status code in the 4XX-5XX range.

### Common error status codes
- 401 Unauthorized: API key is invalid or not provided
- 400 Bad Request: The request parameters are invalid, such as the input is empty or the token limit is exceeded
- 429 Too Many Requests: API call limit exceeded
- 500 Internal Server Error: Server internal error

### Error response example:

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





