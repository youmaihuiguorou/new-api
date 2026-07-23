# OpenAI video interface document (Veo3 series official format)

Call the **OpenAI format video generation interface** to generate video content. This document is dedicated to the **Veo3** series models (including`veo3`, `veo3.1` etc.). The interface adopts asynchronous task mode and is fully compatible with the OpenAI video interface standard.

---

## 1. Generate video

### API endpoint

```
POST /v1/videos
```

### Request header

| parameters| Type| Required| Description|
|------|------|------|------|
| Authorization | string | Yes| User authentication token (Bearer: sk-xxxx)|
| Content-Type | string | Yes| multipart/form-data |

---

### Request parameters

| parameters| Type| Required| Description|
|------|------|------|------|
| prompt | string | Yes| Video content text **English prompt words**, such as "A mythical flying elephant soars across the sky"|
| model | string | No| Video generation model, default is`veo_3_1-fast`(See model list below for details)|
| size | string | No| Aspect ratio setting, the format is`宽x高`(such as`16x9`, `1280x720`）。<br>The system automatically determines: width > height for horizontal screen, width<High is vertical screen. |
| input_reference | file/string | No| Reference image input supports file upload or URL. Supports multiple uploads (for first and last frames). |
| seconds | string | No| **Customization is not supported**. The Veo3.1 series currently generates a fixed **8 seconds** video. |

#### Supported model list

| Model name| Description| Image input support|
|----------|------|--------------|
| `veo_3_1-fast` | **Default model**, veo3.1 fast mode| First frame + last frame (uploaded in order)|
| `veo_3_1` | Professional version, higher quality| First frame + last frame (uploaded in order)|
| `veo_3_1-fast-4K` | 4K version| First frame + last frame (uploaded in order)|
| `veo_3_1-4K` | 4K version| First frame + last frame (uploaded in order)|

#### Picture control instructions

Pass`input_reference` Parameter passing picture (`multipart/form-data` This field can be passed multiple times):

**First and last frame control** (applicable to non-components models):
* 1st`input_reference`: **First Frame**
* 2nd`input_reference`: **Last frame**


---

### Request example

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

### response format

#### 200 - Example of successful response

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

#### Response field description

| Field| Type| Description|
|------|------|------|
| id | string | Video task ID, used for subsequent queries|
| object | string | fixed to`"video"` |
| model | string | Model name used|
| status | string | task status (`queued` Queuing,`processing` Processing,`completed` completed,`failed` failed)|
| created_at | integer | Create timestamp|
| size | string | final video resolution|
| seconds | string | Video duration (fixed at 8)|

---

## 2. Query video tasks

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

#### Key field description

| Field| Type| Description|
|------|------|------|
| status | string | If`completed` Indicates successful generation|
| video_url | string | Video download link, **valid for about 2 hours** (only in`status` for`completed` exist)|
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

## 4. Call restrictions and instructions

### 1. Duration limit
Veo3 series models currently only support generating **8 seconds** video, the request parameter`seconds` Setting it to any other value will be ignored or result in an error.

### 2. resolution logic
The API does not force exact pixel dimensions (such as 1024x768), but instead`size` Parameters to determine aspect ratio:
*   If Width > Height: Generate **Landscape** video.
*   If wide< High: Generate **Portrait** video.

---

## 5. Error response

| status code| Type| Description|
|--------|------|------|
| 400 | invalid_request_error | Parameter errors (such as missing prompt)|
| 401 | authentication_error | API Key is invalid|
| 500 | server_error | Upstream service exception or generation failure|

Example:

```json
{
  "error": {
    "message": "Invalid model specified",
    "type": "invalid_request_error",
    "code": "model_not_found"
  }
}
```