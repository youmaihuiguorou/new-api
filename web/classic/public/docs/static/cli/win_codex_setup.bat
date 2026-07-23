@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo Codex 配置文件一键创建工具
echo ========================================
echo.

REM 设置 .codex 文件夹路径
set "CODEX_PATH=%USERPROFILE%\.codex"

REM 创建 .codex 文件夹
if not exist "%CODEX_PATH%" (
    mkdir "%CODEX_PATH%"
    echo [√] 已创建文件夹: %CODEX_PATH%
) else (
    echo [!] 文件夹已存在: %CODEX_PATH%
)

REM 创建 config.toml
(
echo model_provider = "wukong"
echo model = "gpt-5.1-codex"
echo model_reasoning_effort = "high"
echo network_access = "enabled"
echo disable_response_storage = true
echo.
echo [model_providers.wukong]
echo name = "wukong"
echo base_url = "https://api.wukong.support/v1"
echo wire_api = "responses"
echo requires_openai_auth = true
) > "%CODEX_PATH%\config.toml"
echo [√] 已创建文件: %CODEX_PATH%\config.toml

REM 创建 auth.json
(
echo {
echo   "OPENAI_API_KEY": "Paste your key obtained from wukong.support"
echo }
) > "%CODEX_PATH%\auth.json"
echo [√] 已创建文件: %CODEX_PATH%\auth.json

echo.
echo ========================================
echo 设置完成!
echo 请编辑以下文件，填入您的 API 密钥:
echo %CODEX_PATH%\auth.json
echo ========================================
echo.

set /p "OPEN=是否现在打开 auth.json 文件进行编辑? (Y/N): "
if /i "!OPEN!"=="Y" (
    notepad "%CODEX_PATH%\auth.json"
)

pause
