@echo off
REM 跨平台构建脚本 (Windows)
REM 用法: scripts\build-all.bat

echo 🚀 开始构建超级数据库管理工具...

REM 检查环境
echo 📋 检查构建环境...

where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Node.js 未安装
    exit /b 1
)

where cargo >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Rust 未安装
    exit /b 1
)

echo ✅ 环境检查通过

REM 安装依赖
echo 📦 安装依赖...
call npm install

REM 清理旧构建
echo 🧹 清理旧构建...
if exist "src-tauri\target\release\bundle" (
    rmdir /s /q "src-tauri\target\release\bundle"
)

REM 构建
echo 🔨 开始构建...
call npm run tauri:build

REM 检查构建结果
if exist "src-tauri\target\release\bundle" (
    echo ✅ 构建成功！
    echo 📦 安装包位置:
    
    if exist "src-tauri\target\release\bundle\msi" (
        dir /b "src-tauri\target\release\bundle\msi\*.msi"
    )
    
    if exist "src-tauri\target\release\bundle\nsis" (
        dir /b "src-tauri\target\release\bundle\nsis\*.exe"
    )
    
    echo 📊 文件大小:
    dir "src-tauri\target\release\bundle"
    
    echo 🎉 构建完成！
) else (
    echo ❌ 构建失败
    exit /b 1
)
