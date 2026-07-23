# OpenAI image format (Dall·E)

### Introduction

Given a text prompt and/or an input image, the model will generate new images. DALL·E is a powerful image generation model that can create, edit and modify images based on natural language descriptions. Currently supported are DALL·E 2 and DALL·E 3 versions, which offer significant differences in image quality, creative expression and accuracy.

```Flux``` 绘画模型兼容此格式。

### 创建图片

```
# Basic image generation
curl https://api.wukong.support/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "A cute Pikachu",
    "n": 1,
    "size": "1024x1024"
  }'

# High quality image generation
curl https://api.wukong.support/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "A cute Pikachu",
    "quality": "hd",
    "style": "vivid",
    "size": "1024x1024"
  }'

# Use base64 return format
curl https://api.wukong.support/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "A cute Pikachu",
    "response_format": "b64_json"
  }'

```

### 响应示例:

```
{
  "created": 1589478378,
  "data": [
    {
      "url": "https://...",
      "revised_prompt": "A cute Pikachu"
    }
  ]
}
```

