### 即梦（seedream） 绘图

---

#### **基本信息**
- **接口名称**：即梦绘图
- **请求方法**：`POST`
- **请求路径**：`/v1/images/generations`
- **特性**：支持多图参考

---

#### **请求参数**
##### **Header 参数**
| 参数名         | 类型     | 必需 | 默认值                  | 说明                     |
|----------------|----------|------|-------------------------|--------------------------|
| Authorization  | string   | 必须 | `Bearer {{YOUR_API_KEY}}` | API 认证令牌             |

##### **Body 参数（`application/json`）**
| 参数名                      | 类型            | 必需 | 说明                                                                 |
|-----------------------------|-----------------|------|----------------------------------------------------------------------|
| `model`                     | string          | 必需 | 模型名称（示例：`doubao-seedream-4-5-251128`、`doubao-seedream-5-0-260128`）                      |
| `prompt`                    | string          | 必需 | 图像描述文本                                                         |
| `image`                     | array[string]   | 可选 | 参考图片 URL 数组（不带此参数则为文生图）                            |
| `response_format`           | string          | 可选 | 响应格式（示例：`url`）                                              |
| `size`                      | string          | 可选 | 图片尺寸（示例：`2K`、`4k`）`doubao-seedream-5-0-260128` 仅支持2k                                              |
| `stream`                    | boolean         | 可选 | 是否流式传输                                                         |
| `watermark`                 | boolean         | 可选 | 是否添加水印                                                         |
| `output_format`                 | string         | 可选 | 指定生成图像的文件格式，可选值：`png`、`jpeg` 仅`doubao-seedream-5-0-260128`支持                                                         |
---

#### **请求示例**
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

#### **请求示例代码（cURL）**
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

#### **响应**
##### **成功响应（200）**
- **格式**：`application/json`
- **响应体结构**：
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

##### **响应示例**
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

### 关键说明
1. **多图参考**：通过 `image` 参数传入参考图片 URL 数组，支持图生图功能。
2. **文生图**：不传 `image` 参数时，仅根据 `prompt` 生成图片。
3. **水印控制**：`watermark: true` 时生成图片带水印。
4. **响应格式**：默认返回图片 URL（`response_format: "url"`），需在有效期内下载。

