# OpenAI video interface document (Tongyi Wan 2.6)

Call the **OpenAI video generation interface** to generate video content. This document is dedicated to the **Alibaba Cloud Tongyi Wanxiang Wan 2.6** series of models (Wen Sheng Video, Tu Sheng Video, Reference Video Sheng Video).

---

## 1. Supported models and billing

### Model list

| Model name| Description| Applicable scenarios|
| :--- | :--- | :--- |
| `wan2.6-t2v` | Wanxiang 2.6 Vincent Video| Generate video with audio based on text prompt words|
| `wan2.6-i2v` | Wanxiang 2.6 Tusheng Video| Picture + text to generate high-quality video with sound|
| `wan2.6-i2v-flash` | Wanxiang 2.6 Tusheng Video (Extreme Version)| Fast generation and high cost performance|
| `wan2.6-r2v` | Wanxiang 2.6 video raw video (reference video)| Generate new videos based on characters and actions from reference videos|

### price description

> **Tip**: Assigning keys to **dedicated groups in Wukong (discounts are currently available in the default group)** will usually result in additional discounts.

| Model series| resolution| Price (CNY)| Limited time 50% off discount|
| :--- | :--- | :--- | :--- |
| **Standard Edition**<br>wan2.6-t2v / i2v / r2v | 720P | ~~￥0.6/second~~| **￥0.3** / second|
| | 1080P | ~~￥1.0/second~~| **￥0.5** / second|
| **Speed version**<br>wan2.6-i2v-flash | 720P | ~~￥0.3/second~~| **￥0.15** / second|
| | 1080P | ~~￥0.5/second~~| **￥0.25** / second|


---

## 2. Generate video

### API endpoint

```
POST /v1/videos
```

### Request header

| parameters| Type| Required| Description|
| :--- | :--- | :--- | :--- |
| Authorization | string | Yes| User authentication token (Bearer: sk-xxxx)|
| Content-Type | string | Yes| multipart/form-data |

### Request parameters

| parameters| Type| Required| Description|
| :--- | :--- | :--- | :--- |
| **model** | string | Yes| Specify the model name (e.g.`wan2.6-t2v`） |
| **prompt** | string | Yes| Video content text prompt words (Chinese is better)|
| **seconds** | integer | No| Video duration (seconds). **Default is 5**.<br>`wan2.6-t2v`support`5`, `10`, `15`。<br>`wan2.6-r2v` support`10`,`15`。<br>`wan2.6-i2v`、`wan2.6-i2v-flash` support`2`~ `15`。 |
| **size** | string | No| Output resolution, format is`宽*高`. The default is 720*1280.<br>Support:`1280*720` (720P), `1920*1080` (1080P) and its portrait/square variants.<br> Note:`wan2.6-i2v`、 `wan2.6-i2v-flash` Only supports parameter passing`720P` 、`1080P`|
| **metadata** | json | No| **Core parameters** are used to pass Wanxiang-specific parameters (see the table below). |

#### Metadata parameter description (JSON string)

Since the Wanxiang model contains many non-OpenAI standard parameters, please construct the following parameters as JSON strings and pass them to`metadata` field.

| Field| Type| Description| Applicable model|
| :--- | :--- | :--- | :--- |
| **input.img_url** | string | The URL or Base64 encoded data of the first frame image.<br>The width and height of the image range from[360, 2000], units are pixels.<br>File size: no more than 10MB.<br> Pass in the Base64 example value: data:image/png;base64,GDU7MtCZzEbTbmRZ…. (The encoding string is too long, only fragments are shown)| i2v series|
| **input.audio_url** | string | Enter the URL address of the audio (for lip-sync or soundtrack). | t2v, i2v |
| **input.reference_video_urls** | array[string] | Array of uploaded reference video file URLs. Used to extract the character's image and timbre (if any) to generate a video that conforms to the reference characteristics.<br>- Supports up to 3 videos.<br>- When multiple videos are passed in, the order of the video characters is defined according to the order of the array. That is, the first URL corresponds to character1, the second URL corresponds to character2, and so on.<br>- Each reference video contains only one character (e.g. character1 is the little girl, character2 is the alarm clock).<br>- URL supports HTTP or HTTPS protocol. Local files can obtain temporary URLs by uploading files.<br>Single video requirements:<br>- Format: mp4, mov.<br>- Duration: 2~30s.<br>- File size: Video does not exceed 100MB.<br>Example values:["https://help-static-aliyun-doc.aliyuncs.com/file-manage-files/xxx.mp4"]。 | r2v |
| **parameters.prompt_extend** | boolean | Whether to enable prompt intelligent rewriting (default`true`）。 | all|
| **parameters.watermark** | boolean | Whether to add a watermark (default`false`）。 | all|

---

### Request example

#### 1. Vincent Video (wan2.6-t2v)
*Generate a 5-second 1080P video and turn on smart rewriting*

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=wan2.6-t2v" \
  -F "prompt=一只穿着宇航服的猫在月球上漫步，背景是地球，电影质感" \
  -F "seconds=5" \
  -F "size=1920*1080" \
  -F 'metadata={"parameters":{"prompt_extend":true,"watermark":false}}'
```

#### 2. Tusheng Video (wan2.6-i2v)
*Make the picture animate and pass in the picture through the URL*

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=wan2.6-i2v" \
  -F "prompt=海浪拍打着沙滩，镜头缓慢推进" \
  -F "seconds=5" \
  -F "size=720P" \
  -F 'metadata={"input":{"img_url":"https://example.com/beach.jpg"}}'
```

#### 3. Video Health Video (wan2.6-r2v)
*Generate new video based on reference video*

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

### response format

#### 200 - Submission successful

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

## 3. Query task status

Alibaba Cloud Wanxiang video generation usually takes 1-5 minutes.

Query the video generation status and results based on the task ID.

### API endpoint

```
GET /v1/videos/{video_id}
```

### path parameters

| parameters| Type| Required| Description|
|------|------|------|------|
| video_id | string | Yes| generated interface returns`id` |

---

### Request example

```bash
curl 'https://api.wukong.support/v1/videos/video_68e688d4950481918ec389280c2f78140fcb904657674466' \
  -H "Authorization: Bearer sk-xxx"
```

---

### response format

#### 200 - Example of successful response

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

#### Key field description

| Field| Type| Description|
|------|------|------|
| status | string | If`completed` Indicates successful generation|
| metadata.url | string | Video download link, **valid for 24 hours** (only in`status` for`completed` exist)|
| error | object | In case of failure, error details are included here|

---

## 3. Obtain video content

Directly download the completed video file stream.

### API endpoint

```
GET /v1/videos/{video_id}/content
```

### Request example

```bash
curl 'https://api.wukong.support/v1/videos/video_68e688d4950481918ec389280c2f78140fcb904657674466/content' \
  -H "Authorization: Bearer sk-xxx" \
  -o "veo_output.mp4"
```

---

> **Note**: Returned`url` The validity period is usually 24 hours, please save it in time.

---

## 4. Detailed explanation of parameters and restrictions

### 1. Resolution (Size)
Wanxiang 2.6 supports multiple ratios, and it is recommended to use the following standard formats:
- **16:9**: `1280*720` (720P), `1920*1080` (1080P)
- **9:16**: `720*1280` (720P), `1080*1920` (1080P)
- **1:1**: `960*960` (720P file),`1440*1440` (1080P file)

### 2. Duration (Seconds)
- **i2v model**: supported`2` Arrive`15` Any integer.
- **Other models**: only supported`5`, `10`, `15` (Some models do not support 15, it is recommended to use 5 or 10 first).

### 3. audio capabilities
Wan 2.6 supports generating videos with sound by default for all systems.
- If you need **custom dubbing**: please pass it in metadata`audio_url`(Supports mp3/wav, 3~30s).

### 4. Error handling
Common error codes:
- `400`: Parameter error (such as resolution not supported, URL inaccessible).
- `IPInfringementSuspect`: Content security blocking (Prompt or image violation).
- `DataInspectionFailed`: Data check failed (usually image/video format issue).