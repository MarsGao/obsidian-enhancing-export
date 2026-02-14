# 快速设置：维护您的自定义 Obsidian 插件版本
# 执行此脚本完成初始化设置

param(
    [string]$ObsidianVaultPath = "C:\GkDesktop\GitProjects\GkObsidian",
    [switch]$SkipBuild = $false
)

$ErrorActionPreference = "Stop"
$RepoPath = "C:\GkDesktop\GitProjects\obsidian-enhancing-export"

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    Obsidian 插件自定义版本维护 - 初始化设置" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# 步骤 1：创建并设置 custom 分支
Write-Host "📝 步骤 1/5: 创建 custom 分支..." -ForegroundColor Yellow
Set-Location $RepoPath

# 检查是否已有 custom 分支
$customExists = git branch --list custom
if ($customExists) {
    Write-Host "   ✓ custom 分支已存在" -ForegroundColor Green
    git checkout custom
}
else {
    Write-Host "   → 创建新的 custom 分支..." -ForegroundColor Gray
    git checkout -b custom
    Write-Host "   ✓ custom 分支创建完成" -ForegroundColor Green
}

# 步骤 2：合并您的修改
Write-Host ""
Write-Host "📝 步骤 2/5: 合并您的修改到 custom 分支..." -ForegroundColor Yellow

# 检查是否已合并 feature 分支
$featureMerged = git log --oneline --grep="chinese-enhancements"
if ($featureMerged) {
    Write-Host "   ✓ 中文增强功能已合并" -ForegroundColor Green
}
else {
    Write-Host "   → 合并 feature/chinese-enhancements..." -ForegroundColor Gray
    try {
        git merge feature/chinese-enhancements --no-edit
        Write-Host "   ✓ 合并成功" -ForegroundColor Green
    }
    catch {
        Write-Host "   ⚠ 合并时出现冲突，需要手动解决" -ForegroundColor Red
        Write-Host "   执行以下命令解决冲突后继续：" -ForegroundColor Yellow
        Write-Host "   git add ." -ForegroundColor Gray
        Write-Host "   git commit -m 'merge: Add Chinese enhancements'" -ForegroundColor Gray
        exit 1
    }
}

# 步骤 3：添加上游仓库
Write-Host ""
Write-Host "📝 步骤 3/5: 配置上游仓库..." -ForegroundColor Yellow

$upstreamExists = git remote | Select-String "upstream"
if ($upstreamExists) {
    Write-Host "   ✓ 上游仓库已配置" -ForegroundColor Green
}
else {
    git remote add upstream https://github.com/mokeyish/obsidian-enhancing-export.git
    Write-Host "   ✓ 已添加上游仓库: mokeyish/obsidian-enhancing-export" -ForegroundColor Green
}

git fetch upstream
Write-Host "   ✓ 已获取上游最新更新" -ForegroundColor Green

# 步骤 4：编译插件
if (-not $SkipBuild) {
    Write-Host ""
    Write-Host "📝 步骤 4/5: 编译插件..." -ForegroundColor Yellow
    
    if (-not (Test-Path "node_modules")) {
        Write-Host "   → 安装依赖..." -ForegroundColor Gray
        npm install
    }
    
    Write-Host "   → 编译中..." -ForegroundColor Gray
    npm run build
    Write-Host "   ✓ 编译完成" -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "📝 步骤 4/5: 跳过编译 (使用 -SkipBuild)" -ForegroundColor Yellow
}

# 步骤 5：推送到 GitHub
Write-Host ""
Write-Host "📝 步骤 5/5: 推送 custom 分支到 GitHub..." -ForegroundColor Yellow

try {
    git push -u origin custom
    Write-Host "   ✓ custom 分支已推送到您的 Fork" -ForegroundColor Green
}
catch {
    Write-Host "   ⚠ 推送失败，可能需要先拉取远程更改" -ForegroundColor Yellow
    Write-Host "   执行: git pull origin custom --rebase" -ForegroundColor Gray
}

# 完成总结
Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    ✅ 初始化设置完成！" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "📊 当前分支结构：" -ForegroundColor Yellow
git branch -a | Select-String "main|custom|feature"

Write-Host ""
Write-Host "🎯 接下来的步骤：" -ForegroundColor Yellow
Write-Host ""
Write-Host "1️⃣  在 GitHub 创建 Release（可选）：" -ForegroundColor Cyan
Write-Host "   访问: https://github.com/MarsGao/obsidian-enhancing-export/releases/new" -ForegroundColor Gray
Write-Host "   Tag: v1.10.11-custom.1" -ForegroundColor Gray
Write-Host "   分支: custom" -ForegroundColor Gray
Write-Host "   上传: main.js, manifest.json, styles.css" -ForegroundColor Gray
Write-Host ""

Write-Host "2️⃣  安装 BRAT 插件（推荐）：" -ForegroundColor Cyan
Write-Host "   a. 在 Obsidian 中安装 'BRAT' 插件" -ForegroundColor Gray
Write-Host "   b. 设置 → Community plugins → BRAT" -ForegroundColor Gray
Write-Host "   c. 添加 Beta 插件:" -ForegroundColor Gray
Write-Host "      仓库: MarsGao/obsidian-enhancing-export" -ForegroundColor White
Write-Host "      分支: custom" -ForegroundColor White
Write-Host ""

Write-Host "3️⃣  或者手动部署到 Obsidian：" -ForegroundColor Cyan
Write-Host "   运行部署脚本:" -ForegroundColor Gray
$deployScript = Join-Path $PSScriptRoot "deploy-to-obsidian.ps1"
Write-Host "   .\deploy-to-obsidian.ps1" -ForegroundColor White
Write-Host ""

Write-Host "4️⃣  后续同步上游更新：" -ForegroundColor Cyan
Write-Host "   运行同步脚本:" -ForegroundColor Gray
Write-Host "   .\sync-upstream.ps1" -ForegroundColor White
Write-Host ""

Write-Host "📖 详细文档: Fork维护与插件更新机制详解.md" -ForegroundColor Yellow
Write-Host ""
