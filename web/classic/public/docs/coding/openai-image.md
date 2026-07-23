# OpenAI 图像格式（Dall·E）

### 简介

给定文本提示和/或输入图片，模型将生成新的图片。DALL·E 是一个强大的图像生成模型，可以根据自然语言描述创建、编辑和修改图像。目前支持 DALL·E 2 和 DALL·E 3 两个版本，它们在图像质量、创意表现和精确度上都有显著差异。

```Flux``` 绘画模型兼容此格式。

### 创建图片

```
# 基础图片生成
curl https://api.wukong.support/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的皮卡丘",
    "n": 1,
    "size": "1024x1024"
  }'

# 高质量图片生成
curl https://api.wukong.support/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的皮卡丘",
    "quality": "hd",
    "style": "vivid",
    "size": "1024x1024"
  }'

# 使用 base64 返回格式
curl https://api.wukong.support/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "dall-e-3",
    "prompt": "一只可爱的皮卡丘",
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
      "revised_prompt": "一只可爱的皮卡丘"
    }
  ]
}
```

