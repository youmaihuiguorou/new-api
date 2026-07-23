### seeddream drawing

---

#### **Basic information**
- **Interface name**: Dream Drawing
- **Request method**:`POST`
- **Request path**:`/v1/images/generations`
- **Feature**: Supports multi-image reference

---

#### **Request Parameters**
##### **Header parameters**
| Parameter name| Type| required| Default value| Description|
|----------------|----------|------|-------------------------|--------------------------|
| Authorization  | string   | Must| `Bearer {{YOUR_API_KEY}}` | API authentication token|

##### **Body parameter(`application/json`）**
| Parameter name| Type| required| Description|
|-----------------------------|-----------------|------|----------------------------------------------------------------------|
| `model`                     | string          | required| Model name (example:`doubao-seedream-4-5-251128`、`doubao-seedream-5-0-260128`）                      |
| `prompt`                    | string          | required| Image description text|
| `image`                     | array[string]   | Optional| Reference image URL array (without this parameter, it will be Vincentian image)|
| `response_format`           | string          | Optional| Response format (example:`url`）                                              |
| `size`                      | string          | Optional| Image size (example:`2K`、`4k`）`doubao-seedream-5-0-260128` Only supports 2k|
| `stream`                    | boolean         | Optional| Whether to stream|
| `watermark`                 | boolean         | Optional| Whether to add watermark|
| `output_format`                 | string         | Optional| Specify the file format of the generated image, optional values:`png`、`jpeg` only`doubao-seedream-5-0-260128`support|
---

#### **Request Example**
```json
{
    "model": "doubao-seedream-4-5-251128",
    "prompt": "生成女孩和奶牛玩偶在游乐园开心地坐过山车的图片，涵盖早晨、中午、晚上",
    "image": [
        "https://ark-project.tos-cn-beijing.volces.com/doc_image/seedream4_imagesToimages_1.png",
        "https://ark-project.tos-cn-beijing.volces.com/doc_image/seedream4_imagesToimages_2.png"
    ],
    "size": "2K",
    "watermark": false
}
```

---

#### **Request Sample Code (cURL)**
```bash
curl --location --request POST '/v1/images/generations' \
--header 'Authorization: Bearer {{YOUR_API_KEY}}' \
--header 'Content-Type: application/json' \
--data-raw '{
    "model": "doubao-seedream-4-5-251128",
    "prompt": "生成女孩和奶牛玩偶在游乐园开心地坐过山车的图片，涵盖早晨、中午、晚上",
    "image": [
        "https://ark-project.tos-cn-beijing.volces.com/doc_image/seedream4_imagesToimages_1.png",
        "https://ark-project.tos-cn-beijing.volces.com/doc_image/seedream4_imagesToimages_2.png"
    ],
    "size": "2K",
    "watermark": false
}'
```

---

#### **Response**
##### **Successful response (200)**
- **Format**:`application/json`
- **Response body structure**:
  ```json
  {
      "data": [
          {
              "url": "string"  // 图片下载链接
          }
      ],
      "created": "integer",       // 生成时间戳
      "usage": {
          "prompt_tokens": "integer",            // 输入 Token 数
          "completion_tokens": "integer",        // 输出 Token 数
          "total_tokens": "integer",             // 总 Token 数
          "prompt_tokens_details": {
              "cached_tokens_details": {}        // 缓存 Token 详情
          },
          "completion_tokens_details": {},       // 输出 Token 详情
          "output_tokens": "integer"             // 输出 Token 总数
      }
  }
  ```

##### **Response Example**
```json
{
    "data": [
        {
            "url": "https://ark-content-generation-v2-cn-beijing.tos-cn-beijing.volces.com/doubao-seedream-4-0/021758199935261f8c6a85cf57ff2d1ecf10d9f546f1158255386_0.jpeg?X-Tos-Algorithm=TOS4-HMAC-SHA256&X-Tos-Credential=AKLTYWJkZTExNjA1ZDUyNDc3YzhjNTM5OGIyNjBhNDcyOTQ%2F20250918%2Fcn-beijing%2Ftos%2Frequest&X-Tos-Date=20250918T125341Z&X-Tos-Expires=86400&X-Tos-Signature=dffc83ae6623fee4120bb06983d468a44bcc9a11517b62e2e70a1cca6eceaf77&X-Tos-SignedHeaders=host"
        },
        {
            "url": "https://ark-content-generation-v2-cn-beijing.tos-cn-beijing.volces.com/doubao-seedream-4-0/021758199935261f8c6a85cf57ff2d1ecf10d9f546f1158255386_1.jpeg?X-Tos-Algorithm=TOS4-HMAC-SHA256&X-Tos-Credential=AKLTYWJkZTExNjA1ZDUyNDc3YzhjNTM5OGIyNjBhNDcyOTQ%2F20250918%2Fcn-beijing%2Ftos%2Frequest&X-Tos-Date=20250918T125342Z&X-Tos-Expires=86400&X-Tos-Signature=49dbf3d03e33ba0120ea415945795dccad2eb9c154b2b651a359f520c3c8c11d&X-Tos-SignedHeaders=host"
        },
        {
            "url": "https://ark-content-generation-v2-cn-beijing.tos-cn-beijing.volces.com/doubao-seedream-4-0/021758199935261f8c6a85cf57ff2d1ecf10d9f546f1158255386_2.jpeg?X-Tos-Algorithm=TOS4-HMAC-SHA256&X-Tos-Credential=AKLTYWJkZTExNjA1ZDUyNDc3YzhjNTM5OGIyNjBhNDcyOTQ%2F20250918%2Fcn-beijing%2Ftos%2Frequest&X-Tos-Date=20250918T125343Z&X-Tos-Expires=86400&X-Tos-Signature=355adf061895c236cfa83cd945cdeb267ecc5d2a95b5c7290a8dd53c5f7a93d7&X-Tos-SignedHeaders=host"
        }
    ],
    "created": 1758200023,
    "usage": {
        "prompt_tokens": 0,
        "completion_tokens": 0,
        "total_tokens": 53400,
        "prompt_tokens_details": {
            "cached_tokens_details": {}
        },
        "completion_tokens_details": {},
        "output_tokens": 53400
    }
}
```

---

### Key Notes
1. **Multiple picture reference**: Passed`image` The parameter is passed in the reference image URL array, which supports the image-generating function.
2. **文生图**: Not passed on`image` parameters, only based on`prompt` Generate pictures.
3. **Watermark Control**:`watermark: true` When generating images with watermarks.
4. **Response format**: By default, the image URL is returned (`response_format: "url"`), it needs to be downloaded within the validity period.

