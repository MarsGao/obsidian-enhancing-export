# Obsidian Enhancing Export - 自定义版本

这是 [obsidian-enhancing-export](https://github.com/mokeyish/obsidian-enhancing-export) 插件的个人自定义版本，包含以下增强功能：

## 🎯 自定义内容

### 1. 核心 Bug 修复
- **文件**: `src/exporto0o.ts` (第95行)
- **问题**: 修复当 Markdown 文件没有内部链接时的空指针崩溃
- **状态**: 已提交 [PR #318](https://github.com/mokeyish/obsidian-enhancing-export/pull/318)

### 2. 中文文档导出增强
新增两个 Pandoc Lua 过滤器，优化中文 Word 文档导出体验：

#### `lua/newline_to_para.lua`
- **功能**: 将 Markdown 换行转换为 Word 段落分隔（Enter）
- **原因**: 中文写作习惯中，换行表示段落分隔

#### `lua/shift_headings.lua`
- **功能**: 调整标题层级映射
  - Markdown `#` → Word "标题" (Title)
  - Markdown `##` → Word "标题 1" (Heading 1)
- **原因**: 适配中文 Word 模板习惯

**状态**: 已提交 [PR #319](https://github.com/mokeyish/obsidian-enhancing-export/pull/319)

---

## 📂 项目结构

```
obsidian-enhancing-export/
├── docs/                              # 📚 项目文档
│   ├── Fork维护与插件更新机制详解.md    # 详细技术文档
│   ├── 快速参考-维护自定义插件版本.md   # 速查手册
│   ├── obsidian-enhancing-export-中文优化指南.md
│   └── PR-提交完成总结.md
├── src/                               # 源代码
├── lua/                               # Lua 过滤器
│   ├── newline_to_para.lua           # 换行处理
│   └── shift_headings.lua            # 标题映射
├── setup-custom-branch.ps1            # 初始化脚本
├── sync-upstream.ps1                  # 同步上游更新
└── deploy-to-obsidian.ps1             # 部署到 Obsidian
```

---

## 🚀 快速开始

### 方式 A：使用 BRAT 插件（推荐）

1. **在 Obsidian 安装 BRAT 插件**
2. **添加此仓库**:
   - 设置 → Community plugins → BRAT → Add Beta plugin
   - 仓库: `MarsGao/obsidian-enhancing-export`
   - 分支: `custom`

### 方式 B：手动部署

```powershell
# 克隆仓库
git clone https://github.com/MarsGao/obsidian-enhancing-export.git
cd obsidian-enhancing-export
git checkout custom

# 编译
npm install
npm run build

# 部署到 Obsidian
.\deploy-to-obsidian.ps1
```

---

## 🔄 维护与更新

### 同步上游更新

```powershell
cd c:\GkDesktop\GitProjects\obsidian-enhancing-export
.\sync-upstream.ps1
```

此脚本会：
1. ✅ 从上游获取最新更新
2. ✅ 合并到 custom 分支（保留自定义修改）
3. ✅ 编译并推送到 GitHub
4. ✅ BRAT 自动检测并更新

---

## 📊 分支说明

| 分支 | 用途 | 说明 |
|------|------|------|
| `main` | 镜像上游 | 与原仓库保持同步，只读 |
| `custom` | 生产版本 | 包含所有自定义修改 + 上游更新 |
| `fix/*` | Bug 修复 | 用于提交 PR |
| `feature/*` | 功能增强 | 用于提交 PR |

---

## 📖 详细文档

- **[Fork 维护与插件更新机制详解](docs/Fork维护与插件更新机制详解.md)** - 完整技术文档（7000字）
- **[快速参考](docs/快速参考-维护自定义插件版本.md)** - 常用命令速查
- **[中文优化指南](docs/obsidian-enhancing-export-中文优化指南.md)** - 功能说明

---

## 🔗 相关链接

- **原始仓库**: https://github.com/mokeyish/obsidian-enhancing-export
- **PR #318** (Bug 修复): https://github.com/mokeyish/obsidian-enhancing-export/pull/318
- **PR #319** (中文增强): https://github.com/mokeyish/obsidian-enhancing-export/pull/319

---

## 📝 License

本项目遵循原项目的 GPL-3.0 license。

---

## 🙏 致谢

感谢 [mokeyish](https://github.com/mokeyish) 创建并维护原项目。
