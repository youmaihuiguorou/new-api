# OpenCode Integration Guide

This guide explains how to connect OpenCode to a Wukong API endpoint that follows the OpenAI-compatible interface format.

> **Important note for Gemini models**
>
> If you plan to use Gemini models in OpenCode, it is recommended to use the **Chat** format. Native formats may trigger compatibility issues between OpenCode and Gemini.

## 1. Prepare the OpenCode environment

Make sure OpenCode CLI is installed and up to date:

```bash
pnpm install -g @opencode/cli
```

## 2. Register the API credential

To avoid storing your API key in plain text inside the config file, first register a provider alias in OpenCode's local credential manager.

1. Run:
   ```bash
   opencode auth login
   ```
2. In the provider list, choose **`other`**
3. Enter a custom ID, for example **`wukongApi`**
4. Paste your Wukong API key that starts with `sk-xxxx`

## 3. Configure OpenCode

OpenCode reads provider definitions from `opencode.json`.

### Config file path

- **Windows**
  ```text
  %USERPROFILE%\.config\opencode\opencode.json
  ```
- **macOS / Linux**
  ```text
  ~/.config/opencode/opencode.json
  ```

### Example configuration

Copy the following content into `opencode.json`.

If the ID you created in step 2 is not `wukongApi`, replace the corresponding key names below.

```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "wukongApi": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "wukongApi",
      "options": {
        "baseURL": "https://api.wukong.support/v1",
        "apiKey": "{cred:wukongApi}"
      },
      "models": {
        "claude-sonnet-4-5-20250929": { "name": "claude-sonnet-4-5" },
        "gpt-5.2": { "name": "gpt-5.2" }
      }
    }
  }
}
```

### Parameter notes

| Field | Description |
| :--- | :--- |
| `wukongApi` | Must exactly match the ID entered during `opencode auth login` |
| `npm` | Use `@ai-sdk/openai-compatible` for OpenAI-compatible APIs |
| `baseURL` | Set to `https://api.wukong.support/v1` |
| `apiKey` | Use the credential reference format `"{cred:ID}"` |
| `models` | Declare the models you want OpenCode to expose |

## 4. Verify the setup

After saving the config, restart OpenCode so it reloads the provider mapping.

1. Launch OpenCode:
   ```bash
   opencode
   ```
2. Open the model selector:
   ```bash
   /models
   ```
3. If everything is correct, you should see the `wukongApi` provider and its configured models

## Troubleshooting

- **Provider ID mismatch**: Make sure the JSON key and the `auth login` ID are exactly the same
- **Wrong base URL**: Confirm `baseURL` is `https://api.wukong.support/v1`
- **Model ID mismatch**: Verify that the model IDs in `models` match the real model names shown on the platform
- **Cache not refreshed**: Completely restart OpenCode after editing the config
