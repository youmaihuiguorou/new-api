# Wukong API Overview

`Official upstream relay` `High concurrency` `No VPN required` `Availability ≥ 99%` `Multiple model families`

### Overview
!> **Notice:** This service is intended for learning, research, and testing. Please do not use it for any activity that could endanger national security. Users are responsible for their own behavior, and this site reserves the right to pursue legal responsibility when necessary.

Wukong API provides a unified AI model gateway built around an OpenAI-compatible interface. In addition to OpenAI models, it also supports many mainstream model families such as Claude, Gemini, DeepSeek, Qwen, and Coze. In most cases, you can keep the same integration pattern and simply switch the model name.

#### Core advantages
- **Official upstream channels only**: Uses official relay channels to keep the service stable and compliant.
- **Pay as you go**: No subscription plan or membership fee. You only pay for actual usage.
- **No reverse-engineered routes**: Helps protect privacy, stability, and technical security.
- **Fast responses**: Optimized routing and network paths help keep latency low.
- **Clear billing details**: Usage records are visible and easy to audit.
- **Online top-up**: Recharge online and start using supported models immediately.

#### API endpoint
- **Official API endpoint**: [https://api.wukong.support](https://api.wukong.support)

---

### Quick Start

#### Top up your balance
Open the [Wallet](https://wukong.support/console/topup) page and make sure your account balance is greater than `0`.

#### Create an API key
Open the [Token](https://wukong.support/console/token) page, create a token, and copy your personal API key.

#### Relay information
- **Relay base URL**: `https://api.wukong.support`
- **Relay API key**: `sk-xxxxxxxxx`

#### Replace the API base URL
If you are already using the official OpenAI SDK or API documentation, replace `https://api.openai.com` with `https://api.wukong.support`.

Claude models also support the native `v1/messages` endpoint. See the Claude-specific documentation for details.

**Tip:** Some third-party tools require a full path when configuring a custom endpoint. In those cases, one of the following formats may be needed:
- `https://api.wukong.support`
- `https://api.wukong.support/v1`
- `https://api.wukong.support/v1/chat/completions`

---

### Common Use Cases

#### AI applications
Wukong API can be used with many AI applications, including:
- Lobe-chat
- OpenAI Translator
- ChatX
- Cherry Studio
- ChatBox
- Sider
- ChatGPT Next Web
- Cursor
- OfficeAI Assistant
- Immersive Translate

#### LLM development
Mainstream development libraries such as LangChain and LlamaIndex are fully supported.

The setup process is close to the official OpenAI workflow. Replace the API address and key, then start integrating.

---

### Service Features

- **Stable and reliable**: Built around OpenAI-compatible standards and designed for high-concurrency stability.
- **Seamless compatibility**: Developers can switch from the official OpenAI API with minimal migration effort.
- **Fast access**: Routes are continuously optimized for responsive requests.
- **Simple to operate**: No complicated setup and no hidden charges, so you can stay focused on building.

---

### Contact

QQ support: `515199667`  
Telegram: `@wukongapi`

Email:

`wukongapi@gmail.com`

Feel free to contact us through any of the channels above. Wukong looks forward to building the future of AI with you.
