@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo   Claude Code 配置工具
echo ========================================
echo.

REM 设置 .claude 文件夹路径
set "CLAUDE_PATH=%USERPROFILE%\.claude"

REM 创建 .claude 文件夹
if not exist "%CLAUDE_PATH%" (
    mkdir "%CLAUDE_PATH%"
    echo [√] 已创建文件夹: %CLAUDE_PATH%
) else (
    echo [!] 文件夹已存在: %CLAUDE_PATH%
)

REM 检查是否已有配置
if exist "%CLAUDE_PATH%\settings.json" (
    echo.
    echo [!] 警告: settings.json 已存在
    set /p "OVERWRITE=是否覆盖? (Y/N): "
    if /i not "!OVERWRITE!"=="Y" (
        echo [×] 已取消安装
        pause
        exit /b 1
    )
)

REM 创建 settings.json
(
echo {
echo   "env": {
echo     "ANTHROPIC_AUTH_TOKEN": "sk-xxx",
echo     "ANTHROPIC_BASE_URL": "https://api.wukong.support"
echo   }
echo }
) > "%CLAUDE_PATH%\settings.json"
echo [√] 已创建文件: %CLAUDE_PATH%\settings.json

echo.
echo ========================================
echo 安装完成！
echo ========================================
echo.
echo 下一步操作：
echo 1. 访问 https://wukong.support 获取 API 密钥
echo 2. 编辑配置文件填入密钥:
echo    %CLAUDE_PATH%\settings.json
echo.

set /p "OPEN=是否现在打开 settings.json 进行编辑? (Y/N): "
if /i "!OPEN!"=="Y" (
    notepad "%CLAUDE_PATH%\settings.json"
)

echo.
echo 按任意键退出...
pause >nul
