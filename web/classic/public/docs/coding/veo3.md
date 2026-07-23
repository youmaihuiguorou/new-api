# OpenAI 视频接口文档（Veo3 系列官方格式）

调用 **OpenAI 格式视频生成接口** 以生成视频内容，本文档专用于 **Veo3** 系列模型（包括 `veo3`, `veo3.1` 等）。该接口采用异步任务模式，完全兼容 OpenAI 视频接口标准。

---

## 一、生成视频

### API 端点

```
POST /v1/videos
```

### 请求头

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| Authorization | string | 是 | 用户认证令牌（Bearer: sk-xxxx） |
| Content-Type | string | 是 | multipart/form-data |

---

### 请求参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| prompt | string | 是 | 视频内容文本**英文提示词**，如“A mythical flying elephant soars across the sky” |
| model | string | 否 | 视频生成模型，默认为 `veo_3_1-fast`（详情见下方模型列表） |
| size | string | 否 | 宽高比设定，格式为 `宽x高`（如 `16x9`, `1280x720`）。<br>系统自动判定：宽>高为横屏，宽<高为竖屏。 |
| input_reference | file/string | 否 | 参考图输入，支持文件上传或 URL。支持多张上传（用于首尾帧）。 |
| seconds | string | 否 | **不支持自定义**。Veo3.1 系列目前固定生成 **8秒** 视频。 |

#### 支持的模型列表

| 模型名称 | 说明 | 图片输入支持 |
|----------|------|--------------|
| `veo_3_1-fast` | **默认模型**，veo3.1快速 模式 | 首帧 + 尾帧（按顺序上传） |
| `veo_3_1` | 专业版，质量更高 | 首帧 + 尾帧（按顺序上传） |
| `veo_3_1-fast-4K` | 4K版本 | 首帧 + 尾帧（按顺序上传） |
| `veo_3_1-4K` | 4K版本 | 首帧 + 尾帧（按顺序上传） |

#### 图片控制说明

通过 `input_reference` 参数传递图片（`multipart/form-data` 中可多次传递该字段）：

**首尾帧控制**（适用于非 components 模型）：
* 第 1 个 `input_reference`: **首帧**
* 第 2 个 `input_reference`: **尾帧**


---

### 请求示例

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxx" \
  -F "model=veo_3_1-fast" \
  -F "prompt=A whimsical flying elephant soaring over a vibrant candy-colored cityscape" \
  -F "size=16x9" \
  -F "input_reference=@first_frame.png" \
  -F "input_reference=@last_frame.png"
```

---

### 响应格式

#### 200 - 成功响应示例

```json
{
  "id": "video_68e688d4950481918ec389280c2f78140fcb904657674466",
  "object": "video",
  "model": "veo_3_1-fast",
  "status": "queued",
  "progress": 0,
  "created_at": 1759938772,
  "size": "1280x720",
  "seconds": "8",
  "quality": "standard"
}
```

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务ID，用于后续查询 |
| object | string | 固定为 `"video"` |
| model | string | 所用模型名称 |
| status | string | 任务状态（`queued` 排队中、`processing` 处理中、`completed` 完成、`failed` 失败） |
| created_at | integer | 创建时间戳 |
| size | string | 最终视频分辨率 |
| seconds | string | 视频时长（固定为 8） |

---

## 二、查询视频任务

根据任务ID查询视频生成状态与结果。

### API 端点

```
GET /v1/videos/{video_id}
```

### 路径参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| video_id | string | 是 | 生成接口返回的 `id` |

---

### 请求示例

```bash
curl 'https://api.wukong.support/v1/videos/video_68e688d4950481918ec389280c2f78140fcb904657674466' \
  -H "Authorization: Bearer sk-xxx"
```

---

### 响应格式

#### 200 - 成功响应示例

```json
{
  "id": "video_68e688d4950481918ec389280c2f78140fcb904657674466",
  "object": "video",
  "model": "veo3.1",
  "status": "completed",
  "progress": 100,
  "created_at": 1759938772,
  "completed_at": 1759938900,
  "expires_at": 1759982000,
  "size": "1280x720",
  "seconds": "8",
  "remixed_from_video_id": null,
  "error": null,
  "video_url": "https://example.com/generated_video.mp4"
}
```

#### 关键字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| status | string | 若为 `completed` 表示生成成功 |
| video_url | string | 视频下载链接，**有效时间2小时左右**（仅在 `status` 为 `completed` 时存在） |
| error | object | 若失败，此处包含错误详情 |

---

## 三、获取视频内容

直接下载已完成的视频文件流。

### API 端点

```
GET /v1/videos/{video_id}/content
```

### 请求示例

```bash
curl 'https://api.wukong.support/v1/videos/video_68e688d4950481918ec389280c2f78140fcb904657674466/content' \
  -H "Authorization: Bearer sk-xxx" \
  -o "veo_output.mp4"
```

---

## 四、调用限制与说明

### 1. 时长限制
Veo3 系列模型目前仅支持生成 **8 秒** 视频，请求参数中的 `seconds` 若设置为其他数值将被忽略或导致错误。

### 2. 分辨率逻辑
API 不会强制生成精确的像素尺寸（如 1024x768），而是根据 `size` 参数判断宽高比：
*   若 宽 > 高：生成 **横屏 (Landscape)** 视频。
*   若 宽 < 高：生成 **竖屏 (Portrait)** 视频。

---

## 五、错误响应

| 状态码 | 类型 | 说明 |
|--------|------|------|
| 400 | invalid_request_error | 参数错误（如缺少 prompt） |
| 401 | authentication_error | API Key 无效 |
| 500 | server_error | 上游服务异常或生成失败 |

示例：

```json
{
  "error": {
    "message": "Invalid model specified",
    "type": "invalid_request_error",
    "code": "model_not_found"
  }
}
```