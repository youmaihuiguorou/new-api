

# OpenAI video interface document (Doubao-Video)

Call the **OpenAI video generation interface** to generate video content. This document is dedicated to the **ByteDance Doubao** series of video generation models (Wensheng Video, Tusheng Video).

---

## 1. Supported models

### Model list

| Model name| Description| Applicable scenarios|
| :--- | :--- | :--- |
| `doubao-seedance-1-5-pro-251215` | Doubao Video Generator 1.5 Pro| Advanced video generation that supports Vincent video and first and last frame control|

---

### price description

> **Tip**: Assigning keys to **dedicated groups in Wukong (discounts are currently available in the default group)** will usually result in additional discounts.

| Model series| resolution| Price (CNY)| Limited time 40% off discount|
| :--- | :--- | :--- | :--- |
| **doubao-seedance-1-5-pro-251215** | 720P | ~~￥0.346/second~~| **￥0.13** / second|
| | 1080P | ~~￥0.778/second~~| **￥0.29** / second|



## 2. Generate video

### API endpoint

```
POST /v1/videos
```

### Request header

| parameters| Type| Required| Description|
| :--- | :--- | :--- | :--- |
| Authorization | string | Yes| User authentication token (Bearer: sk-xxxx)|
| Content-Type | string | Yes| **application/json** |

### Request parameters (JSON Body)

| parameters| Type| Required| Description|
| :--- | :--- | :--- | :--- |
| **model** | string | Yes| Specify model name:`doubao-seedance-1-5-pro-251215` |
| **prompt** | string | Yes| Video content text prompt words. |
| **images** | array[string] | No| Refer to the picture list to support first frame and last frame control.<br>- Array item 1: URL or Base64 of the first frame image.<br>- Array item 2: URL or Base64 of the last frame image (optional). |
| **aspect_ratio** | string | No| Video ratio. Default is`16:9`。<br>Supported values:`16:9`, `9:16`, `1:1`, `4:3`, `3:4`, `21:9`, `adaptive`(Automatically select the most appropriate aspect ratio based on input) etc. |
| **resolution** | string | No| Video resolution. Default is`720p`。<br>Supported values:`1080p`, `720p`。 |
| **duration** | string/int | No| Video duration (seconds).<br>Range: **Any integer between [4, 12]** (e.g.`5`, `10`）。 |
| **seed** | integer | No| Random seed, used to control the randomness of generated content.<br>Default value:`-1`(randomly).<br>Value range:`[-1, 2^32-1]`。<br>**Note**:<br>1. For the same request, if not specified or set to -1, the result will be random.<br>2. Under the same request, fixing the Seed value will produce similar results (but it is not guaranteed to be completely consistent). |
| **watermark** | boolean | No| Whether to include a watermark.<br>`false`: No watermark (default).<br>`true`: Contains watermark. |

---

### Request example

#### 1. Basic Wensheng Video/Tusheng Video
*Generate a 10-second, 1080p 9:16 video, specifying the first and last frames*

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
--header 'Authorization: Bearer sk-xxx' \
--header 'Content-Type: application/json' \
--data-raw '{
    "prompt": "一只可爱的金毛犬在草地上奔跑，阳光明媚，慢动作镜头",
    "model": "doubao-seedance-1-5-pro-251215",
    "aspect_ratio": "9:16",
    "images": [
        "https://example.com/start_frame.jpg",
        "https://example.com/end_frame.jpg"
    ],
    "resolution": "1080p",
    "duration": "10",
    "seed": -1,
    "watermark": false
}'
```

---

### response format

#### 200 - Submission successful

```json
{
    "id": "cgt-20260124220030-9s4dc"
}
```

> **Note**: The task ID is only saved for 7 days (from the created_at timestamp) and will be automatically cleared after timeout.

---

## 3. Query task status

Video generation usually takes some time, please poll the status via task ID.

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
curl --location --request GET 'https://api.wukong.support/v1/videos/cgt-20260124220030-9s4dc' \
--header 'Authorization: Bearer sk-xxx'
```

---

### response format

#### 200 - Completed

```json
{
    "id": "cgt-20260124220030-9s4dc",
    "object": "video.generation",
    "model": "doubao-seedance-1-5-pro-251215",
    "status": "completed",
    "progress": "100%",
    "created_at": 1769263230,
    "started_at": 1769263245,
    "completed_at": 1769263322,
    "video_url": "https://example.com/original_video.mp4"
}
```

#### Key field description

| Field| Type| Description|
|------|------|------|
| **status** | string | Task status. Common values:<br>`queued`: Queuing<br>`processing`: Processing<br>`completed`: Completed<br>`failed`:failed|
| **video_url** | string | Download link for the final video (only if status is`completed` time to return). |
| **progress** | string | Build progress percentage (e.g. "100%"). |

---

## 4. Detailed explanation of parameters

### 1. Duration
The Doubao model supports flexible duration settings.
- Scope:`4` Arrive`12` Any integer between seconds.
- Recommended value:`5` or`10`。

### 2. Seed
Used to reproduce or control the randomness of results.
- **Randomly generated**: Do not pass this parameter, or pass`-1`。
- **Fixed style**: Pass in a fixed integer (such as`123456`), when the prompt and parameters remain unchanged, the picture composition and movement trajectory will remain relatively stable.

### 3. First and last frame control (Images)
Pass`images` Arrays provide fine control:
- **Vincent videos only**:`images` Leave blank or do not pass.
- **Tusheng video (first frame)**:`images` Pass in 1 image URL.
- **First and last frame control**:`images` Pass in 2 image URLs (the first is the starting image and the second is the ending image), and the model will generate a transition animation between the two images.
