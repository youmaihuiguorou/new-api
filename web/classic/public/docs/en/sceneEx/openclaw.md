# OpenClaw (Clawdbot) Setup with Wukong API

## What is OpenClaw?

> OpenClaw is an open-source personal AI assistant that supports local or remote deployment. It can act as an AI agent gateway across operating systems and can connect to platforms such as WhatsApp, Telegram, Discord, iMessage, Feishu, QQ, and DingTalk.

Reference: [OpenClaw official Chinese documentation](https://docs.openclaw.ai/zh-CN)

## 1. Install OpenClaw

Choose the installation method that matches your operating system.

### Script installation (recommended)

#### macOS / Linux

1. **Run the installer**
   ```sh
   curl -fsSL https://openclaw.ai/install.sh | bash
   ```
2. **Verify the installation**
   ```sh
   openclaw --version
   ```

#### Windows (PowerShell)

1. **Run the installer**

   Make sure WSL2 is installed first, then run the installer from WSL inside PowerShell.

   ```sh
   iwr -useb https://openclaw.ai/install.ps1 | iex
   ```
2. **Verify the installation**
   ```sh
   openclaw --version
   ```

---

### Initial OpenClaw setup

Start the interactive onboarding flow:

```sh
openclaw onboard
```

![OpenClaw initialization](../image/sceneEx/openclaw_001.png)

Follow these selections during onboarding:

1. Choose **QuickStart**
   ![Quick start](../image/sceneEx/openclaw_002.png)
2. Choose **Skip for now**
   ![Skip](../image/sceneEx/openclaw_003.png)
3. Choose **All providers**
   ![All providers](../image/sceneEx/openclaw_004.png)
4. Choose **Keep current**
   ![Keep current](../image/sceneEx/openclaw_005.png)
5. For chat tools, you can also choose **Skip for now**
   ![Skip chat tool](../image/sceneEx/openclaw_006.png)
6. For Skills, choose **Skip for now**, select with the space bar, and confirm with Enter
   ![Skip skills configuration](../image/sceneEx/openclaw_007.png)
7. For the recommended settings, select all three options shown below
   ![Recommended options](../image/sceneEx/openclaw_008.png)

After the wizard finishes, OpenClaw will usually open the gateway page in your default browser automatically.

If the gateway is not running, start it manually:

```sh
openclaw gateway
```

---

## 2. Connect OpenClaw to Wukong API

### Get an API key

1. Register and top up at [https://wukong.support](https://wukong.support)
2. Open the token management page and copy your API key
3. It is recommended to create a new token and choose the `ClaudeCode` group, or another lower-cost dedicated group. Using the `default` group may be more expensive

### Open the configuration file

After installation, OpenClaw stores its configuration in `openclaw.json`.

Open the OpenClaw directory:

```sh
open ~/.openclaw
```

If you are using Windows inside WSL, you can also run:

```sh
explorer.exe .
```

### Update the configuration

Open `openclaw.json` and replace the existing `agents` and `models` sections with the following example. Make sure to replace `apiKey` with your own token.

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "wukongApi/claude-sonnet-4-6"
      },
      "models": {
        "wukongApi/claude-sonnet-4-6": {}
      }
    }
  },
  "models": {
    "mode": "merge",
    "providers": {
      "wukongApi": {
        "baseUrl": "https://api.wukong.support/v1",
        "apiKey": "sk-xxx",
        "api": "openai-completions",
        "compat": {
          "supportsPromptCacheKey": true
        },
        "models": [
          {
            "id": "claude-sonnet-4-6",
            "name": "claude-sonnet-4-6",
            "reasoning": false,
            "input": [
              "text",
              "image"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 200000,
            "maxTokens": 32000
          }
        ]
      }
    }
  }
}
```

> If you change `api` to `openai-responses`, keep `compat.supportsPromptCacheKey: true`. For custom non-OpenAI/Azure `baseUrl` endpoints, OpenClaw may otherwise strip `prompt_cache_key` and `prompt_cache_retention`; this setting declares that the relay supports forwarding prompt cache fields and restores cache hits.

### Restart OpenClaw

After saving `openclaw.json`, restart the gateway:

```sh
openclaw gateway
```

If everything is configured correctly, you should see the OpenClaw gateway page with your Wukong-backed provider available:

![Gateway interface](../image/sceneEx/openclaw_009.png)
