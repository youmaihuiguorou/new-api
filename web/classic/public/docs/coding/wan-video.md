# OpenAI 视频接口文档（通义万相 Wan 2.6）

调用 **OpenAI 视频生成接口** 以生成视频内容，本文档专用于**阿里云通义万相 Wan 2.6** 系列模型（文生视频、图生视频、参考视频生视频）。

---

## 一、支持的模型与计费

### 模型列表

| 模型名称 | 说明 | 适用场景 |
| :--- | :--- | :--- |
| `wan2.6-t2v` | 万相 2.6 文生视频 | 根据文本提示词生成有声视频 |
| `wan2.6-i2v` | 万相 2.6 图生视频 | 图片+文本生成高品质有声视频 |
| `wan2.6-i2v-flash` | 万相 2.6 图生视频 (极速版) | 生成速度快，性价比高 |
| `wan2.6-r2v` | 万相 2.6 视频生视频 (参考视频) | 基于参考视频的角色和动作生成新视频 |

### 价格说明

> **提示**：在 熊猫 中将密钥分配到 **专用分组（目前默认分组即可享受折扣）** 通常会有额外折扣。

| 模型系列 | 分辨率 | 价格 (CNY) | 限时 5 折优惠 |
| :--- | :--- | :--- | :--- |
| **标准版**<br>wan2.6-t2v / i2v / r2v | 720P | ~~￥0.6/秒~~ | **￥0.3** / 秒 |
| | 1080P | ~~￥1.0/秒~~ | **￥0.5** / 秒 |
| **极速版**<br>wan2.6-i2v-flash | 720P | ~~￥0.3/秒~~ | **￥0.15** / 秒 |
| | 1080P | ~~￥0.5/秒~~ | **￥0.25** / 秒 |


---

## 二、生成视频

### API 端点

```
POST /v1/videos
```

### 请求头

| 参数 | 类型 | 必填 | 描述 |
| :--- | :--- | :--- | :--- |
| Authorization | string | 是 | 用户认证令牌（Bearer: sk-xxxx） |
| Content-Type | string | 是 | multipart/form-data |

### 请求参数

| 参数 | 类型 | 必填 | 描述 |
| :--- | :--- | :--- | :--- |
| **model** | string | 是 | 指定模型名称（如 `wan2.6-t2v`） |
| **prompt** | string | 是 | 视频内容文本提示词（中文效果更佳） |
| **seconds** | integer | 否 | 视频时长（秒）。**默认为 5**。<br>`wan2.6-t2v`支持 `5`, `10`, `15`。<br>`wan2.6-r2v` 支持 `10`,`15`。<br>`wan2.6-i2v`、`wan2.6-i2v-flash` 支持 `2`~ `15`。 |
| **size** | string | 否 | 输出分辨率，格式为 `宽*高`。 默认为 720*1280 。<br>支持：`1280*720` (720P), `1920*1080` (1080P) 及其竖屏/方屏变体。<br> 注意：`wan2.6-i2v`、 `wan2.6-i2v-flash` 仅支持传参 `720P` 、`1080P`|
| **metadata** | json | 否 | **核心参数**，用于传递万相特有参数（见下表）。 |

#### Metadata 参数说明 (JSON 字符串)

由于万相模型包含许多非 OpenAI 标准参数，请将以下参数构建为 JSON 字符串传递给 `metadata` 字段。

| 字段 | 类型 | 描述 | 适用模型 |
| :--- | :--- | :--- | :--- |
| **input.img_url** | string | 首帧图像的URL或 Base64 编码数据。<br>图像的宽度和高度范围为[360, 2000]，单位为像素。<br>文件大小：不超过10MB。<br> 传入 Base64 示例值：data:image/png;base64,GDU7MtCZzEbTbmRZ......。（编码字符串过长，仅展示片段）| i2v 系列 |
| **input.audio_url** | string | 输入音频的 URL 地址（用于对口型或配乐）。 | t2v, i2v |
| **input.reference_video_urls** | array[string] | 上传的参考视频文件 URL 数组。用于提取角色形象与音色（如有），以生成符合参考特征的视频。<br>- 最多支持 3 个视频。<br>- 传入多个视频时，按照数组顺序定义视频角色的顺序。即第 1 个 URL 对应 character1，第 2 个对应 character2，以此类推。<br>- 每个参考视频仅包含一个角色（如 character1 为小女孩，character2 为闹钟）。<br>- URL支持 HTTP 或 HTTPS 协议。本地文件可通过上传文件获取临时URL。<br>单个视频要求：<br>- 格式：mp4、mov。<br>- 时长：2～30s。<br>- 文件大小：视频不超过100MB。<br>示例值：["https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/xxx.mp4"]。 | r2v |
| **parameters.prompt_extend** | boolean | 是否开启 Prompt 智能改写（默认 `true`）。 | 所有 |
| **parameters.watermark** | boolean | 是否添加水印（默认 `false`）。 | 所有 |

---

### 请求示例

#### 1. 文生视频 (wan2.6-t2v)
*生成一段 5 秒的 1080P 视频，开启智能改写*

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=wan2.6-t2v" \
  -F "prompt=一只穿着宇航服的猫在月球上漫步，背景是地球，电影质感" \
  -F "seconds=5" \
  -F "size=1920*1080" \
  -F 'metadata={"parameters":{"prompt_extend":true,"watermark":false}}'
```

#### 2. 图生视频 (wan2.6-i2v)
*让图片动起来，且通过 URL 传入图片*

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=wan2.6-i2v" \
  -F "prompt=海浪拍打着沙滩，镜头缓慢推进" \
  -F "seconds=5" \
  -F "size=720P" \
  -F 'metadata={"input":{"img_url":"https://example.com/beach.jpg"}}'
```

#### 3. 视频生视频 (wan2.6-r2v)
*基于参考视频生成新视频*

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=wan2.6-r2v" \
  -F "prompt=将角色变成动漫风格" \
  -F "seconds=5" \
  -F "size=1280*720" \
  -F 'metadata={"input":{"reference_video_urls":["https://example.com/original_video.mp4"]}}'
```

---

### 响应格式

#### 200 - 提交成功

```json
{
  "id": "video_task_123456",
  "object": "video",
  "model": "wan2.6-t2v",
  "status": "processing",
  "created_at": 1712697600,
  "progress": 0
}
```

---

## 三、查询任务状态

阿里云万相视频生成通常需要 1-5 分钟。

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
  "model": "wan2.6-t2v",
  "status": "completed",
  "progress": 100,
  "created_at": 1759938772,
  "completed_at": 1759938900,
  "expires_at": 1759982000,
  "size": "1280x720",
  "seconds": "8",
  "remixed_from_video_id": null,
  "error": null,
  "metadata":{"url":"https://example.com/generated_video.mp4"}
}
```

#### 关键字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| status | string | 若为 `completed` 表示生成成功 |
| metadata.url | string | 视频下载链接，**有效时间24小时**（仅在 `status` 为 `completed` 时存在） |
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

> **注意**：返回的 `url` 有效期通常为 24 小时，请及时保存。

---

## 四、参数与限制详解

### 1. 分辨率 (Size)
万相 2.6 支持多种比例，建议使用以下标准格式：
- **16:9**: `1280*720` (720P), `1920*1080` (1080P)
- **9:16**: `720*1280` (720P), `1080*1920` (1080P)
- **1:1**: `960*960` (720P档), `1440*1440` (1080P档)

### 2. 时长 (Seconds)
- **i2v 模型**: 支持 `2` 到 `15` 任意整数。
- **其他模型**: 仅支持 `5`, `10`, `15` (部分模型不支持 15，建议优先使用 5 或 10)。

### 3. 音频能力
Wan 2.6 全系默认支持生成有声视频。
- 若需**自定义配音**：请在 metadata 中传入 `audio_url`（支持 mp3/wav，3~30s）。

### 4. 错误处理
常见错误码：
- `400`: 参数错误（如分辨率不支持、URL 无法访问）。
- `IPInfringementSuspect`: 内容安全拦截（Prompt 或图片违规）。
- `DataInspectionFailed`: 数据检查失败（通常是图片/视频格式问题）。