# bot-cli.ps1
# Lightning AI BOT 統一指令接收器

# 設置編碼與日誌
chcp 65001 > $null
$logFile = "D:\Lightning-AI-ALL\command_log.txt"
$apiUrl = "http://127.0.0.1:8000"

# 確保日誌檔存在
if (-not (Test-Path $logFile)) {
    New-Item -ItemType File -Path $logFile -Force | Out-Null
}

function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] $Message"
    Add-Content -Path $logFile -Value $logEntry -Encoding UTF8
    Write-Host $logEntry -ForegroundColor Gray
}

function Show-Help {
    Write-Host ""
    Write-Host "📋 可用指令：" -ForegroundColor Cyan
    Write-Host "  start / 啟動          - 啟動 Control Tower API 與 USB 監聽服務" -ForegroundColor Yellow
    Write-Host "  stop / 停止           - 停止所有服務" -ForegroundColor Yellow
    Write-Host "  status / 狀態         - 顯示目前服務狀態" -ForegroundColor Yellow
    Write-Host "  deploy / 部署         - 掃描並部署 AI 到已連接的手機" -ForegroundColor Yellow
    Write-Host "  swarm / 蜂群          - 啟動 188 個 Agent 模擬" -ForegroundColor Yellow
    Write-Host "  devices / 裝置        - 顯示已註冊的裝置清單" -ForegroundColor Yellow
    Write-Host "  logs / 日誌           - 顯示最近 10 條指令紀錄" -ForegroundColor Yellow
    Write-Host "  help / 幫助 / ?       - 顯示此選單" -ForegroundColor Yellow
    Write-Host "  exit / 離開 / quit    - 結束 BOT 指令介面" -ForegroundColor Yellow
    Write-Host ""
}

function Invoke-Command {
    param([string]$Cmd)
    $cmdLower = $Cmd.ToLower().Trim()
    Write-Log "使用者輸入: $Cmd"
    
    switch -Wildcard ($cmdLower) {
        "start" { 
            Write-Host "🚀 啟動 Control Tower API 與 USB 服務..." -ForegroundColor Green
            # 檢查 API 是否已運行，若無則啟動
            try {
                $resp = Invoke-WebRequest -Uri "$apiUrl/health" -TimeoutSec 2 -ErrorAction Stop
                Write-Host "✅ API 已在運行" -ForegroundColor Green
            } catch {
                Write-Host "⚡ API 未運行，正在啟動..." -ForegroundColor Yellow
                Start-Job -ScriptBlock {
                    cd D:\Lightning-AI-ALL
                    python -m uvicorn control_tower.main:app --host 0.0.0.0 --port 8000
                } | Out-Null
                Start-Sleep -Seconds 3
            }
            # 啟動 USB 服務（若已安裝）
            python daemon\usb_watcher_service.py start 2>$null
            Write-Host "✅ 服務已啟動" -ForegroundColor Green
        }
        "stop" { 
            Write-Host "🛑 停止所有服務..." -ForegroundColor Red
            python daemon\usb_watcher_service.py stop 2>$null
            Get-Job | Stop-Job
            Write-Host "✅ 已停止" -ForegroundColor Red
        }
        "status" { 
            Write-Host "📊 檢查服務狀態..." -ForegroundColor Cyan
            # 檢查 API
            try {
                $resp = Invoke-WebRequest -Uri "$apiUrl/health" -TimeoutSec 2 -ErrorAction Stop
                Write-Host "  ✅ Control Tower API: 運行中" -ForegroundColor Green
            } catch {
                Write-Host "  ❌ Control Tower API: 未運行" -ForegroundColor Red
            }
            # 檢查 USB 服務
            $svc = Get-Service -Name "LightningUSBWatcher" -ErrorAction SilentlyContinue
            if ($svc -and $svc.Status -eq 'Running') {
                Write-Host "  ✅ USB 監聽服務: 運行中" -ForegroundColor Green
            } else {
                Write-Host "  ❌ USB 監聽服務: 未運行或未安裝" -ForegroundColor Red
            }
            # 顯示已註冊裝置
            try {
                $devices = Invoke-RestMethod -Uri "$apiUrl/devices" -TimeoutSec 2
                if ($devices.devices.Count -gt 0) {
                    Write-Host "  📱 已註冊裝置: $($devices.devices.Count) 台" -ForegroundColor Cyan
                    $devices.devices | ForEach-Object { Write-Host "     $($_.serial) - $($_.status) ($($_.registered_at))" }
                } else {
                    Write-Host "  📱 無已註冊裝置" -ForegroundColor Gray
                }
            } catch {
                Write-Host "  ⚠️ 無法取得裝置清單 (API 未回應)" -ForegroundColor Yellow
            }
        }
        "deploy" { 
            Write-Host "📲 掃描並部署 AI 到手機..." -ForegroundColor Magenta
            python daemon\adb_handler.py auto
        }
        "swarm" { 
            Write-Host "🐝 啟動 Swarm (188 Agents)..." -ForegroundColor Magenta
            try {
                $result = Invoke-RestMethod -Method Post -Uri "$apiUrl/swarm/start" -TimeoutSec 5
                Write-Host "✅ Swarm 已啟動: $($result.status)" -ForegroundColor Green
            } catch {
                Write-Host "❌ 無法啟動 Swarm (API 未回應)" -ForegroundColor Red
            }
        }
        "devices" { 
            Write-Host "📱 取得裝置清單..." -ForegroundColor Cyan
            try {
                $devices = Invoke-RestMethod -Uri "$apiUrl/devices" -TimeoutSec 2
                if ($devices.devices.Count -gt 0) {
                    $devices.devices | Format-Table serial, status, registered_at
                } else {
                    Write-Host "  無裝置" -ForegroundColor Gray
                }
            } catch {
                Write-Host "❌ 無法取得 (API 未回應)" -ForegroundColor Red
            }
        }
        "logs" { 
            Write-Host "📜 最近指令紀錄：" -ForegroundColor Cyan
            if (Test-Path $logFile) {
                Get-Content $logFile -Tail 10
            } else {
                Write-Host "  尚無紀錄" -ForegroundColor Gray
            }
        }
        "help" { Show-Help }
        "?" { Show-Help }
        "exit" { 
            Write-Host "👋 離開 BOT 指令介面" -ForegroundColor Green
            return $false 
        }
        default { 
            Write-Host "❓ 未知指令: $Cmd" -ForegroundColor Red
            Write-Host "   輸入 'help' 查看可用指令" -ForegroundColor Yellow
        }
    }
    return $true
}

# === 主程式 ===
Write-Host ""
Write-Host "⚡ Lightning AI BOT 指令中樞" -ForegroundColor Cyan
Write-Host "  輸入 'help' 查看指令，'exit' 離開" -ForegroundColor Yellow
Write-Host "  指令支援中英文 (例如 'start' 或 '啟動')" -ForegroundColor Gray
Write-Host ""

while ($true) {
    $input = Read-Host -Prompt "BOT> "
    if ($input -eq $null) { continue }
    $continue = Invoke-Command -Cmd $input
    if ($continue -eq $false) { break }
}