# Tongyi Qianwen Image Model API Document (Wukong API Format)

This document integrates Tongyi Qianwen’s **Wen Sheng Diagram** and **Image Editing** functional interface descriptions. All interfaces are in openai compatible format.

**Basic service domain name**:`api.wukong.support`

---

## 1. Tongyi Qianwen - Vincentian Diagram API

Generate images from text descriptions. The model supports a variety of art styles and is especially good at rendering complex text.

### Interface description

- **Interface address**:`POST https://api.wukong.support/v1/images/generations`
- **Authentication method**: Bearer Token

### Request parameters

#### Headers

| Parameter name| Type| Required| Description|
|--------|------|------|------|
| Authorization | string | Yes| Authentication Token, format:`Bearer sk-xxxxxx` |
| Content-Type | string | Yes| Must be set to`application/json` |

#### Request Body

| Parameter name| Type| Required| Description|
|--------|------|------|------|
| model | string | Yes| Model name, optional values:<br/>- `qwen-image-max`(recommended)<br/>- `qwen-image-plus`<br/>- `qwen-image` <br/>-`z-image-turbo`|
| input | object | Yes| input parameter object|
| input.messages | array | Yes| Message array, currently only supports single-round dialogue|
| input.messages[0].role | string | Yes| fixed to`"user"` |
| input.messages[0].content | array | Yes| Message content array|
| input.messages[0].content[0].text | string | Yes| Positive cue words that describe the desired image content, style, and composition. Supports Chinese and English, the length does not exceed 800 characters|
| parameters | object | No| Generate parameters|

#### parameters parameter description

| Parameter name| Type| Required| Description|
|--------|------|------|------|
| negative_prompt | string | No| Reverse hint words describing content that is not intended to appear in the image. Supports Chinese and English, the length should not exceed 500 characters|
| size | string | No| The output image resolution is in the format`宽*高`。<br/>Optional values:<br/>- `1664*928`(Default, 16:9)<br/>- `1472*1104`（4:3）<br/>- `1328*1328`（1:1）<br/>- `1104*1472`（3:4）<br/>- `928*1664`（9:16） <br/>-`z-image-turbo` Total pixel range limit: total pixels inBetween [512*512, 2048*2048].|
| n | integer | No| Number of generated images, currently fixed at 1|
| prompt_extend | boolean | No| Whether to enable intelligent rewriting of prompt words, the default is`true` |
| watermark | boolean | No| Whether to add "Qwen-Image" watermark in the lower right corner of the image, the default is`false` |
| seed | integer | No| Random number seed, value range[0, 2147483647] |

### Request example

#### cURL

```bash
curl -X POST "https://api.wukong.support/v1/images/generations" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen-image-max",
    "input": {
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "text": "一只坐着的橘黄色的猫，表情愉悦，活泼可爱，逼真准确"
            }
          ]
        }
      ]
    },
    "parameters": {
      "size": "1328*1328",
      "negative_prompt": "低分辨率，低画质，肢体畸形，手指畸形",
      "prompt_extend": true,
      "watermark": false
    }
  }'
```

#### Python

```python
import requests

url = "https://api.wukong.support/v1/images/generations"
headers = {
    "Authorization": "Bearer sk-xxxxxx",
    "Content-Type": "application/json"
}

data = {
    "model": "qwen-image-max",
    "input": {
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "text": "一只坐着的橘黄色的猫，表情愉悦，活泼可爱，逼真准确"
                    }
                ]
            }
        ]
    },
    "parameters": {
        "size": "1328*1328",
        "negative_prompt": "低分辨率，低画质，肢体畸形，手指畸形",
        "prompt_extend": True,
        "watermark": False
    }
}

response = requests.post(url, headers=headers, json=data)
print(response.json())
```

### response parameters

| Parameter name| Type| Description|
|--------|------|------|
| created | integer | Create timestamp|
| data | array | Generate result array|
| data[0].url | string | Generates the URL of the image, valid for 24 hours|
| data[0].b64_json | string | Base64 encoding of the image (optional)|
| data[0].revised_prompt | string | Optimized prompt words|

### Response example

```json
{
  "created": 1704304000,
  "data": [
    {
      "url": "https://dashscope-result-sh.oss-cn-shanghai.aliyuncs.com/xxx.png?Expires=xxx",
      "b64_json": null,
      "revised_prompt": "一只坐着的橘黄色的猫，表情愉悦，活泼可爱，逼真准确，细节丰富"
    }
  ]
}
```

### error response

| HTTP status code| Error type| Description|
|-----------|---------|------|
| 400 | InvalidRequest | Request parameter error|
| 401 | AuthenticationError | API Key is invalid or expired|
| 429 | RateLimitError | Frequency limit exceeded|
| 500 | InternalServerError | Service internal error|

#### Error response example

```json
{
  "error": {
    "message": "Invalid model: qwen-image-xxx",
    "type": "invalid_request_error",
    "param": "model",
    "code": null
  }
}
```

### Things to note

1. **Image URL validity period**: The generated image link is valid for 24 hours, please download and save it in time
2. **Prompt word limit**: The forward prompt word can be up to 800 characters, and the reverse prompt word can be up to 500 characters.
3. **Number of images**: Currently only supports generating 1 image
4. **Image format**: The output image is in PNG format

---

## 2. Tongyi Qianwen-Image Editing API

The image editing model supports multi-picture input and multi-picture output, and can accurately modify text in pictures, add, delete or move objects, change subject movements, transfer picture styles and enhance picture details.

### Interface description

- **Interface address**:`POST https://api.wukong.support/v1/images/edits`
- **Authentication method**: Bearer Token

### Request parameters

#### Headers

| Parameter name| Type| Required| Description|
|--------|------|------|------|
| Authorization | string | Yes| Authentication Token, format:`Bearer sk-xxxxxx` |
| Content-Type | string | Yes| Must be set to`application/json` |

#### Request Body

| Parameter name| Type| Required| Description|
|--------|------|------|------|
| model | string | Yes| Model name, optional values:<br/>- `qwen-image-edit-max`(recommended)<br>- `qwen-image-edit-plus` |
| input | object | Yes| input parameter object|
| input.messages | array | Yes| Message array, currently only supports single-round dialogue|
| input.messages[0].role | string | Yes| fixed to`"user"` |
| input.messages[0].content | array | Yes| Message content array, containing 1-3 images and 1 editing command|
| parameters | object | No| Edit parameters|

#### input.messages[0].content parameter description

| Parameter name| Type| Required| Description|
|--------|------|------|------|
| image | string | Condition required| Enter the URL or Base64 encoded data of the image. Supports 1-3 images. When multiple images are input, the output image proportion will be based on the last one. |
| text | string | Yes| Image editing instructions, namely positive prompt words. When editing multiple pictures, you need to use "Picture 1", "Picture 2", and "Picture 3" to refer to the corresponding pictures. Supports Chinese and English, the length does not exceed 800 characters|

**Image Requirements**:
- Format: JPG, JPEG, PNG, BMP, TIFF, WEBP, GIF (GIF only processes the first frame)
- Resolution: Recommended between 384-3072 pixels
- Size: no more than 10MB
- Input method: URL accessible from the public network or Base64 encoded string (format:`data:image/jpeg;base64,GDU7MtCZz...`）

#### parameters parameter description

| Parameter name| Type| Required| Description|
|--------|------|------|------|
| n | integer | No| Number of output images, default is 1. qwen-image-edit-plus series supports 1-6 images, qwen-image-edit only supports 1 image|
| negative_prompt | string | No| Reverse prompt words describing content that you do not want to appear in the screen. Supports Chinese and English, the length should not exceed 500 characters|
| size | string | No| The output image resolution is in the format`宽*高`, for example`"1024*2048"`. Width and height range[512, 2048]. If not set, the aspect ratio will be similar to the input image (the last one in the case of multiple images), close to the 1024*1024 resolution. Only supported by qwen-image-edit-plus series|
| prompt_extend | boolean | No| Whether to enable intelligent rewriting of prompt words, the default is`true`. Only supported by qwen-image-edit-plus series|
| watermark | boolean | No| Whether to add "Qwen-Image" watermark in the lower right corner of the image, the default is`false` |
| seed | integer | No| Random number seed, value range[0, 2147483647]. Using the same seed can keep the generated content relatively stable.|

### Request example

#### Single image editing example

**cURL**

```bash
curl -X POST "https://api.wukong.support/v1/images/edits" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen-image-edit-plus",
    "input": {
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "image": "https://example.com/input-image.png"
            },
            {
              "text": "将图像中的猫换成狗，保持其他内容不变"
            }
          ]
        }
      ]
    },
    "parameters": {
      "n": 2,
      "negative_prompt": "低质量，模糊，扭曲",
      "prompt_extend": true,
      "watermark": false
    }
  }'
```

**Python**

```python
import requests

url = "https://api.wukong.support/v1/images/edits"
headers = {
    "Authorization": "Bearer sk-xxxxxx",
    "Content-Type": "application/json"
}

data = {
    "model": "qwen-image-edit-plus",
    "input": {
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "image": "https://example.com/input-image.png"
                    },
                    {
                        "text": "将图像中的猫换成狗，保持其他内容不变"
                    }
                ]
            }
        ]
    },
    "parameters": {
        "n": 2,
        "negative_prompt": "低质量，模糊，扭曲",
        "prompt_extend": True,
        "watermark": False
    }
}

response = requests.post(url, headers=headers, json=data)
print(response.json())
```

#### Multi-graph fusion example

```bash
curl -X POST "https://api.wukong.support/v1/images/edits" \
  -H "Authorization: Bearer sk-xxxxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "qwen-image-edit-plus",
    "input": {
      "messages": [
        {
          "role": "user",
          "content": [
            {
              "image": "https://example.com/image1.png"
            },
            {
              "image": "https://example.com/image2.png"
            },
            {
              "image": "https://example.com/image3.png"
            },
            {
              "text": "图1中的女生穿着图2中的黑色裙子按图3的姿势坐下，保持其服装、发型和表情不变，动作自然流畅"
            }
          ]
        }
      ]
    },
    "parameters": {
      "n": 2,
      "size": "1024*1024"
    }
  }'
```

#### Example of encoding an image using Base64

```python
import base64
import requests

# 将本地图片转换为Base64编码
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')

image_base64 = encode_image("input.jpg")

url = "https://api.wukong.support/v1/images/edits"
headers = {
    "Authorization": "Bearer sk-xxxxxx",
    "Content-Type": "application/json"
}

data = {
    "model": "qwen-image-edit-plus",
    "input": {
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "image": f"data:image/jpeg;base64,{image_base64}"
                    },
                    {
                        "text": "给这张图片添加一个天空"
                    }
                ]
            }
        ]
    },
    "parameters": {
        "n": 1
    }
}

response = requests.post(url, headers=headers, json=data)
print(response.json())
```

### response parameters

| Parameter name| Type| Description|
|--------|------|------|
| created | integer | Create timestamp|
| data | array | Generate result array|
| data[0].url | string | Generates the URL of the image, valid for 24 hours|
| data[0].b64_json | string | Base64 encoding of the image (optional)|
| data[0].revised_prompt | string | Optimized editing instructions|

### Response example

```json
{
  "created": 1704304000,
  "data": [
    {
      "url": "https://dashscope-result-sz.oss-cn-shenzhen.aliyuncs.com/xxx.png?Expires=xxx",
      "b64_json": null,
      "revised_prompt": "图1中的女生穿着图2中的黑色裙子按图3的姿势坐下，保持其服装、发型和表情不变，动作自然流畅，细节丰富"
    },
    {
      "url": "https://dashscope-result-sz.oss-cn-shenzhen.aliyuncs.com/xxx.png?Expires=xxx",
      "b64_json": null,
      "revised_prompt": "图1中的女生穿着图2中的黑色裙子按图3的姿势坐下，保持其服装、发型和表情不变，动作自然流畅，细节丰富"
    }
  ]
}
```

### error response

| HTTP status code| Error type| Description|
|-----------|---------|------|
| 400 | InvalidRequest | Request parameter error|
| 401 | AuthenticationError | API Key is invalid or expired|
| 404 | NotFound | Resource does not exist|
| 429 | RateLimitError | Frequency limit exceeded|
| 500 | InternalServerError | Service internal error|

#### Error response example

```json
{
  "error": {
    "message": "Invalid model: qwen-image-xxx",
    "type": "invalid_request_error",
    "param": "model",
    "code": null
  }
}
```

### Comparison of model capabilities

| Model name| Number of output pictures| Custom resolution| Prompt word optimization|
|---------|------------|------------|----------|
| qwen-image-edit-plus | 1-6 pictures| support| support|
| qwen-image-edit-plus-2025-12-15 | 1-6 pictures| support| support|
| qwen-image-edit-plus-2025-10-30 | 1-6 pictures| support| support|
| qwen-image-edit | 1 piece| Not supported| Not supported|

### Things to note

1. **Image URL validity period**: The generated image link is valid for 24 hours, please download and save it in time
2. **Multiple picture editing**: When editing multiple pictures, descriptions such as "Picture 1", "Picture 2" and "Picture 3" must be used in the editing instructions to refer to the corresponding pictures.
3. **Output Proportion**: When multiple images are input, the output image proportion is based on the last image.
4. **Prompt word limit**: Editing instructions cannot exceed 800 characters, and reverse prompt words cannot exceed 500 characters.
5. **Image quantity limit**: qwen-image-edit-plus series supports 1-6 output images, qwen-image-edit only supports 1 image
6. **Image format**: The output image is in PNG format
7. **Multi-round dialogue**: Currently only single-round dialogue is supported, and multi-round editing is not supported.
8. **Base64 encoding**: When uploading a Base64 encoded image, the MIME type prefix must be included, such as`data:image/jpeg;base64,xxx`
9. **GIF processing**: GIF animation only processes the first frame

### FAQ

#### Q: How to modify the generated pictures?
A: The last generated image needs to be used as new input to call the API again. The model does not support multi-round conversational editing.

#### Q: How to determine the output size when inputting multiple images?
A: The aspect ratio of the output image is based on the last input image. You can specify the specific size through the size parameter.

#### Q: Which languages are supported for prompt words?
A: Simplified Chinese and English are officially supported. You can try other languages by yourself, but the effect has not been fully verified.

#### Q: How to convert image URL to permanent link?
A: The temporary link cannot be directly converted into a permanent link. The image needs to be downloaded through the backend service and then uploaded to the object storage service (such as Alibaba Cloud OSS) to generate a new permanent link.