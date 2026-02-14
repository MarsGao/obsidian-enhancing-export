# 部署插件到 Obsidian
# 将编译后的插件复制到 Obsidian vault

param(
    [string]$VaultPath = "C:\GkDesktop\GitProjects\GkObsidian"
)

$ErrorActionPreference = "Stop"
$RepoPath = Split-Path -Parent $PSCommandPath

Write-Host "📦 部署插件到 Obsidian" -ForegroundColor Cyan
Write-Host ""

# 检查编译产物
$requiredFiles = @("main.js", "manifest.json", "styles.css")
$missingFiles = @()

foreach ($file in $requiredFiles) {
    $filePath = Join-Path $RepoPath $file
    if (-not (Test-Path $filePath)) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "❌ 缺少必要文件，需要先编译:" -ForegroundColor Red
    $missingFiles | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    Write-Host ""
    Write-Host "执行: npm run build" -ForegroundColor Gray
    exit 1
}

# 确定插件目录
$pluginDir = Join-Path $VaultPath ".obsidian\plugins\obsidian-enhancing-export"

# 检查目录是否存在
if (-not (Test-Path $pluginDir)) {
    Write-Host "⚠ 插件目录不存在，创建中..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $pluginDir -Force | Out-Null
    Write-Host "✓ 已创建插件目录" -ForegroundColor Green
}

Write-Host "目标: $pluginDir" -ForegroundColor Gray
Write-Host ""

# 复制核心文件
Write-Host "→ 复制核心文件..." -ForegroundColor Gray
Copy-Item (Join-Path $RepoPath "main.js") $pluginDir -Force
Copy-Item (Join-Path $RepoPath "manifest.json") $pluginDir -Force
Copy-Item (Join-Path $RepoPath "styles.css") $pluginDir -Force
Write-Host "✓ 核心文件已复制" -ForegroundColor Green

# 复制 lua 目录
$luaSourceDir = Join-Path $RepoPath "lua"
$luaTargetDir = Join-Path $pluginDir "lua"

if (Test-Path $luaSourceDir) {
    Write-Host "→ 复制 Lua 过滤器..." -ForegroundColor Gray
    
    if (-not (Test-Path $luaTargetDir)) {
        New-Item -ItemType Directory -Path $luaTargetDir -Force | Out-Null
    }
    
    Copy-Item "$luaSourceDir\*" $luaTargetDir -Force -Recurse
    Write-Host "✓ Lua 过滤器已复制" -ForegroundColor Green
}

# 显示版本信息
$manifest = Get-Content (Join-Path $pluginDir "manifest.json") | ConvertFrom-Json
$version = $manifest.version
$name = $manifest.name

Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✅ 部署完成！" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "插件: $name" -ForegroundColor Yellow
Write-Host "版本: $version" -ForegroundColor Yellow
Write-Host "位置: $pluginDir" -ForegroundColor Yellow
Write-Host ""
Write-Host "🔄 请在 Obsidian 中重新加载插件：" -ForegroundColor Cyan
Write-Host "   Ctrl+P → '重新加载应用（不保存）'" -ForegroundColor Gray
Write-Host "   或者" -ForegroundColor Gray
Write-Host "   设置 → 社区插件 → 关闭/开启该插件" -ForegroundColor Gray
Write-Host ""
