# Sora-2 角色创建与提取 API 文档

## 1. 概述
本模块包含两个步骤：
1.  **提交任务**：上传视频 URL 和时间戳，提交角色提取任务。
2.  **查询结果**：轮询任务状态，获取生成的角色 ID (`Username`)。

---

## 2. 接口详情

### 2.1 创建角色提取任务
提交视频片段以提取角色特征。

- **接口地址**: `https://api.wukong.support/v1/videos`
- **请求方式**: `POST`
- **Content-Type**: `application/json`

#### 请求头 (Headers)
| 参数名 | 值 | 说明 |
| :--- | :--- | :--- |
| Authorization | `Bearer sk-xxx` | 您的 API Key |
| Content-Type | `application/json` | 数据格式 |

#### 请求参数 (Body)
| 参数名 | 类型 | 必填 | 说明 | 限制与示例 |
| :--- | :--- | :--- | :--- | :--- |
| `model` | string | 是 | 模型名称 | 固定值为 `"sora-2-characters"` |
| `url` | string | 是 | 视频地址 | 包含角色的视频 URL。<br>⚠️ **注意：不支持真人视频** |
| `timestamps` | string | 是 | 角色出现的时间范围 | 格式："起始秒,结束秒" (整数)<br>例如：`"1,4"`<br>**限制：**<br>1. 最小时间差：1秒<br>2. 最大时间差：3秒 |

#### 请求示例
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

#### 响应示例
```json
{
    "id": "e9d9ed9d-804c-4aa3-bf2c-998660145030",
    "object": "video.generation",
    "status": "pending"
}
```

---

### 2.2 查询任务结果 (轮询)
通过任务 ID 查询角色提取的进度和结果。

- **接口地址**: `https://api.wukong.support/v1/videos/{id}`
- **请求方式**: `GET`

#### 路径参数 (Path)
| 参数名 | 说明 |
| :--- | :--- |
| `id` | 第一步响应中获取的 `id` (任务ID) |

#### 请求示例
```bash
curl --location --request GET 'https://api.wukong.support/v1/videos/e9d9ed9d-804c-4aa3-bf2c-998660145030' \
--header 'Authorization: Bearer sk-xxx'
```

#### 响应示例 (成功状态)
只有当 `"status": "completed"` 时，任务才算成功。

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

#### 响应字段说明
- `status`: 任务状态。`pending` (排队中), `processing` (处理中), `completed` (完成), `failed` (失败)。
- `data.characters[0].id`: **生成的角色 ID (Username)**。后续生成视频时需使用此 ID。

---

## 3. 角色使用指南

获取到角色 ID 后，可以在 Sora 视频生成任务的 Prompt 中调用该角色。

### 调用语法
使用 `@` 符号加上角色 ID，并在 ID 后**必须保留一个空格**。

**格式：**
`@角色ID 动作描述`

### 示例
假设获取到的角色 ID 为：
- 角色1: `gwennieqf.fchowinter`
- 角色2: `testuser.demo`

**Prompt 示例：**
> `@gwennieqf.fchowinter 在一个舞台上和 @testuser.demo 牵手跳舞`

### 注意事项
1.  **空格分隔**：角色 ID 后面必须紧跟一个空格，否则系统无法识别。
2.  **多角色互动**：支持在一个 Prompt 中引用多个已创建的角色。
3.  **素材限制**：创建角色时，请确保上传的视频素材清晰，且不是真人（仅支持二次元/CG/3D等非真人形象）。