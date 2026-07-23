# 通义千问图像模型 API 文档 (悟空API格式)

本文档整合了通义千问的**文生图**与**图像编辑**功能接口说明。所有接口均采用 openai 兼容格式。

**基础服务域名**：`api.wukong.support`

---

## 1. 通义千问-文生图 API

通过文本描述生成图像。该模型支持多种艺术风格，尤其擅长复杂文本渲染。

### 接口说明

- **接口地址**：`POST https://api.wukong.support/v1/images/generations`
- **认证方式**：Bearer Token

### 请求参数

#### Headers

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| Authorization | string | 是 | 认证Token，格式：`Bearer sk-xxxxxx` |
| Content-Type | string | 是 | 必须设置为 `application/json` |

#### Request Body

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| model | string | 是 | 模型名称，可选值：<br/>- `qwen-image-max`（推荐）<br/>- `qwen-image-plus`<br/>- `qwen-image` <br/>-`z-image-turbo`|
| input | object | 是 | 输入参数对象 |
| input.messages | array | 是 | 消息数组，当前仅支持单轮对话 |
| input.messages[0].role | string | 是 | 固定为 `"user"` |
| input.messages[0].content | array | 是 | 消息内容数组 |
| input.messages[0].content[0].text | string | 是 | 正向提示词，描述期望生成的图像内容、风格和构图。支持中英文，长度不超过800个字符 |
| parameters | object | 否 | 生成参数 |

#### parameters 参数说明

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| negative_prompt | string | 否 | 反向提示词，描述不希望出现在图像中的内容。支持中英文，长度不超过500个字符 |
| size | string | 否 | 输出图像分辨率，格式为 `宽*高`。<br/>可选值：<br/>- `1664*928`（默认，16:9）<br/>- `1472*1104`（4:3）<br/>- `1328*1328`（1:1）<br/>- `1104*1472`（3:4）<br/>- `928*1664`（9:16） <br/>-`z-image-turbo` 总像素范围限制：总像素在 [512*512, 2048*2048]之间。|
| n | integer | 否 | 生成图像数量，当前固定为1 |
| prompt_extend | boolean | 否 | 是否开启提示词智能改写，默认为 `true` |
| watermark | boolean | 否 | 是否在图像右下角添加"Qwen-Image"水印，默认为 `false` |
| seed | integer | 否 | 随机数种子，取值范围 [0, 2147483647] |

### 请求示例

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

### 响应参数

| 参数名 | 类型 | 说明 |
|--------|------|------|
| created | integer | 创建时间戳 |
| data | array | 生成结果数组 |
| data[0].url | string | 生成图像的URL，有效期为24小时 |
| data[0].b64_json | string | 图像的Base64编码（可选） |
| data[0].revised_prompt | string | 优化后的提示词 |

### 响应示例

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

### 错误响应

| HTTP状态码 | 错误类型 | 说明 |
|-----------|---------|------|
| 400 | InvalidRequest | 请求参数错误 |
| 401 | AuthenticationError | API Key无效或过期 |
| 429 | RateLimitError | 超过频率限制 |
| 500 | InternalServerError | 服务内部错误 |

#### 错误响应示例

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

### 注意事项

1. **图像URL有效期**：生成的图像链接有效期为24小时，请及时下载保存
2. **提示词限制**：正向提示词最多800字符，反向提示词最多500字符
3. **图像数量**：当前仅支持生成1张图像
4. **图像格式**：输出图像为PNG格式

---

## 2. 通义千问-图像编辑 API

图像编辑模型支持多图输入和多图输出，可精确修改图内文字、增删或移动物体、改变主体动作、迁移图片风格及增强画面细节。

### 接口说明

- **接口地址**：`POST https://api.wukong.support/v1/images/edits`
- **认证方式**：Bearer Token

### 请求参数

#### Headers

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| Authorization | string | 是 | 认证Token，格式：`Bearer sk-xxxxxx` |
| Content-Type | string | 是 | 必须设置为 `application/json` |

#### Request Body

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| model | string | 是 | 模型名称，可选值：<br/>- `qwen-image-edit-max`（推荐）<br>- `qwen-image-edit-plus` |
| input | object | 是 | 输入参数对象 |
| input.messages | array | 是 | 消息数组，当前仅支持单轮对话 |
| input.messages[0].role | string | 是 | 固定为 `"user"` |
| input.messages[0].content | array | 是 | 消息内容数组，包含1-3张图像和1个编辑指令 |
| parameters | object | 否 | 编辑参数 |

#### input.messages[0].content 参数说明

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| image | string | 条件必填 | 输入图像的URL或Base64编码数据。支持1-3张图像。多图输入时，输出图像比例以最后一张为准。 |
| text | string | 是 | 图像编辑指令，即正向提示词。多图编辑时需使用"图1"、"图2"、"图3"指代相应图片。支持中英文，长度不超过800个字符 |

**图像要求**：
- 格式：JPG、JPEG、PNG、BMP、TIFF、WEBP、GIF（GIF仅处理第一帧）
- 分辨率：建议384-3072像素之间
- 大小：不超过10MB
- 输入方式：公网可访问的URL或Base64编码字符串（格式：`data:image/jpeg;base64,GDU7MtCZz...`）

#### parameters 参数说明

| 参数名 | 类型 | 必填 | 说明 |
|--------|------|------|------|
| n | integer | 否 | 输出图像数量，默认为1。qwen-image-edit-plus系列支持1-6张，qwen-image-edit仅支持1张 |
| negative_prompt | string | 否 | 反向提示词，描述不希望出现在画面中的内容。支持中英文，长度不超过500个字符 |
| size | string | 否 | 输出图像分辨率，格式为`宽*高`，例如`"1024*2048"`。宽高范围[512, 2048]。若不设置，保持与输入图像（多图时为最后一张）相似的长宽比，接近1024*1024分辨率。仅qwen-image-edit-plus系列支持 |
| prompt_extend | boolean | 否 | 是否开启提示词智能改写，默认为`true`。仅qwen-image-edit-plus系列支持 |
| watermark | boolean | 否 | 是否在图像右下角添加"Qwen-Image"水印，默认为`false` |
| seed | integer | 否 | 随机数种子，取值范围[0, 2147483647]。使用相同seed可保持生成内容相对稳定 |

### 请求示例

#### 单图编辑示例

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

#### 多图融合示例

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

#### 使用Base64编码图像示例

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

### 响应参数

| 参数名 | 类型 | 说明 |
|--------|------|------|
| created | integer | 创建时间戳 |
| data | array | 生成结果数组 |
| data[0].url | string | 生成图像的URL，有效期为24小时 |
| data[0].b64_json | string | 图像的Base64编码（可选） |
| data[0].revised_prompt | string | 优化后的编辑指令 |

### 响应示例

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

### 错误响应

| HTTP状态码 | 错误类型 | 说明 |
|-----------|---------|------|
| 400 | InvalidRequest | 请求参数错误 |
| 401 | AuthenticationError | API Key无效或过期 |
| 404 | NotFound | 资源不存在 |
| 429 | RateLimitError | 超过频率限制 |
| 500 | InternalServerError | 服务内部错误 |

#### 错误响应示例

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

### 模型能力对比

| 模型名称 | 输出图片数量 | 自定义分辨率 | 提示词优化 |
|---------|------------|------------|----------|
| qwen-image-edit-plus | 1-6张 | 支持 | 支持 |
| qwen-image-edit-plus-2025-12-15 | 1-6张 | 支持 | 支持 |
| qwen-image-edit-plus-2025-10-30 | 1-6张 | 支持 | 支持 |
| qwen-image-edit | 1张 | 不支持 | 不支持 |

### 注意事项

1. **图像URL有效期**：生成的图像链接有效期为24小时，请及时下载保存
2. **多图编辑**：进行多图编辑时，编辑指令中必须使用"图1"、"图2"、"图3"等描述来指代相应图片
3. **输出比例**：多图输入时，输出图像比例以最后一张图片为准
4. **提示词限制**：编辑指令不超过800字符，反向提示词不超过500字符
5. **图像数量限制**：qwen-image-edit-plus系列支持1-6张输出，qwen-image-edit仅支持1张
6. **图像格式**：输出图像为PNG格式
7. **多轮对话**：当前仅支持单轮对话，不支持多轮编辑
8. **Base64编码**：上传Base64编码图像时，必须包含MIME类型前缀，如`data:image/jpeg;base64,xxx`
9. **GIF处理**：GIF动图仅处理第一帧

### 常见问题

#### Q：如何修改生成的图片？
A：需要将上一次生成的图片作为新输入再次调用API，模型不支持多轮对话式编辑。

#### Q：多图输入时输出尺寸如何确定？
A：输出图像的长宽比以最后一张输入图片为准，可以通过size参数指定具体尺寸。

#### Q：支持哪些语言的提示词？
A：正式支持简体中文和英文，其他语言可自行尝试，但效果未经充分验证。

#### Q：图像URL如何转为永久链接？
A：临时链接无法直接转为永久链接，需要通过后端服务下载图像，再上传至对象存储服务（如阿里云OSS）生成新的永久链接。