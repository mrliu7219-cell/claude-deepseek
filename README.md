# Claude Desktop + DeepSeek 配置工具

> [English](README_EN.md)

一键配置 Claude Desktop 使用 DeepSeek 作为第三方推理引擎。

## 这是做什么的

Claude Desktop 官方只支持 Anthropic 的 API。这个项目通过 Claude Desktop 的开发者模式（Developer Mode），将其接入 DeepSeek 的 Anthropic 兼容 API，让你可以用 DeepSeek 的模型运行 Claude Desktop（Cowork + Code 模式）。

## 前置准备

- macOS 电脑
- 一个 [DeepSeek API Key](https://platform.deepseek.com/api_keys)
- Claude Desktop 1.6608.2 版本（最新版已限制第三方推理功能，需要特定版本）

## 使用方法

### 1. 安装 Claude Desktop

确保 `/Applications/Claude.app` 已安装。需要 **1.6608.2 版本**（2026年5月10日发布，后续版本已限制第三方推理功能）。

> 此版本已无法从官方渠道下载。如有需要请邮件联系：mrliu7219@gmail.com

### 2. 运行安装脚本

```bash
# 给执行权限（如果双击没反应）
chmod +x install-deepseek.command

# 双击运行，或终端执行
./install-deepseek.command
```

脚本会引导你完成以下步骤：

| 步骤 | 操作 | 方式 |
|------|------|------|
| 1 | 输入 DeepSeek API Key | 自动（首次输入后保存，下次复用） |
| 2 | 检查 Claude 安装 | 自动 |
| 3 | 禁用自动更新 | 自动 |
| 4 | 开启开发者模式 | 手动 |
| 5 | 退出 Claude → 设置环境变量 | 手动退出后自动 |
| 6 | 打开 Claude → 配置 Gateway | 手动（UI 填写） |
| 7 | 设置权限模式 | 手动 |

全程约 5 分钟。

### 3. 验证

发一条消息，能正常回复就配置成功了。

## 工作原理

新版本 Claude Desktop 限制了自定义模型名称，必须设置 `NODE_ENV=production` 才能使用 DeepSeek 模型名。

```
Claude Desktop
    │
    ├─ deploymentMode: "3p"        → 第三方推理模式
    │
    ├─ LaunchAgent
    │   └─ NODE_ENV=production     → 允许直接使用 DeepSeek 模型名称
    │
    └─ Gateway: api.deepseek.com/anthropic
        └─ 在 UI 中配置的模型:
            deepseek-v4-pro   → 对应 Opus 级别
            deepseek-v4-flash → 对应 Sonnet 级别
```

## 重装快速恢复

下次重装只需双击 `install-deepseek.command`，API Key 已保存在 `~/.claude-deepseek.env`，无需重复输入。

## 注意事项

- **不要升级 Claude Desktop** — 新版本限制了第三方推理功能
- **不要登录 Anthropic 账号** — 登录后消息会走 Anthropic 服务器
- 首次使用 Code 模式需要梯子下载 Claude Code CLI
- Cowork 模式不需要梯子

## 文件说明

```
├── install-deepseek.command   # 安装脚本（双击运行）
├── README.md                  # 中文说明
└── README_EN.md               # English guide
```

## 相关项目

- [claude-desktop-zh-cn](https://github.com/javaht/claude-desktop-zh-cn) — Claude Desktop 中文汉化补丁
- [DeepSeek API 文档](https://api-docs.deepseek.com/zh-cn/)

## License

MIT
