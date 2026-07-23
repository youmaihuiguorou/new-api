@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ========================================
echo      Gemini CLI 配置工具
echo ========================================
echo.

REM 设置 .gemini 文件夹路径
set "GEMINI_PATH=%USERPROFILE%\.gemini"

REM 创建 .gemini 文件夹
if not exist "%GEMINI_PATH%" (
    mkdir "%GEMINI_PATH%"
    echo [√] 已创建文件夹: %GEMINI_PATH%
) else (
    echo [!] 文件夹已存在: %GEMINI_PATH%
)

REM 检查是否已有配置
if exist "%GEMINI_PATH%\.env" (
    echo.
    echo [!] 警告: .env 文件已存在
    set /p "OVERWRITE=是否覆盖? (Y/N): "
    if /i not "!OVERWRITE!"=="Y" (
        echo [×] 已取消安装
        pause
        exit /b 1
    )
)

REM 创建 .env 文件
(
echo GOOGLE_GEMINI_BASE_URL=https://api.wukong.support
echo GEMINI_API_KEY=Paste your key obtained from wukong.support
echo GEMINI_MODEL=gemini-2.5-pro
) > "%GEMINI_PATH%\.env"
echo [√] 已创建文件: %GEMINI_PATH%\.env

REM 创建 settings.json
(
echo {
echo   "ide": {
echo     "enabled": true
echo   },
echo   "security": {
echo     "auth": {
echo       "selectedType": "gemini-api-key"
echo     }
echo   }
echo }
) > "%GEMINI_PATH%\settings.json"
echo [√] 已创建文件: %GEMINI_PATH%\settings.json

echo.
echo ========================================
echo 安装完成！
echo ========================================
echo.
echo 下一步操作：
echo 1. 访问 https://wukong.support 获取 API 密钥
echo 2. 编辑配置文件填入密钥:
echo    %GEMINI_PATH%\.env
echo.

set /p "OPEN=是否现在打开 .env 文件进行编辑? (Y/N): "
if /i "!OPEN!"=="Y" (
    notepad "%GEMINI_PATH%\.env"
)

echo.
echo 按任意键退出...
pause >nul
