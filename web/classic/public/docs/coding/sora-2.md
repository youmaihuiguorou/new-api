
# OpenAI 视频接口文档（Sora2 官方格式）


推荐使用 [统一视频格式](/docs/#/coding/sora-2-unify) 

调用 **OpenAI 视频生成接口** 以生成视频内容，支持模型 **Sora**（包括 `sora-2` 与 `sora-2-pro`），也支持兼容的可灵、即梦、Vidu 等实现 OpenAI 视频格式的模型。

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
| prompt | string | 是 | 视频内容文本提示词，如“基于这张图片生成视频” |
| model | string | 否 | 视频生成模型，支持 `sora-2` 和 `sora-2-pro`，默认为 `sora-2` |
| seconds | string | 否 | 视频时长（秒）。默认4秒； 4、8、12（25 仅 `sora-2-pro` 支持） |
| size | string | 否 | 输出分辨率，格式为宽度x高度，默认 `720x1280` |
| input_reference | file/string | 否 | 图片参考输入，可为文件或图片URL（用于指导视频生成） |

#### 分辨率选项说明

| 值 | 名称 | 说明 |
|----|------|------|
| 1280x720 | 720P 横屏 | 通用支持 |
| 720x1280 | 720P 竖屏 | 默认配置 |
| 1792x1024 | 1080P 横屏 | 仅 `sora-2-pro` 支持 |
| 1024x1792 | 1080P 竖屏 | 仅 `sora-2-pro` 支持 |

---

#### 故事板模式

接口支持故事板（Storyboard）功能，可按分镜创建连续视频。使用故事板时，提示词（prompt）必须严格遵循以下格式：

```bash
Shot 1:\nduration: 7.5sec\nScene: 飞机起飞\n\nShot 2:\nduration: 7.5sec\nScene: 飞机降落
```
**格式要求：**
- 每个镜头以 ```Shot N:``` 开头（N 为镜头编号）
- 使用 ```duration: Xsec``` 指定镜头时长
- 使用 ```Scene:``` 描述镜头内容
- 镜头之间用空行分隔

---

### 请求示例

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=sora-2" \
  -F "prompt=A calico cat playing a piano on stage"
```

---

### 响应格式

#### 200 - 成功响应示例

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "status": "queued",
  "progress": 0,
  "created_at": 1712697600,
  "size": "1024x1808",
  "seconds": "8",
  "quality": "standard"
}
```

#### 响应字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| id | string | 视频任务ID |
| object | string | 固定为 `"video"` |
| model | string | 所用模型名称 |
| status | string | 任务状态（`queued` 排队中、`processing` 处理中、`completed` 完成、`failed` 失败） |
| progress | integer | 处理进度（0-100） |
| created_at | integer | 创建时间戳 |
| size | string | 视频分辨率 |
| seconds | string | 视频时长（秒） |
| quality | string | 视频质量（standard / hd） |

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
curl 'https://api.wukong.support/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

---

### 响应格式

#### 200 - 成功响应示例

```json
{
  "id": "video_123",
  "object": "video",
  "model": "sora-2",
  "status": "completed",
  "progress": 100,
  "created_at": 1712697600,
  "completed_at": 1712698000,
  "expires_at": 1712784400,
  "size": "1024x1808",
  "seconds": "8",
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
| status | string | 当前任务状态 |
| progress | integer | 完成百分比 |
| created_at | integer | 创建时间戳 |
| completed_at | integer | 完成时间戳 |
| expires_at | integer | 下载资源过期时间戳 |
| size | string | 视频分辨率 |
| seconds | string | 视频长度（秒） |
| quality | string | 视频质量 |
| remixed_from_video_id | string | 若为混音视频，显示源视频ID |
| error | object | 错误信息（仅在失败时） |
| video_url | string | 视频下载链接，**有效时间2小时左右**（仅在 `status` 为 `completed` 时存在） |

---

## 三、获取视频内容

下载已完成的视频文件。

### API 端点

```
GET /v1/videos/{video_id}/content
```

### 路径参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| video_id | string | 是 | 视频标识符 |

### 查询参数

| 参数 | 类型 | 必填 | 描述 |
|------|------|------|------|
| variant | string | 否 | 下载资源类型，默认 MP4 视频 |

---

### 请求示例

```bash
curl 'https://api.wukong.support/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

#### 响应格式

- 成功：直接返回视频文件流
  Content-Type 为 `video/mp4`

#### 响应头说明

| 字段 | 类型 | 描述 |
|------|------|------|
| Content-Type | string | 视频文件类型，一般为 `video/mp4` |
| Content-Length | string | 视频文件大小（字节） |
| Content-Disposition | string | 文件下载信息（文件名、下载方式等） |

---

## 四、调用时长与生成耗时参考

| 时长（秒） | 预计生成时间 |
|-------------|--------------|
| 10 | 约 1–3 分钟 |
| 15 | 约 +2 分钟 |
| HD 高清模式 | 约 +8 分钟 |

> 仅 `sora-2-pro` 支持 25 秒，设置为 25 秒时 HD 参数无效。

---

## 五、官方审查说明

视频生成将经过至少三个审查阶段：

1. **输入图片审查**：检测是否包含真人或逼真的人像。
2. **提示词内容审查**：过滤暴力、色情、版权、或涉及活着的名人等违规内容。
3. **生成结果审查**：若结果不符合规范，可能在生成过程（接近 90%）时失败。

---

## 六、错误响应

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

此接口统一了 OpenAI 视频生成的调用方式，支持多种模型（`sora-2` / `sora-2-pro`）。
用户可通过提供提示词、参考图像与分辨率参数生成高质量视频。
视频任务可查询、下载、并遵循严格的内容审查机制。