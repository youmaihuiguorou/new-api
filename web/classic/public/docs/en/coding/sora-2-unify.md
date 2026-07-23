# OpenAI video interface document (Sora2 unified video format)

Call **OpenAI video generation interface** to generate video content, support model **Sora** (including`sora-2-all`), and also supports compatible Keling, Jimeng, Vidu and other models that implement the OpenAI video format.

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
| Content-Type | string | Yes| application/json |

---

### Request parameters

| parameters| Type| Required| Description|
|------|------|------|------|
| model | string | Yes| Video generation models such as`sora-2-all` |
| prompt | string | Yes| Video content text prompt words|
| images | array | No| Image reference input array, supports URL or Base64, only supports one image as the first frame|
| duration | integer | No| Video duration (seconds), currently fixed at`10` |
| aspect_ratio | string | No| Video aspect ratio, supported`16:9`(horizontal screen),`9:16`(vertical screen)|

---

### Request example

**Plain text generation:**

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

**Tusheng video (first frame reference):**

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

### response format

#### 200 - Submission successful

```json
{
    "id": "cgt-20260124220030-9s4dc"
}
```

#### Response field description

| Field| Type| Description|
|------|------|------|
| id | string | Video task ID, used for subsequent query of task status|

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
| video_id | string | Yes| Video task identifier|

---

### Request example

```bash
curl 'https://api.wukong.support/v1/videos/cgt-20260124220030-9s4dc' \
  -H "Authorization: Bearer sk-xxxx"
```

---

### response format

#### 200 - Example of successful response

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

#### Field description

| Field| Type| Description|
|------|------|------|
| id | string | Video task unique identifier|
| object | string | fixed to`"video"` |
| model | string | model name to use|
| status | string | Current task status (`queued` Queuing,`processing` Processing,`completed` completed,`failed` failed)|
| progress | integer | Complete percentage (0-100)|
| created_at | integer | Create timestamp|
| completed_at | integer | completion timestamp|
| expires_at | integer | Download resource expiration timestamp|
| size | string | Video resolution|
| seconds | string | Video length (seconds)|
| quality | string | Video quality|
| remixed_from_video_id | string | If it is a mixed video, the source video ID is displayed.|
| error | object | Error message (only on failure)|
| video_url | string | Video download link (only has value when completed)|

---

## 3. Calling time and generation time-consuming reference

| Duration (seconds)| Estimated build time|
|-------------|--------------|
| 10 | about 1–3 minutes|

---

## 4. Official review instructions

Video generation will go through at least three review stages:

1. **Enter Image Review**: Detects whether it contains real people or realistic portraits.
2. **Prompt word content review**: Filter illegal content such as violence, pornography, copyright, or involving living celebrities.
3. **Build Result Review**: The build process may fail (nearly 90% of the time) if the results do not meet specifications.

---

## 5. Error response

| status code| Type| Examples and explanations|
|--------|------|------------|
| 400 | invalid_request_error | Parameter errors, such as missing required fields|
| 401 | authentication_error | Unauthorized, invalid API key|
| 403 | permission_error | No permission to perform this operation|
| 429 | rate_limit_error | Current limiting threshold reached, please try again later.|
| 500 | server_error | Server internal error|

Example:

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

✅ **Summary**

| Function| endpoint| method|
|------|------|------|
| Generate video| `/v1/videos` | POST |
| Query tasks| `/v1/videos/{video_id}` | GET |

This interface unifies the calling method of video generation and uses JSON format request. Users can generate videos by providing prompt words, reference images (first frame) and aspect ratio parameters, and query the generation status and download links through task IDs.