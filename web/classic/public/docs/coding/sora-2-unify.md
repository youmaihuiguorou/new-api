# OpenAI 视频接口文档（Sora2 统一视频格式）

调用 **OpenAI 视频生成接口** 以生成视频内容，支持模型 **Sora**（包括 `sora-2-all`），也支持兼容的可灵、即梦、Vidu 等实现 OpenAI 视频格式的模型。

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
| Content-Type | string | 是 | application/json |

---

### 请求参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| model | string | 是 | 视频生成模型，如 `sora-2-all` |
| prompt | string | 是 | 视频内容文本提示词 |
| images | array | 否 | 图片参考输入数组，支持 URL 或 Base64，仅支持一张图作为首帧 |
| duration | integer | 否 | 视频时长（秒），目前固定为 `10` |
| aspect_ratio | string | 否 | 视频宽高比，支持 `16:9`（横屏）、`9:16`（竖屏） |

---

### 请求示例

**纯文本生成：**

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "sora-2-all",
    "prompt": "A calico cat playing a piano on stage",
    "duration": 10,
    "aspect_ratio": "16:9"
  }'
```

**图生视频（首帧参考）：**

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "sora-2-all",
    "prompt": "基于这张图片生成视频，画面中的人物开始走动",
    "images": ["https://example.com/image.jpg"],
    "duration": 10,
    "aspect_ratio": "9:16"
  }'
```

---

### 响应格式

#### 200 - 提交成功

```json
{
    "id": "cgt-20260124220030-9s4dc"
}
```

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务ID，用于后续查询任务状态 |

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
| video_id | string | 是 | 视频任务标识符 |

---

### 请求示例

```bash
curl 'https://api.wukong.support/v1/videos/cgt-20260124220030-9s4dc' \
  -H "Authorization: Bearer sk-xxxx"
```

---

### 响应格式

#### 200 - 成功响应示例

```json
{
  "id": "cgt-20260124220030-9s4dc",
  "object": "video",
  "model": "sora-2-all",
  "status": "completed",
  "progress": 100,
  "created_at": 1712697600,
  "completed_at": 1712698000,
  "expires_at": 1712784400,
  "size": "1024x1808",
  "seconds": "10",
  "quality": "standard",
  "remixed_from_video_id": null,
  "error": null,
  "video_url": "https://example.com/video.mp4"
}
```

#### 字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务唯一标识符 |
| object | string | 固定为 `"video"` |
| model | string | 使用的模型名称 |
| status | string | 当前任务状态（`queued` 排队中、`processing` 处理中、`completed` 完成、`failed` 失败） |
| progress | integer | 完成百分比（0-100） |
| created_at | integer | 创建时间戳 |
| completed_at | integer | 完成时间戳 |
| expires_at | integer | 下载资源过期时间戳 |
| size | string | 视频分辨率 |
| seconds | string | 视频长度（秒） |
| quality | string | 视频质量 |
| remixed_from_video_id | string | 若为混音视频，显示源视频ID |
| error | object | 错误信息（仅在失败时） |
| video_url | string | 视频下载链接（仅完成时有值） |

---

## 三、调用时长与生成耗时参考

| 时长（秒） | 预计生成时间 |
|-------------|--------------|
| 10 | 约 1–3 分钟 |

---

## 四、官方审查说明

视频生成将经过至少三个审查阶段：

1. **输入图片审查**：检测是否包含真人或逼真的人像。
2. **提示词内容审查**：过滤暴力、色情、版权、或涉及活着的名人等违规内容。
3. **生成结果审查**：若结果不符合规范，可能在生成过程（接近 90%）时失败。

---

## 五、错误响应

| 状态码 | 类型 | 示例与说明 |
|--------|------|------------|
| 400 | invalid_request_error | 参数错误，如缺少必要字段 |
| 401 | authentication_error | 未授权，API密钥无效 |
| 403 | permission_error | 无权限执行该操作 |
| 429 | rate_limit_error | 达到限流阈值，请稍后重试 |
| 500 | server_error | 服务器内部错误 |

示例：

```json
{
  "error": {
    "message": "Invalid request parameters",
    "type": "invalid_request_error",
    "code": "invalid_parameter"
  }
}
```

---

✅ **总结**

| 功能 | 端点 | 方法 |
|------|------|------|
| 生成视频 | `/v1/videos` | POST |
| 查询任务 | `/v1/videos/{video_id}` | GET |

此接口统一了视频生成的调用方式，使用 JSON 格式请求。用户可通过提供提示词、参考图像（首帧）与宽高比参数生成视频，并通过任务ID查询生成状态与下载链接。