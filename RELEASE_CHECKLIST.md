# 发布清单

在发布新版本前，请确保完成以下步骤：

## 发布前准备

### 1. 版本更新
- [ ] 更新 `package.json` 中的版本号
- [ ] 更新 `src-tauri/tauri.conf.json` 中的版本号
- [ ] 更新 `src-tauri/Cargo.toml` 中的版本号

### 2. 文档更新
- [ ] 更新 `CHANGELOG.md` 添加新版本的变更记录
- [ ] 更新 `README.md`（如有必要）
- [ ] 检查所有文档链接是否有效

### 3. 代码质量
- [ ] 运行 `npm run lint` 检查代码规范
- [ ] 运行 `npm run format` 格式化代码
- [ ] 确保所有测试通过
- [ ] 代码审查完成

### 4. 功能测试
- [ ] 在开发模式下测试所有功能
- [ ] 测试数据库连接功能
- [ ] 测试查询执行功能
- [ ] 测试 ETL 同步功能
- [ ] 测试 UI 响应性

## 构建和测试

### 5. 本地构建测试
- [ ] macOS 构建测试
  ```bash
  npm run tauri:build
  # 测试 DMG 安装和运行
  ```
- [ ] Windows 构建测试
  ```bash
  npm run tauri:build
  # 测试 MSI 安装和运行
  ```
- [ ] Linux 构建测试
  ```bash
  npm run tauri:build
  # 测试 DEB/AppImage 安装和运行
  ```

### 6. 安装包验证
- [ ] 验证安装包大小合理（< 100MB）
- [ ] 验证应用图标正确显示
- [ ] 验证应用名称和版本信息
- [ ] 测试全新安装
- [ ] 测试升级安装（如适用）
- [ ] 测试卸载流程

### 7. 功能验证
- [ ] 应用启动正常
- [ ] 所有菜单项可用
- [ ] 窗口大小和位置正确
- [ ] 主题切换正常
- [ ] 数据持久化正常

## 代码签名（可选）

### 8. macOS 签名
- [ ] 配置开发者证书
- [ ] 签名应用
- [ ] 公证（Notarization）
- [ ] 验证签名

### 9. Windows 签名
- [ ] 配置代码签名证书
- [ ] 签名 MSI 安装包
- [ ] 验证签名

## 发布

### 10. Git 操作
- [ ] 提交所有更改
  ```bash
  git add .
  git commit -m "chore: release v0.1.0"
  ```
- [ ] 创建版本标签
  ```bash
  git tag v0.1.0
  git push origin main
  git push origin v0.1.0
  ```

### 11. GitHub Release
- [ ] 在 GitHub 创建新 Release
- [ ] 填写 Release 标题：`v0.1.0 - 版本名称`
- [ ] 复制 CHANGELOG 内容到 Release 说明
- [ ] 上传构建的安装包：
  - [ ] macOS DMG
  - [ ] Windows MSI
  - [ ] Linux DEB
  - [ ] Linux AppImage
- [ ] 添加 SHA256 校验和
- [ ] 发布 Release

### 12. 自动化构建（如使用 GitHub Actions）
- [ ] 推送标签触发 CI/CD
- [ ] 等待所有平台构建完成
- [ ] 验证自动生成的 Release
- [ ] 下载并测试所有平台的安装包

## 发布后

### 13. 验证发布
- [ ] 验证 GitHub Release 页面
- [ ] 测试下载链接
- [ ] 验证安装包完整性

### 14. 通知和宣传
- [ ] 更新项目主页
- [ ] 发布更新公告
- [ ] 通知用户（如适用）
- [ ] 更新社交媒体

### 15. 监控
- [ ] 监控下载量
- [ ] 收集用户反馈
- [ ] 跟踪问题报告
- [ ] 准备热修复（如需要）

## 版本号规范

遵循语义化版本（Semantic Versioning）：

- **主版本号（Major）**: 不兼容的 API 修改
- **次版本号（Minor）**: 向下兼容的功能性新增
- **修订号（Patch）**: 向下兼容的问题修正

示例：
- `1.0.0` - 首个稳定版本
- `1.1.0` - 新增功能
- `1.1.1` - 修复 bug
- `2.0.0` - 重大更新

## 快速命令

```bash
# 更新版本号（使用 npm）
npm version patch  # 0.1.0 -> 0.1.1
npm version minor  # 0.1.0 -> 0.2.0
npm version major  # 0.1.0 -> 1.0.0

# 构建所有平台
./scripts/build-all.sh  # macOS/Linux
scripts\build-all.bat   # Windows

# 创建标签并推送
git tag v0.1.0
git push origin v0.1.0

# 生成 SHA256 校验和
# macOS/Linux
shasum -a 256 src-tauri/target/release/bundle/**/*

# Windows
certutil -hashfile path\to\file SHA256
```

## 回滚计划

如果发布出现严重问题：

1. 立即在 GitHub Release 标记为 Pre-release
2. 发布紧急通知
3. 准备热修复版本
4. 如无法快速修复，撤回 Release
5. 恢复到上一个稳定版本

## 注意事项

- 始终在发布前进行充分测试
- 保持 CHANGELOG 更新
- 确保所有文档同步更新
- 备份重要数据
- 准备回滚方案
