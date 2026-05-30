#!/bin/bash
set -euo pipefail

LAUNCH_AGENT="$HOME/Library/LaunchAgents/com.claude.env.plist"
ENV_FILE="$HOME/.claude-deepseek.env"

# ── 读取或输入 API Key ─────────────────────────────
load_api_key() {
  if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
    echo "  ✅ 已读取保存的 API Key: ${DEEPSEEK_API_KEY:0:8}..."
  else
    echo ""
    echo "请输入你的 DeepSeek API Key（在 https://platform.deepseek.com/api_keys 申请）"
    read -rp "API Key: " DEEPSEEK_API_KEY
    if [ -z "$DEEPSEEK_API_KEY" ]; then
      echo "  ❌ API Key 不能为空"
      exit 1
    fi
    echo "DEEPSEEK_API_KEY=$DEEPSEEK_API_KEY" > "$ENV_FILE"
    chmod 600 "$ENV_FILE"
    echo "  ✅ 已保存到 $ENV_FILE（仅本机可读）"
  fi
}

echo "=============================================="
echo "  Claude Desktop + DeepSeek 配置脚本"
echo "=============================================="
echo ""

# ── API Key ────────────────────────────────────────
load_api_key
echo ""

# ── 检查 Claude 安装 ──────────────────────────────
echo "【1/6】检查 Claude Desktop..."
if [ -d "/Applications/Claude.app" ]; then
  echo "  ✅ Claude.app 已安装"
else
  echo "  ⚠️  未检测到 Claude.app"
  echo "  请先安装 Claude Desktop，再重新运行此脚本。"
  echo ""
  read -rp "安装好后回车继续（或按 Ctrl+C 退出）: " _
  if [ ! -d "/Applications/Claude.app" ]; then
    echo "  ❌ 仍未检测到，退出"
    exit 1
  fi
fi
echo ""

# ── 禁用自动更新 ──────────────────────────────────
echo "【2/6】禁用自动更新..."
defaults write com.anthropic.claudefordesktop SUEnableAutomaticChecks -bool false
echo "  ✅ 已禁用"
echo ""

# ── 开梯子 ────────────────────────────────────────
echo "【3/6】开梯子了吗？"
echo "首次使用 Claude Code 模式需要梯子下载 CLI。"
read -rp "已开梯子请回车继续: " _
echo ""

# ── 开启开发者模式 ────────────────────────────────
echo "【4/6】开启开发者模式"
echo ""
echo "  1. 打开 Claude Desktop"
echo "  2. 菜单栏: Help → Troubleshooting → Enable Developer Mode"
echo "  （Claude 会自动重启）"
echo ""
read -rp "  完成后回车继续: " _
echo ""

# ── 设置环境变量 ──────────────────────────────────
echo "【5/6】设置环境变量（使 DeepSeek 模型名可用）"
echo "  ⚠️  请先退出 Claude Desktop（菜单栏 Claude → Quit）"
echo ""
read -rp "  已退出请回车继续: " _
echo ""

echo "  创建 LaunchAgent（重启后自动设置 NODE_ENV=production）..."
mkdir -p "$HOME/Library/LaunchAgents"
cat > "$LAUNCH_AGENT" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.claude.env</string>
    <key>ProgramArguments</key>
    <array>
        <string>launchctl</string>
        <string>setenv</string>
        <string>NODE_ENV</string>
        <string>production</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
</dict>
</plist>
PLIST

echo "  设置当前会话环境变量..."
launchctl setenv NODE_ENV production 2>/dev/null && echo "  ✅ 环境变量已生效" || echo "  ⚠️  设置失败，重启 Mac 后再进行下一步"
echo ""

# ── 配置 DeepSeek Gateway ─────────────────────────
echo "【6/6】配置 DeepSeek 第三方推理"
echo ""
echo "  1. 打开 Claude Desktop"
echo "  2. 菜单栏: Developer → Configure Third-Party Inference…"
echo ""
echo "  填写参数："
echo "  ┌─────────────────────────────────────────────┐"
echo "  │ Connection     Gateway                      │"
echo "  │ Base URL       https://api.deepseek.com     │"
echo "  │                /anthropic                   │"
echo "  │ API Key        ${DEEPSEEK_API_KEY:0:8}...                    │"
echo "  │ Auth scheme    bearer                       │"
echo "  ├─────────────────────────────────────────────┤"
echo "  │ 模型:                                       │"
echo "  │   deepseek-v4-pro   ☑ 1M-context            │"
echo "  │   deepseek-v4-flash ☑ 1M-context            │"
echo "  └─────────────────────────────────────────────┘"
echo ""
echo "  3. 点击 Apply locally → 自动重启"
echo "  4. 重启后选择 Continue with Gateway → Local configuration"
echo ""
read -rp "  完成后回车继续: " _
echo ""

# ── 完成 ──────────────────────────────────────────
echo "=============================================="
echo "  配置完成！最后一步手动设置："
echo "=============================================="
echo ""
echo "进入 Code 模式后，右下角权限按钮选第 4 个："
echo "  绕过权限 — 啥都不问，直接干"
echo ""
echo "以后重装双击脚本就行，API Key 已保存。"
echo ""
echo "按回车退出。"
read -r _
