# 悟空 API介绍

`纯官转API` `超高并发` `无需魔法` `可用性≥99%` `多种模型`

### 概述
!> **声明：**本站提供的服务仅限学习、研究、测试等用途，请不要用于任何危害国家安全的用途，本站不承担用户导致的法律责任，并保留追究法律责任的权利。

欢迎使用 悟空 提供的 AI 模型 API 路由服务！我们基于统一的 OpenAI API 标准，支持 OpenAI 官方所有模型及市面上其他主流大模型（如 Claude、Gemini、DeepSeek、Qwen、Coze等）。无论调用哪种模型，使用方法都保持一致，只需在参数中修改模型名称为对应的名称即可。


#### 核心优势
- **纯官方转接口**：我们提供的是纯官方转接口渠道，确保服务的稳定性和合规性。  
- **按量计费**：无包月、无会员，按实际使用量计费，灵活透明，杜绝隐藏消费。  
- **拒绝逆向**：我们严格拒绝任何形式的逆向工程，保障技术安全和数据隐私。  
- **极速对话**：通过优化路由和线路，确保 API 调用响应速度达到最优。  
- **明细透明**：所有消费记录清晰可查，让您对每一笔支出都了如指掌。  
- **在线充值**：支持在线充值，充值后即可立即使用所有模型，无需等待。  

#### API 地址
- **官方 API 地址**：[https://api.wukong.support](https://api.wukong.support)  

---

### 快速上手

#### 充值
进入[「钱包」](https://wukong.support/console/topup)页面完成充值，确保账户余额 > 0。

#### 创建 API Key（令牌）
打开[「令牌」](https://wukong.support/console/token)页面，创建并复制您的专属 Key。

#### 获取中转信息
- **中转接口地址**：```https://api.wukong.support```
- **中转 API Key**：sk-xxxxxxxxx  

#### 替换 API 地址
如果你是开发者，请参考 OpenAI 官方文档。  
开发时，将文档中的 `https://api.openai.com` 替换为 `https://api.wukong.support` 即可。  
Claude 模型也支持原生 `v1/messages` 接口（详情请参考“Claude 原生接口调用方法”）。  

**提示**：在一些第三方软件或平台输入自定义 URL 时，可能需要添加 `/v1` 或 `/v1/chat/completions` 路径，如：  
- `https://api.wukong.support`
- `https://api.wukong.support/v1`（这种情况目前是最多的）  
- `https://api.wukong.support/v1/chat/completions`  

---

### 常用功能与场景

#### 基于模型 API 的应用软件
支持多种基于 AI 模型的应用软件，例如：  
- Lobe-chat  
- OpenAI Translator  
- ChatX  
- Cherry Studio  
- ChatBox  
- Sider  
- ChatGPT Next Web  
- Cursor  
- OfficeAI助手  
- 沉浸式翻译  

#### 大模型开发
完整支持 LangChain、LlamaIndex 等主流开发库的调用。  
安装配置与 OpenAI 官方一致，仅需替换 API 地址和 Key 即可快速接入。  

---

### 服务特点
- **稳定可靠**：基于 OpenAI 官方标准，支持所有主流模型，确保高并发下的稳定服务。  
- **无缝兼容**：与 OpenAI 官方 API 完全兼容，开发者无需额外学习成本，即可无缝切换。  
- **快速响应**：持续优化线路，保障访问与响应速度，让您的应用体验更流畅。  
- **省心省力**：无复杂配置，无隐藏费用，用多少买多少，让您专注于业务开发。  

---

### 联系我们

qq客服：515199667  
Telegram: @wukongapi

联系邮箱：

wukongapi@gmail.com
 

欢迎通过上述邮箱与我们取得联系，悟空 期待与您共创 AI 未来！
