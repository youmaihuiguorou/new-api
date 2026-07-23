

# 🎧 OpenAI 音频格式

!!! info "官方文档"
    [OpenAI Audio](https://platform.openai.com/docs/api-reference/audio)

---

## 📝 简介

OpenAI 音频 API 提供三个主要功能：

1. **文本转语音（TTS）** - 将文本转换为自然语音
2. **语音转文本（STT）** - 将音频转录为文本
3. **音频翻译** - 将非英语音频翻译成英语文本

---

## 💡 请求示例

### 文本转语音 ✅

```bash
curl https://api.wukong.support/v1/audio/speech \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "tts-1",
    "input": "你好，世界！",
    "voice": "alloy"
  }' \
  --output speech.mp3
```

### 语音转文本 ✅

```bash
curl https://api.wukong.support/v1/audio/transcriptions \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/file/audio.mp3" \
  -F model="whisper-1"
```

**响应示例：**

```json
{
  "text": "你好，世界！"
}
```

### 音频翻译 ✅

```bash
curl https://api.wukong.support/v1/audio/translations \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/file/chinese.mp3" \
  -F model="whisper-1"
```

**响应示例：**

```json
{
  "text": "Hello, world!"
}
```

---

## 📮 请求接口

### 端点

| 功能 | HTTP 方法 | Endpoint |
|------|------------|-----------|
| 文本转语音 | POST | `/v1/audio/speech` |
| 语音转文本 | POST | `/v1/audio/transcriptions` |
| 音频翻译 | POST | `/v1/audio/translations` |

---

## 🔐 鉴权

在请求头中添加：

```
Authorization: Bearer $NEWAPI_API_KEY
```

---

## 🧩 请求参数说明

### 文本转语音（TTS）

| 参数 | 类型 | 必需 | 默认 | 可选值 | 说明 |
|------|------|------|------|--------|------|
| `model` | string | 是 | - | `tts-1`, `tts-1-hd`, `seed-tts-1.1`, `speech-2.6-hd`, `speech-2.6-turbo` | 使用的 TTS 模型 |
| `input` | string | 是 | - | ≤ 4096 字符 | 要合成的文本 |
| `voice` | string | 是 | - | 取决于模型 | 音色 |
| `response_format` | string | 否 | mp3 | `mp3`, `opus`, `aac`, `flac`, `wav`, `pcm` | 音频格式 |
| `speed` | number | 否 | 1.0 | 0.25–4.0 | 播放速度 |

---

## 🧠 模型与音色说明

### 🌸 豆包语音合成 2.0 模型 (`seed-tts-1.1`)

| 场景 | 音色名称 | `voice` 参数值 | 语种 |
|------|-----------|----------------|------|
| 通用场景 | vivi | `zh_female_vv_uranus_bigtts` | 中文 / 英语 |
| 视频配音 | 大壹 | `zh_male_dayi_saturn_bigtts` | 中文 |
| 视频配音 | 黑猫侦探社咪仔 | `zh_female_mizai_saturn_bigtts` | 中文 |
| 视频配音 | 鸡汤女 | `zh_female_jitangnv_saturn_bigtts` | 中文 |
| 视频配音 | 魅力女友 | `zh_female_meilinyou_saturn_bigtts` | 中文 |
| 视频配音 | 流畅女声 | `zh_female_santongyongs_saturn_bigtts` | 中文 |
| 视频配音 | 儒雅逸辰 | `zh_male_ruyaichen_saturn_bigtts` | 中文 |
| 角色扮演 | 可爱女生 | `saturn_zh_female_keainvsheng_tob` | 中文 |
| 角色扮演 | 调皮公主 | `saturn_zh_female_tiaopigongzhu_tob` | 中文 |
| 角色扮演 | 爽朗少年 | `saturn_zh_male_shuanglangshaonian_tob` | 中文 |
| 角色扮演 | 天才阿睿 | `saturn_zh_male_tiancairongzhuo_tob` | 中文 |
| 角色扮演 | 知性知灿 | `saturn_zh_female_cancan_tob` | 中文 |

---

### 🔊 MiniMax 语音合成模型 (`speech-2.6-hd`, `speech-2.6-turbo`)

- 支持多国语言、多角色音色。
- 可选 `Voice ID` 在调用时传入 `voice` 参数。
- 下表为部分示例：

| 编号 | 语言 | Voice ID | 音色名称 |
|------|------|-----------|----------|
| 1 | 中文 (普通话) | `male-qn-qingse` | 青涩青年音色 |
| 5 | 中文 (普通话) | `female-shaonv` | 少女音色 |
| 6 | 中文 (普通话) | `female-yujie` | 御姐音色 |
| 9 | 中文 (普通话) | `male-qn-qingse-jingpin` | 青涩青年音色-beta |
| 27 | 中文 (普通话) | `qiaopi_mengmei` | 俏皮萌妹 |
| 31 | 中文 (普通话) | `Chinese (Mandarin)_Reliable_Executive` | 沉稳高管 |
| 43 | 中文 (普通话) | `Chinese (Mandarin)_Sweet_Lady` | 甜美女声 |
| 59 | 粤语 | `Cantonese_ProfessionalHost（F）` | 专业女主持 |
| 70 | 英文 | `Charming_Lady` | Charming Lady |
| 87 | 日文 | `Japanese_DependableWoman` | Dependable Woman |
| 96 | 韩文 | `Korean_SweetGirl` | Sweet Girl |
| 145 | 西班牙文 | `Spanish_SereneWoman` | Serene Woman |
| 192 | 葡萄牙文 | `Portuguese_SentimentalLady` | Sentimental Lady |
| 265 | 法文 | `French_Male_Speech_New` | Level-Headed Man |
| 280 | 德文 | `German_FriendlyMan` | Friendly Man |

> ✅ MiniMax 模型音色支持多语言、角色配音风格等多样化语音输出。

[MiniMax完整音色列表](https://platform.minimaxi.com/docs/faq/system-voice-id)

---

## 📥 响应

### 成功响应

#### 文本转语音
返回二进制音频文件内容（如 `speech.mp3`）。

#### 语音转文本 / 翻译

```json
{
  "text": "转录或翻译后的文本"
}
```

#### 详细格式（可选）

```json
{
  "task": "transcribe",
  "language": "english",
  "duration": 8.47,
  "text": "完整转录内容",
  "segments": [
    {
      "id": 0,
      "seek": 0,
      "start": 0.0,
      "end": 3.32,
      "text": "分段内容",
      "avg_logprob": -0.286,
      "no_speech_prob": 0.009
    }
  ]
}
```

---

### 错误响应

常见状态码：

| 状态码 | 含义 |
|--------|------|
| 400 | 参数错误 |
| 401 | 未授权（API Key 无效或缺失） |
| 429 | 请求过多 |
| 500 | 服务器错误 |

**错误示例：**

```json
{
  "error": {
    "message": "文件格式不支持",
    "type": "invalid_request_error",
    "param": "file",
    "code": "invalid_file_format"
  }
}
```

---

✅ **总结**：

- API 基础地址均为：`https://api.wukong.support`
- 三种主功能：语音→文字、文字→语音、音频翻译
- 可分别选择：
  - OpenAI 原生模型 `tts-1`, `tts-1-hd`
  - 豆包模型 `seed-tts-1.1`
  - MiniMax 模型 `speech-2.6-hd`, `speech-2.6-turbo`
- 各模型均通过 `voice` 参数选择音色。
