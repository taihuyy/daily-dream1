# Flutter 梦境 App 本地化迁移计划

## 目标
将 mini-dream 小程序中已验证可用的功能迁移回 `D:\AI\mi\dream` Flutter 项目，改为纯本地单机使用（Hive 存储），确保 AI 润色和图像生成正常工作。

## 关键发现（mini-dream 已验证）

### 1. 图像生成 API（已验证可用）
- **端点**: `https://dashscope-intl.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation`
- **模型**: `qwen-image-2.0-pro`（不是旧的 `wanx-v1`）
- **API Key**: `sk-ws-H.IRREIM.o7EL.MEUCIDUSIjlmET2w_QkXBWQYAlxyrFkqkTWRkRYmFWImYWMPAiEApwLdMEGA_ycV1l9ri_KcbWyA2Ee3ST4sr9lhS-EGmqs`
- **请求格式**（同步，不需要异步轮询）:
```json
{
  "model": "qwen-image-2.0-pro",
  "input": {
    "messages": [
      {
        "role": "user",
        "content": [{ "text": "prompt" }]
      }
    ]
  },
  "parameters": {
    "result_format": "message",
    "watermark": false,
    "prompt_extend": true,
    "size": "1024*1024"
  }
}
```
- **响应格式**: `output.choices[0].message.content[0].image` → 图片 URL

### 2. AI 润色 Prompt（已验证可用）
- **MiMo Base URL**: `https://token-plan-cn.xiaomimimo.com/v1`
- **MiMo Model**: `mimo-v2.5`
- **MiMo API Key**: `tp-c6a3t7d2ce7ex92jyw2xer8obkp4i2oms7n0jn3sbhmb11yd`
- **整理 Prompt**（关键——放在 user 消息中，不要用 system prompt）:
```
请将以下梦境描述改写成优美的散文，用"我"第一人称，加入感官细节和比喻，不要重复原文。

梦境内容：{用户对话内容}

请直接返回JSON：{"title":"标题","fullText":"改写后的散文","tags":["标签"],"summary":"一句话"}
```
- **温度**: 0.8
- **max_tokens**: 1500

---

## 需要修改的文件

### 文件 1: `lib/services/settings_service.dart`
**改动**: 更新默认值

| 字段 | 旧值 | 新值 |
|------|------|------|
| `mimoBaseUrl` 默认值 | `https://api.mimo.com/v1` | `https://token-plan-cn.xiaomimimo.com/v1` |
| `mimoModel` 默认值 | `mimo-7b` | `mimo-v2.5` |
| `wanxiangApiKey` 默认值 | `''` | `sk-ws-H.IRREIM.o7EL.MEUCIDUSIjlmET2w_QkXBWQYAlxyrFkqkTWRkRYmFWImYWMPAiEApwLdMEGA_ycV1l9ri_KcbWyA2Ee3ST4sr9lhS-EGmqs` |
| 新增字段 `_keyDashscopeHost` | — | `https://dashscope-intl.aliyuncs.com` |
| 新增字段 `_keyImageModel` | `''` | `qwen-image-2.0-pro` |

### 文件 2: `lib/services/tongyi_wanxiang_service.dart`
**改动**: 完全重写图像生成逻辑

旧代码用的是 `text2image/image-synthesis` 端点 + 异步轮询，已不可用。

新逻辑:
- **端点**: `/api/v1/services/aigc/multimodal-generation/generation`
- **baseUrl**: `https://dashscope-intl.aliyuncs.com`（不是 `dashscope.aliyuncs.com`）
- **模型**: `qwen-image-2.0-pro`
- **同步调用**（去掉 `X-DashScope-Async: enable`）
- **请求体**: 使用 `input.messages` 格式，不是 `input.prompt`
- **响应解析**: `output.choices[0].message.content[0].image` 获取图片 URL
- **下载图片并保存到本地**（不再用云存储，用 `path_provider` 保存到应用目录）

### 文件 3: `lib/services/ai_service.dart`
**改动**: 更新 `summarizeDream` 方法

1. 将整理 prompt 从 system 消息改为 user 消息内容（与 mini-dream 一致）
2. prompt 内容:
```
请将以下梦境描述改写成优美的散文，用"我"第一人称，加入感官细节和比喻，不要重复原文。

梦境内容：{fullConversation}

请直接返回JSON：{"title":"标题","fullText":"改写后的散文","tags":["标签"],"summary":"一句话"}
```
3. `temperature` 从 `0.6` 改为 `0.8`
4. 去掉 `response_format: {'type': 'json_object'}`（MiMo 不支持）
5. `max_tokens` 改为 `1500`

### 文件 4: `lib/pages/settings_page.dart`
**改动**: 更新设置页显示的字段

确保用户能看到并配置:
1. MiMo API Key
2. MiMo Base URL（默认 `https://token-plan-cn.xiaomimimo.com/v1`）
3. MiMo Model（默认 `mimo-v2.5`）
4. DashScope API Key（图像生成）
5. 图像模型（默认 `qwen-image-2.0-pro`）

### 文件 5: `lib/pages/image_video_page.dart`
**改动**: 适配新的图像生成逻辑

- 去掉异步轮询逻辑（新 API 是同步的）
- 生成完成后直接显示图片
- 图片保存到本地路径（用 `path_provider`）

### 文件 6: `lib/main.dart`
**改动**: 确保 `TongyiWanxiangService` 传入正确的默认 baseUrl

---

## 实施顺序

### Step 1: 更新 `settings_service.dart`
修改默认值，确保新用户打开 app 就能直接使用。

### Step 2: 重写 `tongyi_wanxiang_service.dart`
核心改动。确保 `generateImage` 方法:
1. 用正确的端点和格式调用 API
2. 同步获取图片 URL
3. 下载图片保存到本地
4. 返回本地文件路径

### Step 3: 更新 `ai_service.dart`
更新 `summarizeDream` 方法中的 prompt 和参数。

### Step 4: 更新 `settings_page.dart`
确保设置页面包含所有必要的配置项。

### Step 5: 更新 `image_video_page.dart`
适配新的同步图像生成逻辑。

### Step 6: 更新 `main.dart`
确保服务初始化正确。

---

## 验证方案

1. **AI 对话**: 输入梦境描述 → AI 追问 → 正常对话
2. **AI 润色**: 点击"生成整理结果" → 应返回润色后的散文（不是原文重复）
3. **图像生成**: 点击"生成图像" → 应返回真实图片（不是报错）
4. **数据持久化**: 关闭 app 重新打开 → 梦境记录仍在
5. **设置页**: 能看到和修改 API Key、模型等配置

---

## 注意事项

- 所有数据用 Hive 本地存储，不需要云开发
- 图片保存到本地，不需要云存储
- 两个 API Key 必须在设置页配置后才能使用
- 旧的 `wanx-v1` 模型和 `dashscope.aliyuncs.com` 端点已不可用，必须替换
