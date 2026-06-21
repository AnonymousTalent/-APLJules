Write-Host "===================================" -ForegroundColor Cyan
Write-Host "   USB + ADB AUTO AGENT START" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

function Start-ADB {
    Write-Host "🔄 restarting adb..." -ForegroundColor Yellow
    adb kill-server | Out-Null
    adb start-server | Out-Null
    adb devices
}

function Check-Device {
    $output = adb devices

    if ($output -match "device$") {
        Write-Host "✅ Android device connected" -ForegroundColor Green
        return $true
    } else {
        Write-Host "❌ No device detected" -ForegroundColor Red
        return $false
    }
}

function Push-Model {
    param (
        [string]$ModelPath
    )

    if (!(Test-Path $ModelPath)) {
        Write-Host "❌ model not found: $ModelPath" -ForegroundColor Red
        return
    }

    Write-Host "📦 pushing model..." -ForegroundColor Yellow
    adb push $ModelPath /sdcard/
    Write-Host "✅ model pushed"
}

function Enter-Phone {
    Write-Host "📱 entering adb shell..." -ForegroundColor Cyan
    adb shell
}

function Auto-Monitor {
    Write-Host "🔍 monitoring USB / ADB..." -ForegroundColor Cyan

    while ($true) {
        $devices = adb devices

        if ($devices -match "device$") {
            Write-Host "✅ device alive" -ForegroundColor Green
        } else {
            Write-Host "❌ waiting for device..." -ForegroundColor Red
        }

        Start-Sleep -Seconds 3
    }
}

function Full-Init {
    Start-ADB

    Start-Sleep -Seconds 2

    if (Check-Device) {
        Write-Host "🚀 system ready for AI pipeline" -ForegroundColor Green
    } else {
        Write-Host "⚠️ connect phone via USB + enable debugging" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Commands:" -ForegroundColor Cyan
Write-Host "  Full-Init" -ForegroundColor White
Write-Host "  Start-ADB" -ForegroundColor White
Write-Host "  Check-Device" -ForegroundColor White
Write-Host "  Push-Model <path>" -ForegroundColor White
Write-Host "  Enter-Phone" -ForegroundColor White
Write-Host "  Auto-Monitor" -ForegroundColor White
Write-Host ""