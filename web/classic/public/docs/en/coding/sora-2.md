
# OpenAI video interface document (Sora2 official format)


Recommended[Unified video format](/docs/#/coding/sora-2-unify) 

Call **OpenAI video generation interface** to generate video content, support model **Sora** (including`sora-2` with`sora-2-pro`), and also supports compatible Keling, Jimeng, Vidu and other models that implement the OpenAI video format.

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
| prompt | string | Yes| Video content text prompt words, such as "Generate a video based on this picture"|
| model | string | No| Video generation model, support`sora-2` and`sora-2-pro`, the default is`sora-2` |
| seconds | string | No| Video duration (seconds). Default 4 seconds; 4, 8, 12 (25 only`sora-2-pro` support)|
| size | string | No| Output resolution, format is width x height, default`720x1280` |
| input_reference | file/string | No| Image reference input, which can be a file or image URL (used to guide video generation)|

#### Resolution option description

| value| Name| Description|
|----|------|------|
| 1280x720 | 720P horizontal screen| Universal support|
| 720x1280 | 720P vertical screen| Default configuration|
| 1792x1024 | 1080P landscape screen| only`sora-2-pro` support|
| 1024x1792 | 1080P vertical screen| only`sora-2-pro` support|

---

#### storyboard mode

The interface supports the storyboard function, which can create continuous videos based on storyboards. When using storyboards, prompts must strictly follow the following format:

```bash
Shot 1:\nduration: 7.5sec\nScene: 飞机起飞\n\nShot 2:\nduration: 7.5sec\nScene: 飞机降落
```
**Format requirements:**
- Each shot starts with```Shot N:``` Beginning (N is the shot number)
- Use```duration: Xsec``` Specify shot duration
- Use```Scene:``` Describe the contents of the shot
- Separate shots with blank lines

---

### Request example

```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
  -H "Authorization: Bearer sk-xxxx" \
  -F "model=sora-2" \
  -F "prompt=A calico cat playing a piano on stage"
```

---

### response format

#### 200 - Example of successful response

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

#### Response field description

| Field| Type| Description|
|------|------|------|
| id | string | Video task ID|
| object | string | fixed to`"video"` |
| model | string | Model name used|
| status | string | task status (`queued` Queuing,`processing` Processing,`completed` completed,`failed` failed)|
| progress | integer | Processing progress (0-100)|
| created_at | integer | Create timestamp|
| size | string | Video resolution|
| seconds | string | Video duration (seconds)|
| quality | string | Video quality (standard/hd)|

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
curl 'https://api.wukong.support/v1/videos/video_123' \
  -H "Authorization: Bearer sk-xxxx"
```

---

### response format

#### 200 - Example of successful response

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

#### Field description

| Field| Type| Description|
|------|------|------|
| id | string | Video task unique identifier|
| object | string | fixed to`"video"` |
| model | string | model name to use|
| status | string | Current task status|
| progress | integer | percent complete|
| created_at | integer | Create timestamp|
| completed_at | integer | completion timestamp|
| expires_at | integer | Download resource expiration timestamp|
| size | string | Video resolution|
| seconds | string | Video length (seconds)|
| quality | string | Video quality|
| remixed_from_video_id | string | If it is a mixed video, the source video ID is displayed.|
| error | object | Error message (only on failure)|
| video_url | string | Video download link, **valid for about 2 hours** (only in`status` for`completed` exist)|

---

## 3. Obtain video content

Download the completed video file.

### API endpoint

```
GET /v1/videos/{video_id}/content
```

### path parameters

| parameters| Type| Required| Description|
|------|------|------|------|
| video_id | string | Yes| video identifier|

### query parameters

| parameters| Type| Required| Description|
|------|------|------|------|
| variant | string | No| Download resource type, default MP4 video|

---

### Request example

```bash
curl 'https://api.wukong.support/v1/videos/video_123/content' \
  -H "Authorization: Bearer sk-xxxx" \
  -o "video.mp4"
```

#### response format

- Success: Return the video file stream directly
  Content-Type is`video/mp4`

#### Response header description

| Field| Type| Description|
|------|------|------|
| Content-Type | string | Video file type, usually`video/mp4` |
| Content-Length | string | Video file size (bytes)|
| Content-Disposition | string | File download information (file name, download method, etc.)|

---

## 4. Calling time and generation time-consuming reference

| Duration (seconds)| Estimated build time|
|-------------|--------------|
| 10 | about 1–3 minutes|
| 15 | approx. +2 minutes|
| HD high definition mode| approx. +8 minutes|

> only`sora-2-pro` Supports 25 seconds. When set to 25 seconds, the HD parameters are invalid.

---

## 5. Official review instructions

Video generation will go through at least three review stages:

1. **Enter Image Review**: Detects whether it contains real people or realistic portraits.
2. **Prompt word content review**: Filter illegal content such as violence, pornography, copyright, or involving living celebrities.
3. **Build Result Review**: The build process may fail (nearly 90% of the time) if the results do not meet specifications.

---

## 6. Error response

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

This interface unifies the calling method of OpenAI video generation and supports multiple models (`sora-2` / `sora-2-pro`）。
Users can generate high-quality videos by providing prompt words, reference images, and resolution parameters.
Video tasks can be queried, downloaded, and follow strict content review mechanisms.