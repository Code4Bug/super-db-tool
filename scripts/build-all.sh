#!/bin/bash

# 跨平台构建脚本
# 用法: ./scripts/build-all.sh

set -e

echo "🚀 开始构建超级数据库管理工具..."

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查环境
echo -e "${BLUE}📋 检查构建环境...${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js 未安装${NC}"
    exit 1
fi

if ! command -v cargo &> /dev/null; then
    echo -e "${RED}❌ Rust 未安装${NC}"
    exit 1
fi

echo -e "${GREEN}✅ 环境检查通过${NC}"

# 安装依赖
echo -e "${BLUE}📦 安装依赖...${NC}"
npm install

# 清理旧构建
echo -e "${BLUE}🧹 清理旧构建...${NC}"
rm -rf src-tauri/target/release/bundle

# 构建
echo -e "${BLUE}🔨 开始构建...${NC}"
npm run tauri:build

# 检查构建结果
if [ -d "src-tauri/target/release/bundle" ]; then
    echo -e "${GREEN}✅ 构建成功！${NC}"
    echo -e "${BLUE}📦 安装包位置:${NC}"
    
    # 显示生成的文件
    if [ "$(uname)" == "Darwin" ]; then
        # macOS
        if [ -d "src-tauri/target/release/bundle/dmg" ]; then
            echo -e "  ${GREEN}DMG:${NC} $(ls src-tauri/target/release/bundle/dmg/*.dmg)"
        fi
        if [ -d "src-tauri/target/release/bundle/macos" ]; then
            echo -e "  ${GREEN}APP:${NC} $(ls -d src-tauri/target/release/bundle/macos/*.app)"
        fi
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Linux
        if [ -d "src-tauri/target/release/bundle/deb" ]; then
            echo -e "  ${GREEN}DEB:${NC} $(ls src-tauri/target/release/bundle/deb/*.deb)"
        fi
        if [ -d "src-tauri/target/release/bundle/appimage" ]; then
            echo -e "  ${GREEN}AppImage:${NC} $(ls src-tauri/target/release/bundle/appimage/*.AppImage)"
        fi
    elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
        # Windows
        if [ -d "src-tauri/target/release/bundle/msi" ]; then
            echo -e "  ${GREEN}MSI:${NC} $(ls src-tauri/target/release/bundle/msi/*.msi)"
        fi
    fi
    
    # 显示文件大小
    echo -e "${BLUE}📊 文件大小:${NC}"
    du -sh src-tauri/target/release/bundle/*
    
else
    echo -e "${RED}❌ 构建失败${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 构建完成！${NC}"
