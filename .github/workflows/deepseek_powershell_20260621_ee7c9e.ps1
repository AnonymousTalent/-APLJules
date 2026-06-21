# start_bot.ps1
param([string]$Action = "start")

function Start-BOT {
    Write-Host "⚡ 啟動 Lightning AI BOT 全系統..." -ForegroundColor Cyan
    # 啟動 Control Tower API（背景）
    Write-Host "[1/3] 啟動 Control Tower API..." -ForegroundColor Green
    $apiJob = Start-Job -ScriptBlock {
        cd D:\Lightning-AI-ALL
        python -m uvicorn control_tower.main:app --host 0.0.0.0 --port 8000
    }
    Start-Sleep -Seconds 3

    # 啟動 USB 監聽服務（若已安裝）
    Write-Host "[2/3] 啟動 USB 監聽服務..." -ForegroundColor Green
    python daemon\usb_watcher_service.py start

    # 顯示狀態
    Write-Host "[3/3] 系統已就緒！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  API 文檔: http://127.0.0.1:8000/docs"
    Write-Host "  裝置狀態: http://127.0.0.1:8000/devices"
    Write-Host "  日誌位置: D:\Lightning-AI-ALL\logs\"
    Write-Host "  服務狀態: 執行 'sc query LightningUSBWatcher' 查看"
    Write-Host "  停止 BOT : .\start_bot.ps1 stop"
    Write-Host "========================================" -ForegroundColor Yellow
}

function Stop-BOT {
    Write-Host "🛑 停止 Lightning AI BOT..." -ForegroundColor Red
    python daemon\usb_watcher_service.py stop
    Get-Job | Stop-Job
    Write-Host "✅ 已停止所有服務"
}

switch ($Action) {
    "start" { Start-BOT }
    "stop"  { Stop-BOT }
    default { Write-Host "請指定 start 或 stop" }
}