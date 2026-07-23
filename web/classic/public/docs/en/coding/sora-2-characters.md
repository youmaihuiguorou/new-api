# Sora-2 role creation and extraction API documentation

## 1. Overview
This module contains two steps:
1.  **Submit task**: Upload the video URL and timestamp, and submit the character extraction task.
2.  **Query results**: Poll the task status and obtain the generated role ID (`Username`)。

---

## 2. Interface details

### 2.1 Create role extraction task
Submit video clips to extract character features.

- **Interface address**:`https://api.wukong.support/v1/videos`
- **Request method**:`POST`
- **Content-Type**: `application/json`

#### Request headers
| Parameter name| value| Description|
| :--- | :--- | :--- |
| Authorization | `Bearer sk-xxx` | Your API Key|
| Content-Type | `application/json` | Data format|

#### Request parameters (Body)
| Parameter name| Type| Required| Description| Limitations and Examples|
| :--- | :--- | :--- | :--- | :--- |
| `model` | string | Yes| Model name| The fixed value is`"sora-2-characters"` |
| `url` | string | Yes| Video address| Contains the character's video URL.<br>⚠️ **Note: Live videos are not supported**|
| `timestamps` | string | Yes| The time frame in which the character appears| Format: "Start second, end second" (integer)<br>For example:`"1,4"`<br>**Restrictions:**<br>1. Minimum time difference: 1 second<br>2. Maximum time difference: 3 seconds|

#### Request example
```bash
curl --location --request POST 'https://api.wukong.support/v1/videos' \
--header 'Authorization: Bearer sk-xxx' \
--header 'Content-Type: application/json' \
--data-raw '{
    "model": "sora-2-characters",
    "timestamps": "1,4",
    "url": "https://tempfile.aiquickdraw.com/f/7d0068dff1a8ef1b7930bf883c570854/08a1e6f8-b365-488e-afcc-369f632f101.mp4"
}'
```

#### Response example
```json
{
    "id": "e9d9ed9d-804c-4aa3-bf2c-998660145030",
    "object": "video.generation",
    "status": "pending"
}
```

---

### 2.2 Query task results (polling)
Query the progress and results of role extraction by task ID.

- **Interface address**:`https://api.wukong.support/v1/videos/{id}`
- **Request method**:`GET`

#### Path parameters (Path)
| Parameter name| Description|
| :--- | :--- |
| `id` | Obtained in the first step response`id` (Task ID)|

#### Request example
```bash
curl --location --request GET 'https://api.wukong.support/v1/videos/e9d9ed9d-804c-4aa3-bf2c-998660145030' \
--header 'Authorization: Bearer sk-xxx'
```

#### Response example (success status)
only if`"status": "completed"` , the mission is considered successful.

```json
{
    "id": "e9d9ed9d-804c-4aa3-bf2c-998660145030",
    "model": "sora-2-characters",
    "object": "video.generation",
    "status": "completed",
    "progress": "100%",
    "created_at": 1770441825,
    "started_at": 1770441857,
    "completed_at": 1770441893,
    "data": {
        "characters": [
            {
                "id": "gwennieqf.fchowinter" 
            }
        ]
    }
}
```

#### Response field description
- `status`: Task status.`pending` (in queue),`processing` (processing),`completed` (Complete),`failed` (failed).
- `data.characters[0].id`: **Generated role ID (Username)**. This ID will be used when generating videos later.

---

## 3. Role usage guide

After obtaining the role ID, you can call the role in the Prompt of the Sora video generation task.

### Call syntax
Use`@` symbol plus the role ID, and **must leave a space** after the ID.

**Format:**
`@角色ID 动作描述`

### Example
Assume that the obtained role ID is:
- Role 1:`gwennieqf.fchowinter`
- Role 2:`testuser.demo`

**Prompt example:**
> `@gwennieqf.fchowinter 在一个舞台上和 @testuser.demo 牵手跳舞`

### Things to note
1.  **Space separated**: The role ID must be followed by a space, otherwise the system will not recognize it.
2.  **Multi-role interaction**: Supports referencing multiple created roles in one Prompt.
3.  **Material restrictions**: When creating a character, please ensure that the video material uploaded is clear and not a real person (only two-dimensional/CG/3D and other non-real-person images are supported).