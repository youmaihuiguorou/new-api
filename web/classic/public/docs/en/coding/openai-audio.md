

# 🎧 OpenAI audio format

!!! info "Official Documentation"
    [OpenAI Audio](https://platform.openai.com/docs/api-reference/audio)

---

## 📝 Introduction

The OpenAI Audio API provides three main functions:

1. **Text to Speech (TTS)** - Convert text to natural speech
2. **Speech to Text (STT)** - Transcribe audio to text
3. **Audio Translation** - Translate non-English audio into English text

---

## 💡 Request example

### Text to Speech ✅

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

### Speech to text ✅

```bash
curl https://api.wukong.support/v1/audio/transcriptions \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/file/audio.mp3" \
  -F model="whisper-1"
```

**Response example:**

```json
{
  "text": "你好，世界！"
}
```

### Audio Translation ✅

```bash
curl https://api.wukong.support/v1/audio/translations \
  -H "Authorization: Bearer $NEWAPI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/path/to/file/chinese.mp3" \
  -F model="whisper-1"
```

**Response example:**

```json
{
  "text": "Hello, world!"
}
```

---

## 📮 Request interface

### endpoint

| Function| HTTP method| Endpoint |
|------|------------|-----------|
| text to speech| POST | `/v1/audio/speech` |
| speech to text| POST | `/v1/audio/transcriptions` |
| audio translation| POST | `/v1/audio/translations` |

---

## 🔐 Authentication

Add in the request header:

```
Authorization: Bearer $NEWAPI_API_KEY
```

---

## 🧩 Request parameter description

### Text to Speech (TTS)

| parameters| Type| required| Default| Optional value| Description|
|------|------|------|------|--------|------|
| `model` | string | Yes| - | `tts-1`, `tts-1-hd`, `seed-tts-1.1`, `speech-2.6-hd`, `speech-2.6-turbo` | TTS model used|
| `input` | string | Yes| - | ≤ 4096 characters| Text to be synthesized|
| `voice` | string | Yes| - | Depends on model| timbre|
| `response_format` | string | No| mp3 | `mp3`, `opus`, `aac`, `flac`, `wav`, `pcm` | audio format|
| `speed` | number | No| 1.0 | 0.25–4.0 | play speed|

---

## 🧠 Model and sound description

### 🌸 Doubao speech synthesis 2.0 model (`seed-tts-1.1`)

| scene| Voice name| `voice` Parameter value| Language|
|------|-----------|----------------|------|
| Common scenarios| vivi | `zh_female_vv_uranus_bigtts` | Chinese / English|
| video dubbing| Dayi| `zh_male_dayi_saturn_bigtts` | Chinese|
| video dubbing| Black Cat Detective Agency Mizai| `zh_female_mizai_saturn_bigtts` | Chinese|
| video dubbing| Chicken Soup Girl| `zh_female_jitangnv_saturn_bigtts` | Chinese|
| video dubbing| Charming girlfriend| `zh_female_meilinyou_saturn_bigtts` | Chinese|
| video dubbing| smooth female voice| `zh_female_santongyongs_saturn_bigtts` | Chinese|
| video dubbing| Elegant Yichen| `zh_male_ruyaichen_saturn_bigtts` | Chinese|
| role play| cute girls| `saturn_zh_female_keainvsheng_tob` | Chinese|
| role play| naughty princess| `saturn_zh_female_tiaopigongzhu_tob` | Chinese|
| role play| Cheerful boy| `saturn_zh_male_shuanglangshaonian_tob` | Chinese|
| role play| Genius Ari| `saturn_zh_male_tiancairongzhuo_tob` | Chinese|
| role play| Intellectual knowledge| `saturn_zh_female_cancan_tob` | Chinese|

---

### 🔊 MiniMax speech synthesis model (`speech-2.6-hd`, `speech-2.6-turbo`)

- Supports multiple languages and character sounds.
- Optional`Voice ID` Passed in when calling`voice` parameters.
- The following table shows some examples:

| No.| language| Voice ID | Voice name|
|------|------|-----------|----------|
| 1 | Chinese (Mandarin)| `male-qn-qingse` | Youthful tone|
| 5 | Chinese (Mandarin)| `female-shaonv` | girly timbre|
| 6 | Chinese (Mandarin)| `female-yujie` | Royal sister timbre|
| 9 | Chinese (Mandarin)| `male-qn-qingse-jingpin` | Youthful tone-beta|
| 27 | Chinese (Mandarin)| `qiaopi_mengmei` | Playful and cute girl|
| 31 | Chinese (Mandarin)| `Chinese (Mandarin)_Reliable_Executive` | Calm executive|
| 43 | Chinese (Mandarin)| `Chinese (Mandarin)_Sweet_Lady` | Sweet female voice|
| 59 | Cantonese| `Cantonese_ProfessionalHost（F）` | Professional female host|
| 70 | English| `Charming_Lady` | Charming Lady |
| 87 | Japanese| `Japanese_DependableWoman` | Dependable Woman |
| 96 | Korean| `Korean_SweetGirl` | Sweet Girl |
| 145 | spanish| `Spanish_SereneWoman` | Serene Woman |
| 192 | portuguese| `Portuguese_SentimentalLady` | Sentimental Lady |
| 265 | French| `French_Male_Speech_New` | Level-Headed Man |
| 280 | german| `German_FriendlyMan` | Friendly Man |

> ✅ MiniMax model sounds support diverse voice output such as multiple languages and character dubbing styles.

[MiniMax complete sound list](https://platform.minimaxi.com/docs/faq/system-voice-id)

---

## 📥Response

### successful response

#### text to speech
Returns the binary audio file content (e.g.`speech.mp3`）。

#### Speech to text/translation

```json
{
  "text": "转录或翻译后的文本"
}
```

#### Detailed format (optional)

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

### error response

Common status codes:

| status code| meaning|
|--------|------|
| 400 | Parameter error|
| 401 | Unauthorized (API Key is invalid or missing)|
| 429 | Too many requests|
| 500 | Server error|

**Error example:**

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

✅ **Summary**:

- The API base addresses are:`https://api.wukong.support`
- Three main functions: voice → text, text → voice, audio translation
- You can choose separately:
  - OpenAI native model`tts-1`, `tts-1-hd`
  - bean bag model`seed-tts-1.1`
  - MiniMax model`speech-2.6-hd`, `speech-2.6-turbo`
- All models passed`voice` Parameters select the tone.
