@echo off
chcp 65001 >nul 2>&1
echo.
echo ========================================
echo    Claude Code 跳过登录配置脚本
echo ========================================
echo.

:: 检查 Node.js
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [X] 未检测到 Node.js，请手动配置：
    echo.
    echo [*] 文件路径:
    echo     %USERPROFILE%\.claude.json
    echo.
    echo [*] 添加内容:
    echo     {
    echo       "hasCompletedOnboarding": true
    echo     }
    echo.
    pause
    exit /b 1
)

echo [*] 正在配置...
echo.

node -e "const fs=require('fs'),p=require('os').homedir()+'/.claude.json';let c={};if(fs.existsSync(p)){const bak=p+'.bak';fs.copyFileSync(p,bak);console.log('[V] 已备份: '+bak);try{c=JSON.parse(fs.readFileSync(p,'utf8'));if(typeof c!=='object'||c===null)c={}}catch(e){console.log('[!] 原文件格式错误，创建新配置');c={}}}c.hasCompletedOnboarding=true;fs.writeFileSync(p,JSON.stringify(c,null,2));console.log('[V] 配置成功！');console.log('[V] 文件: '+p)"

echo.
echo [V] 完成！现在可以运行 claude 了
echo.
pause
