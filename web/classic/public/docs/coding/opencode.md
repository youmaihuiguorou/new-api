
# OpenCode 配置 熊猫API 教程

本文档旨在说明如何将符合 OpenAI 接口规范的 API 服务（以熊猫API为例）集成到 OpenCode 环境中。

> **⚠️ 关于 Gemini 模型的特别提示**
>
> 如果您计划在 OpenCode 中使用 **Gemini** 系列模型，建议使用 **Chat** 格式。若使用原生格式，可能会因 OpenCode 与 Gemini 的格式协议兼容性问题导致报错。其他编程工具请酌情调整。

## 1. OpenCode 环境准备

首先，请确保您的 OpenCode CLI 环境已安装并更新至最新版本：

```bash
pnpm install -g @opencode/cli
```

## 2. 注册 API 凭证 (Auth)

为了安全起见，避免在配置文件中明文存储 API Key，我们需要先在 OpenCode 的本地密钥管理器中注册服务商别名。

1.  **执行认证指令：**
    ```bash
    opencode auth login
    ```
2.  **选择类型：** 在列表中向下滚动，选中底部的 **`other`** (或直接键入 `other` 搜索)。
3.  **定义 ID：** 输入一个自定义标识符，建议输入 **`wukongApi`**。
    *   *注意：此 ID 将用于后续配置文件的关联，请务必记住。*
4.  **录入密钥：** 输入您在 熊猫API 平台获取的 `sk-xxxx` 开头的 API Key。

## 3. 配置 OpenCode 参数

OpenCode 通过 `opencode.json` 文件来解析服务商参数。请根据您的操作系统找到并编辑（或新建）该文件。

### 配置文件路径

请根据您的系统类型，定位以下路径：

*   **Windows 系统：**
    ```text
    %USERPROFILE%\.config\opencode\opencode.json
    ```
*   **macOS / Linux 系统：**
    ```text
    ~/.config/opencode/opencode.json
    ```

### 配置模版代码

请将以下内容复制到您的 `opencode.json` 文件中。
**注意**：如果您在第 2 步定义的 ID 不是 `wukongApi`，请修改代码中对应的键名。

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

### 参数配置详解

| 参数节点 | 说明 |
| :--- | :--- |
| **根键名** | 即代码中的 `"wukongApi"`，**必须**与第 2 步中 `opencode auth login` 时输入的 **ID** 完全一致（区分大小写）。 |
| **npm** | 固定使用 `@ai-sdk/openai-compatible` 以适配通用 OpenAI 协议。 |
| **baseURL** | 填写接口地址：`https://api.wukong.support/v1` (通常需包含 `/v1` 后缀)。 |
| **apiKey** | 使用 `"{cred:ID}"` 语法（例如 `"{cred:wukongApi}"`）。系统会自动从本地凭证库提取对应 ID 的密钥，实现无明文配置。 |
| **models** | 需手动声明您想使用的模型列表。键名（Key）必须对应熊猫API平台支持的真实 Model ID。 |

## 4. 加载与验证

配置修改完成后，需要重启客户端以加载新的映射关系。

1.  **启动主程序：**
    ```bash
    opencode
    ```
2.  **调出模型菜单：**
    在交互栏输入指令：
    ```bash
    /models
    ```
3.  **验证结果：**
    如果配置无误，您将在列表中看到名为 `wukongApi` 的服务商及其下属模型。

## 🛠 常见问题排查 (Troubleshooting)

如果配置后无法使用，请按以下清单核对：

*   **ID 一致性检查：** JSON 配置文件中的键名（如 `wukongApi`）是否与 `opencode auth login` 时输入的 ID **完全相等**？
*   **接口地址：** 确认 `baseURL` 为 `https://api.wukong.support/v1`。
    *   *提示：如果连接失败，可尝试去掉 `/v1` 或使用 Postman 测试 `https://api.wukong.support/v1/models` 的连通性。*
*   **模型名称：** `models` 列表下的模型 ID 是否与平台模型广场中的名称完全一致？（例如是 `claude-sonnet-4-5` 还是 `claude-sonnet-4-5-20250929`）。
*   **缓存清理：** 若修改后未生效，请彻底关闭终端或结束 OpenCode 进程后再次启动。
