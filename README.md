# 每日梦境 - Daily Dream

Flutter 原型 App — AI 梦境记录与分享

## 快速开始

1. 安装 Flutter SDK (>= 3.10)
2. 在项目根目录运行:
   ```bash
   flutter pub get
   flutter run
   ```

## 技术栈

- **Flutter** — 跨平台 UI 框架
- **Provider** — 状态管理
- **Hive** — 本地持久化存储
- **Google Fonts** — Noto Sans SC 字体

## 页面结构 (12 屏)

| 页面 | 路由 | 说明 |
|------|------|------|
| Welcome | `/welcome` | 启动页 |
| Home | `/home` | 首页 |
| RecordChoice | `/record-choice` | 文字/语音选择 |
| RecordText | `/record-text` | 文本输入 |
| RecordVoice | `/record-voice` | 语音录制 |
| AI Chat | `/ai-chat` | AI 追问对话 |
| Result | `/result` | 整理结果 |
| Image | `/image` | 图片生成 |
| Publish | `/publish` | 分享发布 |
| Square | `/square` | 梦境广场 |
| DreamDetail | `/dream-detail` | 梦境详情 |
| Profile | `/profile` | 个人主页 |

## 项目结构

```
lib/
├── main.dart              # 入口
├── theme/app_theme.dart   # 深色主题
├── models/
│   ├── dream.dart         # 梦境数据模型
│   └── chat_message.dart  # 聊天消息模型
├── providers/
│   ├── dream_provider.dart # 梦境状态管理
│   └── chat_provider.dart  # AI 对话状态
├── data/mock_data.dart     # 模拟数据
├── widgets/
│   └── bottom_nav.dart     # 底部导航栏
└── pages/                  # 12 个页面
```

## 后续扩展

- 接入真实 AI 后端（替换 MockData）
- 图片/视频生成 API
- 用户认证系统
- 云端数据同步
- 推送通知
