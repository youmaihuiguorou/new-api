

# OpenAI 视频接口文档（字节豆包 Doubao-Video）

调用 **OpenAI 视频生成接口** 以生成视频内容，本文档专用于**字节跳动豆包（Doubao）** 系列视频生成模型（文生视频、图生视频）。

---

## 一、支持的模型

### 模型列表

| 模型名称 | 说明 | 适用场景 |
| :--- | :--- | :--- |
| `doubao-seedance-1-5-pro-251215` | 豆包视频生成 1.5 Pro | 支持文生视频、首尾帧控制的高级视频生成 |

---

### 价格说明

> **提示**：在 悟空 中将密钥分配到 **专用分组（目前默认分组即可享受折扣）** 通常会有额外折扣。

| 模型系列 | 分辨率 | 价格 (CNY) | 限时 4 折优惠 |
| :--- | :--- | :--- | :--- |
| **doubao-seedance-1-5-pro-251215** | 720P | ~~￥0.346/秒~~ | **￥0.13** / 秒 |
| | 1080P | ~~￥0.778/秒~~ | **￥0.29** / 秒 |



## 二、生成视频

### API 端点

```
POST /v1/videos
```

### 请求头

| 参数 | 类型 | 必填 | 描述 |
| :--- | :--- | :--- | :--- |
| Authorization | string | 是 | 用户认证令牌（Bearer: sk-xxxx） |
| Content-Type | string | 是 | **application/json** |

### 请求参数 (JSON Body)

| 参数 | 类型 | 必填 | 描述 |
| :--- | :--- | :--- | :--- |
| **model** | string | 是 | 指定模型名称：`doubao-seedance-1-5-pro-251215` |
| **prompt** | string | 是 | 视频内容文本提示词。 |
| **images** | array[string] | 否 | 参考图片列表，支持首帧和尾帧控制。<br>- 数组第1项：首帧图片的 URL 或 Base64。<br>- 数组第2项：尾帧图片的 URL 或 Base64（可选）。 |
| **aspect_ratio** | string | 否 | 视频比例。默认为 `16:9`。<br>支持值：`16:9`, `9:16`, `1:1`, `4:3`, `3:4`, `21:9`, `adaptive`（根据输入自动选择最合适的宽高比） 等。 |
| **resolution** | string | 否 | 视频分辨率。默认为 `720p`。<br>支持值：`1080p`, `720p`。 |
| **duration** | string/int | 否 | 视频时长（秒）。<br>范围： **[4, 12]** 之间的任一整数（例如 `5`, `10`）。 |
| **seed** | integer | 否 | 随机种子，用于控制生成内容的随机性。<br>默认值：`-1`（随机）。<br>取值范围：`[-1, 2^32-1]`。<br>**注意**：<br>1. 相同的请求下，不指定或设为 -1，结果随机。<br>2. 相同的请求下，固定 Seed 值，会生成类似结果（但不保证完全一致）。 |
| **watermark** | boolean | 否 | 是否包含水印。<br>`false`：不含水印（默认）。<br>`true`：含有水印。 |

---

### 请求示例

#### 1. 基础文生视频/图生视频
*生成一段 10 秒、1080p 的 9:16 视频，指定首帧和尾帧*

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

### 响应格式

#### 200 - 提交成功

```json
{
    "id": "cgt-20260124220030-9s4dc"
}
```

> **注意**：任务 ID 仅保存 7 天（从 created_at 时间戳开始计算），超时后将自动清除。

---

## 三、查询任务状态

视频生成通常需要一定时间，请通过任务 ID 轮询状态。

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
curl --location --request GET 'https://api.wukong.support/v1/videos/cgt-20260124220030-9s4dc' \
--header 'Authorization: Bearer sk-xxx'
```

---

### 响应格式

#### 200 - 成功完成 (Completed)

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

#### 关键字段说明

| 字段 | 类型 | 描述 |
|------|------|------|
| **status** | string | 任务状态。常见值：<br>`queued`: 排队中<br>`processing`: 处理中<br>`completed`: 已完成<br>`failed`: 失败 |
| **video_url** | string | 最终视频的下载链接（仅当 status 为 `completed` 时返回）。 |
| **progress** | string | 生成进度百分比（例如 "100%"）。 |

---

## 四、参数详解

### 1. 时长 (Duration)
Doubao 模型支持灵活的时长设置。
- 范围：`4` 到 `12` 秒之间的任意整数。
- 推荐值：`5` 或 `10`。

### 2. 种子 (Seed)
用于复现或控制结果的随机性。
- **随机生成**：不传该参数，或传 `-1`。
- **固定风格**：传入一个固定的整数（如 `123456`），在 Prompt 和参数不变的情况下，画面构图和运动轨迹会保持相对稳定。

### 3. 首尾帧控制 (Images)
通过 `images` 数组实现精细控制：
- **仅文生视频**：`images` 留空或不传。
- **图生视频（首帧）**：`images` 传入 1 个图片 URL。
- **首尾帧控制**：`images` 传入 2 个图片 URL（第一个为开始画面，第二个为结束画面），模型将生成两图之间的过渡动画。
