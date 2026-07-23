# **Nano-banana 图像生成 API**

**接口路径**：`POST /v1/images/generations`

**推荐模型**：

`nano-banana`（基于 Gemini-2.5-flash-image-preview 优化）

`nano-banana-pro`（基于 Gemini-3-pro-image-preview 优化）

`nano-banana-2`（基于 Gemini-3.1-flash-image-preview 优化）

**注意：生成图片URL为临时链接（2小时有效），重要作品请保存本地。**

---

### **模型对比**
| 特性                | `gemini-2.5-flash-image-preview` | `nano-banana`                          | `nano-banana-pro`       |
|---------------------|----------------------------------|----------------------------------------|------------------------|
| **类型**            | 官方原生模型                     | 画图优化版                             | 更强更高清版（4K画质）       |
| **支持接口**        | 仅聊天接口                       | 图像生成接口                           | 图像生成接口           |
| **返回格式**        | Base64（可能不返回图片）         | URL 或 Base64                          | URL 或 Base64          |
| **图片比例设置**    | ❌ 不支持                        | ✅ 支持  | ✅ 支持
| **失败扣费**        | ❌ 未说明                        | ✅ 不扣费                              | ✅ 不扣费              |
| **兼容格式**        | -                                | Dalle 格式                            | Dalle 格式             |

---

### **请求参数**
#### **Header**
| 参数名          | 类型   | 必需 | 默认值               | 说明                     |
|----------------|--------|------|----------------------|--------------------------|
| `Authorization`| string | 可选 | `Bearer {{YOUR_API_KEY}}` | API 认证令牌             |

#### **Body (`application/json`)**
| 参数名            | 类型             | 必需 | 说明                                                                 |
|-------------------|------------------|------|----------------------------------------------------------------------|
| `model`           | string           | ✅   | 模型名称（如 `nano-banana` 或 `nano-banana-pro`）                     |
| `prompt`          | string           | ✅   | 图像描述文本                                                         |
| `aspect_ratio`    | enum[string]     | ✅   | 图片比例：<br><br> `auto`，`1:1`, `4:3`, `3:4`, `16:9`, `9:16`, `2:3`, `3:2`, `4:5`, `5:4`, `21:9`|
| `response_format`| string           | ❌   | 返回格式：`url`（默认）或 `b64_json`                                 |
| `image`      | array[string]    | ❌   | 图生图时输入的参考图片 URL  或 图片 Base64 数据列表              |
| `image_size`      | enum[string]    | ❌   |    仅nano-banana-pro、nano-banana-2支持，可选值：1K、2K、4K|
| `search`      | enum[boolean]    | ❌   |    是否开启原生联网功能，仅nano-banana-pro、nano-banana-2支持，可选值：`true`，`false`|


---

### **请求示例**
#### **JSON Body**
```json
{
    "prompt": "cat",
    "model": "nano-banana",
    "aspect_ratio": "16:9"
}
```

#### **cURL 代码**
```bash
curl --location --request POST 'https://api.wukong.support/v1/images/generations' \
--header 'Authorization: Bearer {{YOUR_API_KEY}}' \
--header 'Content-Type: application/json' \
--data-raw '{
    "prompt": "cat",
    "model": "nano-banana",
    "aspect_ratio": "16:9"
}'
```

---

### **响应示例**
#### **成功响应（HTTP 200）**
```json
{
    "data": [
        {
            "url": "https://example.com/generated_image.png"
        }
    ]
}
```
- **格式**：`application/json`
- **返回内容**：包含生成图片的 URL 或 Base64 数据（取决于 `response_format`）。

---

### **关键说明**
1. **优化特性**
   - `nano-banana` 专为图像生成优化，支持比例设置和 Dalle 格式。
   - 失败不扣费，降低使用成本风险。
2. **高清版本**
   - `nano-banana-pro`、`nano-banana-2` 支持输出 4K 画质，适合高分辨率需求场景。
