# 同步上游仓库并更新 custom 分支
# 定期运行此脚本以获取原作者的最新更新

param(
    [switch]$AutoMerge = $false,
    [switch]$SkipBuild = $false
)

$ErrorActionPreference = "Stop"
$RepoPath = "c:\GkDesktop\GitProjects\obsidian-enhancing-export"

Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    同步上游仓库并更新 custom 分支" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Set-Location $RepoPath

# 步骤 1：检查当前状态
Write-Host "📝 步骤 1/6: 检查当前状态..." -ForegroundColor Yellow

$status = git status --porcelain
if ($status) {
    Write-Host "❌ 工作目录有未提交的更改" -ForegroundColor Red
    Write-Host ""
    git status --short
    Write-Host ""
    Write-Host "请先提交或暂存更改：" -ForegroundColor Yellow
    Write-Host "   git add ." -ForegroundColor Gray
    Write-Host "   git commit -m 'save: Work in progress'" -ForegroundColor Gray
    exit 1
}
Write-Host "✓ 工作目录干净" -ForegroundColor Green

# 步骤 2：获取上游更新
Write-Host ""
Write-Host "📝 步骤 2/6: 获取上游更新..." -ForegroundColor Yellow

$upstreamExists = git remote | Select-String "upstream"
if (-not $upstreamExists) {
    Write-Host "   → 添加上游仓库..." -ForegroundColor Gray
    git remote add upstream https://github.com/mokeyish/obsidian-enhancing-export.git
}

git fetch upstream
Write-Host "✓ 已获取上游最新更改" -ForegroundColor Green

# 检查是否有新提交
$localCommit = git rev-parse main
$upstreamCommit = git rev-parse upstream/main

if ($localCommit -eq $upstreamCommit) {
    Write-Host "✓ main 分支已是最新" -ForegroundColor Green
    $hasUpdates = $false
}
else {
    Write-Host "⚠ 发现上游新提交" -ForegroundColor Yellow
    $hasUpdates = $true
}

# 步骤 3：更新 main 分支
if ($hasUpdates) {
    Write-Host ""
    Write-Host "📝 步骤 3/6: 更新 main 分支..." -ForegroundColor Yellow
    
    git checkout main
    git merge upstream/main --ff-only
    git push origin main
    
    Write-Host "✓ main 分支已更新并推送" -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "📝 步骤 3/6: 跳过（main 已是最新）" -ForegroundColor Yellow
}

# 步骤 4：合并到 custom 分支
Write-Host ""
Write-Host "📝 步骤 4/6: 合并更新到 custom 分支..." -ForegroundColor Yellow

git checkout custom

if ($hasUpdates) {
    Write-Host "   → 合并 main 到 custom..." -ForegroundColor Gray
    
    if ($AutoMerge) {
        try {
            git merge main --no-edit
            Write-Host "✓ 自动合并成功" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ 自动合并失败，存在冲突" -ForegroundColor Red
            Write-Host ""
            Write-Host "冲突文件:" -ForegroundColor Yellow
            git diff --name-only --diff-filter=U
            Write-Host ""
            Write-Host "请手动解决冲突后执行：" -ForegroundColor Yellow
            Write-Host "   git add ." -ForegroundColor Gray
            Write-Host "   git commit -m 'merge: Sync with upstream'" -ForegroundColor Gray
            Write-Host "   git push origin custom" -ForegroundColor Gray
            exit 1
        }
    }
    else {
        Write-Host "   提示：运行以下命令手动合并（推荐先检查更改）：" -ForegroundColor Cyan
        Write-Host "   git merge main" -ForegroundColor White
        Write-Host ""
        Write-Host "   或使用 -AutoMerge 参数自动合并" -ForegroundColor Gray
        Read-Host "按 Enter 继续自动合并，或 Ctrl+C 取消"
        
        try {
            git merge main --no-edit
            Write-Host "✓ 合并成功" -ForegroundColor Green
        }
        catch {
            Write-Host "❌ 合并失败，存在冲突（见上方）" -ForegroundColor Red
            exit 1
        }
    }
}
else {
    Write-Host "✓ custom 分支已是最新" -ForegroundColor Green
}

# 步骤 5：编译
if (-not $SkipBuild) {
    Write-Host ""
    Write-Host "📝 步骤 5/6: 编译插件..." -ForegroundColor Yellow
    
    npm run build
    Write-Host "✓ 编译完成" -ForegroundColor Green
}
else {
    Write-Host ""
    Write-Host "📝 步骤 5/6: 跳过编译 (使用 -SkipBuild)" -ForegroundColor Yellow
}

# 步骤 6：推送
Write-Host ""
Write-Host "📝 步骤 6/6: 推送到 GitHub..." -ForegroundColor Yellow

git push origin custom
Write-Host "✓ custom 分支已推送" -ForegroundColor Green

# 完成总结
Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "    ✅ 同步完成！" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# 显示版本信息
$manifest = Get-Content "manifest.json" | ConvertFrom-Json
Write-Host "当前版本: $($manifest.version)" -ForegroundColor Yellow
Write-Host ""

if ($hasUpdates) {
    Write-Host "📊 上游更新日志:" -ForegroundColor Yellow
    git log --oneline main~5..main
    Write-Host ""
}

Write-Host "🎯 后续操作:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. 如果使用 BRAT，它会自动检测并更新" -ForegroundColor Gray
Write-Host "2. 如果手动部署，运行部署脚本:" -ForegroundColor Gray
Write-Host "   .\deploy-to-obsidian.ps1" -ForegroundColor White
Write-Host "3. 可选：在 GitHub 创建新 Release" -ForegroundColor Gray
Write-Host ""
