你這段現在不是「一個腳本」，而是**三個系統疊在一起的 Control Tower 混合體**，而且有幾個會直接導致「不可維護 / 重複執行 / 潛在錯誤」的工程問題。

我直接幫你做工程級拆解（重點是讓它能進 AI Factory 架構）。

---

# ⚠️ 你現在這支腳本的核心問題（很關鍵）

## 1. ❌ 三個系統混寫

你目前混在一起：

* UAV 188 agent 模擬器
* bot_registry.json 建立器
* Gatekeep/Termux bot 初始化器

👉 這等於：

```text
一個檔案 = Simulation + Registry + Deployment + Docs generator
```

這在工程上會爆炸。

---

## 2. ❌ 重複執行 block（已經出現兩次）

你這段：

```powershell
# === 1. 建立 GTP00TermuxAll-Ai Gatekeep Bot ===
...
# === 2. 更新 bot_registry.json ===
...
# === 3. 產生 markdown ===
```

👉 出現 **完全重複貼兩次**

結果：

* 可能重複建立資料夾
* registry 可能 append 重複 bot
* docs 會被覆蓋兩次

---

## 3. ❌ Control Tower 還是「腳本型」，不是「系統型」

你現在是：

```text
.ps1 script = control tower
```

但你真正需要的是：

```text
Control Tower = service (API + registry + state + scheduler)
```

---

# 🧠 正確架構（AI Factory 正式版）

我幫你轉成「工程應該長這樣」：

```text
Lightning AI Factory
│
├── control_tower/
│   ├── api.py (FastAPI)
│   ├── registry.py (bot registry manager)
│   ├── swarm_engine.py (188 UAV simulation)
│   ├── deployer.py (GTP00 / gatekeep deploy)
│   ├── exporter.py (CSV / JSON / docs)
│
├── config/
│   └── bot_registry.json
│
├── runtime/
│   └── scheduler_state.db
│
└── scripts/
    └── init.ps1 (ONLY bootstrap)
```

---

# 🚀 我幫你「修正核心設計」

## ✔ 你這段應該拆成 3 個獨立模組

---

## 🧩 Module 1：Swarm Simulator（188 UAV）

```powershell
SwarmEngine.ps1
```

只做一件事：

```text
✔ 生成 188 agent
✔ 計算戰力
✔ export CSV/JSON
```

👉 不碰 registry、不碰 bot

---

## 🧩 Module 2：Registry Manager

```powershell
RegistryManager.ps1
```

只做：

```text
✔ bot_registry.json CRUD
✔ gatekeep 管理
✔ tools 管理
```

---

## 🧩 Module 3：Control Tower Bootstrap

```powershell
ControlTower.ps1
```

只做：

```text
✔ 呼叫 SwarmEngine
✔ 呼叫 RegistryManager
✔ 呼叫 deployer
✔ 統一輸出 dashboard
```

---

# ⚠️ 你現在最大工程風險

如果你繼續現在這種寫法：

### ❌ 會發生

* registry 被重複污染
* bot 會 duplicate
* UAV 模擬結果無法追蹤版本
* 無法 multi-run（每次結果不同）

---

# 🧠 我給你一個「升級方向」

你現在其實已經到：

> ⚡ AI Factory v0（script-based）

下一步是：

> 🚀 AI Factory v1（service-based Control Tower）

---

# 🔧 如果你下一步要做（很關鍵）

我可以幫你直接升級成：

## ✔ FastAPI Control Tower

包含：

* `/swarm/run`
* `/registry/add`
* `/registry/list`
* `/deploy/gtp00`
* `/dashboard/state`

---

## ✔ 並且會幫你補：

* 188 agent state DB（SQLite）
* swarm runtime engine
* bot registry version control
* webhook scheduler

---

# 👉 我建議你下一步只做一件事

回我：

> 「升級 Control Tower API」

我會幫你直接把這段 PowerShell：

👉 變成「真正可運行 AI Factory backend（FastAPI + runtime + registry）」
@'
# D:\Lightning-AI-ALL\usb-adb-agent.ps1總司令你的冰點a名完畢請下戰術跑起來24/7+============================================================
# 台灣 AI 無人機完整演練腳本 - Lightning AI Factory
# ============================================================

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "   ?? 台灣 AI 無人機完整演練系統 v2.0" -ForegroundColor Yellow
Write-Host "   Lightning AI Factory - Control Tower (188 Agent 全庫)" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# 生成完整 188 Agent 群
$AgentCount = 188
$AgentList = @()

Write-Host "?? 正在生成 188 個 AI Agent..." -ForegroundColor Cyan

for ($i = 1; $i -le $AgentCount; $i++) {
    $agentID = "AG-{0:D3}" -f $i
    $basePower = 100 + ($i - 1) * 1
    
    if ($i -le 20) { 
        $domain = "EA-100_Sparrow"
        $role = "微型偵察機"
    } elseif ($i -le 40) { 
        $domain = "EA-200_Falcon"
        $role = "中程偵察機"
    } elseif ($i -le 60) { 
        $domain = "EA-300_Hawk"
        $role = "長航時無人機"
    } elseif ($i -le 80) { 
        $domain = "EA-400_Condor"
        $role = "重載運輸機"
    } elseif ($i -le 100) { 
        $domain = "EA-500_Dragon"
        $role = "AI自主作戰平台"
    } elseif ($i -le 120) { 
        $domain = "EA-600_Phoenix"
        $role = "高空長航時(HALE)"
    } elseif ($i -le 140) { 
        $domain = "EA-700_Thunder"
        $role = "電子戰無人機"
    } elseif ($i -le 160) { 
        $domain = "EA-800_OceanEye"
        $role = "海事監測機"
    } elseif ($i -le 180) { 
        $domain = "EA-900_SkyNet"
        $role = "群體協同母機"
    } else { 
        $domain = "Core_Command"
        $role = "核心指揮機"
    }
    
    $bonus = 0
    if ($i -ge 181) { $bonus = 500 }
    
    $isTaiwan = ""
    $twName = ""
    
    if ($i -eq 7) { 
        $isTaiwan = "?"
        $twName = "紅雀二型"
        $basePower = 550
    } elseif ($i -eq 52) { 
        $isTaiwan = "?"
        $twName = "銳鳶無人機"
        $basePower = 1350
    } elseif ($i -eq 143) { 
        $isTaiwan = "?"
        $twName = "騰雲二型"
        $basePower = 2100
    } elseif ($i -eq 88) { 
        $isTaiwan = "?"
        $twName = "MQ-9 Reaper"
        $basePower = 2800
    } elseif ($i -eq 105) { 
        $isTaiwan = "?"
        $twName = "RQ-4 Global Hawk"
        $basePower = 3200
    }
    
    $totalPower = $basePower + $bonus
    
    $AgentList += [PSCustomObject]@{
        AgentID      = $agentID
        Platform     = "UAV-{0:D4}" -f (6000 + $i)
        Domain       = $domain
        Role         = $role
        Name         = $twName
        BasePower    = $basePower
        CommandBonus = $bonus
        TotalPower   = $totalPower
        IsTaiwan     = $isTaiwan
    }
}

Write-Host "? 188 個 AI Agent 生成完成！" -ForegroundColor Green
Write-Host ""

# 顯示台灣重點機種
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "?? 台灣無人機重點節點 (映射真實型號)" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

$TaiwanNodes = $AgentList | Where-Object { $_.IsTaiwan -eq "?" }
$TaiwanNodes | Format-Table AgentID, Name, Domain, Role, BasePower, TotalPower -AutoSize

# 總戰力統計
$TotalBase = 0
$TotalBonus = 0
foreach ($agent in $AgentList) {
    $TotalBase = $TotalBase + $agent.BasePower
    $TotalBonus = $TotalBonus + $agent.CommandBonus
}
$TotalPower = $TotalBase + $TotalBonus

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "?? 戰力總表" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  總 Agent 數量: $AgentCount"
Write-Host "  基礎戰力總和: $TotalBase"
Write-Host "  指揮加成總和: $TotalBonus"
Write-Host "  ?? 全庫總 AI 戰力值: $TotalPower" -ForegroundColor Green
Write-Host ""

# 蜂群模擬
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "?? 啟動蜂群模擬 (取前 20 個 Agent)" -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Cyan

$Swarm = $AgentList | Select-Object -First 20
$SwarmPower = 0
foreach ($agent in $Swarm) {
    $SwarmPower = $SwarmPower + $agent.TotalPower
    $status = ""
    if ($agent.IsTaiwan -eq "?") { $status = "[台灣機種]" } else { $status = "[協同節點]" }
    Write-Host "  $($agent.AgentID) $($agent.Domain) 戰力:$($agent.TotalPower) $status"
}

Write-Host ""
Write-Host "?? 蜂群總戰力: $SwarmPower" -ForegroundColor Magenta
Write-Host "? 蜂群模擬完成" -ForegroundColor Green
Write-Host ""

# 任務派遣
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "?? 任務派遣: 邊境偵察" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

$MissionList = $AgentList | Where-Object { $_.Domain -match "Sparrow|Falcon|Hawk|Phoenix" } | Select-Object -First 10
foreach ($agent in $MissionList) {
    $assigned = ""
    if ($agent.IsTaiwan -eq "?") { $assigned = "? 優先派遣" } else { $assigned = "待命" }
    Write-Host "  $($agent.AgentID) ($($agent.Domain)) -> $assigned"
}

Write-Host ""
Write-Host "? 任務派遣完成" -ForegroundColor Green
Write-Host ""

# 匯出 CSV
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvFile = "LAF_Taiwan_UAV_188_$timestamp.csv"
$jsonFile = "LAF_Taiwan_UAV_188_$timestamp.json"

$AgentList | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$AgentList | ConvertTo-Json -Depth 3 | Out-File -FilePath $jsonFile -Encoding UTF8

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "   ?? 匯出資產清單" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "? CSV 已匯出: $csvFile" -ForegroundColor Green
Write-Host "? JSON 已匯出: $jsonFile" -ForegroundColor Green
Write-Host "?? 檔案位置: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "   ? 台灣 AI 無人機演練完成！" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
'@ | Out-File -FilePath "Taiwan_UAV_Full_Drill.ps1" -Encoding UTF8

Write-Host "✅ 腳本檔案已重新建立！" -ForegroundColor Green
# 建立乾淨的 PowerShell 腳本
@'
# ============================================================
# 台灣 AI 無人機演練 - 純 PowerShell 版本
# Lightning AI Factory
# ============================================================

Clear-Host
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  台灣 AI 無人機完整演練系統 v2.0" -ForegroundColor Yellow
Write-Host "  Lightning AI Factory - Control Tower" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# 生成 188 個 Agent
$AgentCount = 188
$AgentList = @()

Write-Host "正在生成 188 個 AI Agent..." -ForegroundColor Cyan

for ($i = 1; $i -le $AgentCount; $i++) {
    $agentID = "AG-{0:D3}" -f $i
    
    if ($i -le 20) { 
        $domain = "EA-100_Sparrow"
        $role = "微型偵察機"
    } elseif ($i -le 40) { 
        $domain = "EA-200_Falcon"
        $role = "中程偵察機"
    } elseif ($i -le 60) { 
        $domain = "EA-300_Hawk"
        $role = "長航時無人機"
    } elseif ($i -le 80) { 
        $domain = "EA-400_Condor"
        $role = "重載運輸機"
    } elseif ($i -le 100) { 
        $domain = "EA-500_Dragon"
        $role = "AI自主作戰平台"
    } elseif ($i -le 120) { 
        $domain = "EA-600_Phoenix"
        $role = "高空長航時"
    } elseif ($i -le 140) { 
        $domain = "EA-700_Thunder"
        $role = "電子戰無人機"
    } elseif ($i -le 160) { 
        $domain = "EA-800_OceanEye"
        $role = "海事監測機"
    } elseif ($i -le 180) { 
        $domain = "EA-900_SkyNet"
        $role = "群體協同母機"
    } else { 
        $domain = "Core_Command"
        $role = "核心指揮機"
    }
    
    $bonus = 0
    if ($i -ge 181) { $bonus = 500 }
    
    $basePower = 100 + ($i - 1) * 1
    $twName = ""
    $isTaiwan = $false
    
    if ($i -eq 7) { 
        $twName = "紅雀二型"
        $basePower = 550
        $isTaiwan = $true
    } elseif ($i -eq 52) { 
        $twName = "銳鳶無人機"
        $basePower = 1350
        $isTaiwan = $true
    } elseif ($i -eq 143) { 
        $twName = "騰雲二型"
        $basePower = 2100
        $isTaiwan = $true
    } elseif ($i -eq 88) { 
        $twName = "MQ-9 Reaper"
        $basePower = 2800
        $isTaiwan = $true
    } elseif ($i -eq 105) { 
        $twName = "RQ-4 Global Hawk"
        $basePower = 3200
        $isTaiwan = $true
    }
    
    $AgentList += [PSCustomObject]@{
        AgentID      = $agentID
        Platform     = "UAV-{0:D4}" -f (6000 + $i)
        Domain       = $domain
        Role         = $role
        Name         = $twName
        BasePower    = $basePower
        CommandBonus = $bonus
        TotalPower   = $basePower + $bonus
        IsTaiwan     = $isTaiwan
    }
}

Write-Host "完成！188 個 AI Agent 已生成" -ForegroundColor Green
Write-Host ""

# 顯示台灣機種
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "台灣無人機重點節點" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

$TaiwanNodes = $AgentList | Where-Object { $_.IsTaiwan -eq $true }
$TaiwanNodes | Format-Table AgentID, Name, Domain, Role, BasePower, TotalPower -AutoSize

# 計算總戰力
$TotalBase = 0
$TotalBonus = 0
foreach ($agent in $AgentList) {
    $TotalBase = $TotalBase + $agent.BasePower
    $TotalBonus = $TotalBonus + $agent.CommandBonus
}
$TotalPower = $TotalBase + $TotalBonus

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "戰力總表" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  總 Agent 數量: $AgentCount"
Write-Host "  基礎戰力總和: $TotalBase"
Write-Host "  指揮加成總和: $TotalBonus"
Write-Host "  全庫總 AI 戰力值: $TotalPower" -ForegroundColor Green
Write-Host ""

# 蜂群模擬
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "蜂群模擬 (前 20 個 Agent)" -ForegroundColor Magenta
Write-Host "============================================================" -ForegroundColor Cyan

$Swarm = $AgentList | Select-Object -First 20
$SwarmPower = 0
foreach ($agent in $Swarm) {
    $SwarmPower = $SwarmPower + $agent.TotalPower
    $status = ""
    if ($agent.IsTaiwan) { 
        $status = "[台灣機種]" 
    } else { 
        $status = "[協同節點]" 
    }
    Write-Host "  $($agent.AgentID) $($agent.Domain) 戰力:$($agent.TotalPower) $status"
}

Write-Host ""
Write-Host "蜂群總戰力: $SwarmPower" -ForegroundColor Magenta
Write-Host ""

# 任務派遣
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "任務派遣: 邊境偵察" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan

$MissionList = $AgentList | Where-Object { $_.Domain -match "Sparrow|Falcon|Hawk|Phoenix" } | Select-Object -First 10
foreach ($agent in $MissionList) {
    $assigned = ""
    if ($agent.IsTaiwan) { 
        $assigned = "優先派遣" 
    } else { 
        $assigned = "待命" 
    }
    Write-Host "  $($agent.AgentID) ($($agent.Domain)) -> $assigned"
}

Write-Host ""
Write-Host "任務派遣完成" -ForegroundColor Green
Write-Host ""

# 匯出 CSV
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvFile = "LAF_Taiwan_UAV_188_$timestamp.csv"
$jsonFile = "LAF_Taiwan_UAV_188_$timestamp.json"

$AgentList | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8
$AgentList | ConvertTo-Json -Depth 3 | Out-File -FilePath $jsonFile -Encoding UTF8

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "匯出資產清單" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "CSV 已匯出: $csvFile" -ForegroundColor Green
Write-Host "JSON 已匯出: $jsonFile" -ForegroundColor Green
Write-Host "檔案位置: $(Get-Location)" -ForegroundColor Yellow
Write-Host ""

Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "演練完成！" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Cyan
'@ | Out-File -FilePath "Taiwan_UAV_Clean.ps1" -Encoding UTF8

# 執行腳本
.\Taiwan_TW_Clean.ps1
New-Item -ItemType Directory -Force -Path "D:\Lightning-AI-ALL\config" | Out-Null

@'
{
  "registry_version": "1.0",
  "last_updated": "{date}",
  "layers": {
    "gatekeep": [
      { "id": "GTP24", "name": "GTP24 Gatekeep", "path": "GTP24Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP24_RouterStatus" },
      { "id": "GTP25", "name": "GTP25 Gatekeep", "path": "GTP25Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP25_RouterStatus" },
      { "id": "GTP26", "name": "GTP26 Gatekeep", "path": "GTP26Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP26_RouterStatus" },
      { "id": "GTP27", "name": "GTP27 Gatekeep", "path": "GTP27Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP27_RouterStatus" },
      { "id": "GTP28", "name": "GTP28 Gatekeep", "path": "GTP28Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP28_RouterStatus" },
      { "id": "GTP29", "name": "GTP29 Gatekeep", "path": "GTP29Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP29_RouterStatus" },
      { "id": "GTP30", "name": "GTP30 Gatekeep", "path": "GTP30Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP30_RouterStatus" },
      { "id": "GTP31", "name": "GTP31 Gatekeep", "path": "GTP31Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP31_RouterStatus" },
      { "id": "GTP32", "name": "GTP32 Gatekeep", "path": "GTP32Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP32_RouterStatus" },
      { "id": "GTP33", "name": "GTP33 Gatekeep", "path": "GTP33Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP33_RouterStatus" },
      { "id": "GTP34", "name": "GTP34 Gatekeep", "path": "GTP34Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP34_RouterStatus" },
      { "id": "GTP35", "name": "GTP35 Gatekeep", "path": "GTP35Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP35_RouterStatus" },
      { "id": "GTP36", "name": "GTP36 Gatekeep", "path": "GTP36Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP36_RouterStatus" },
      { "id": "GTP37", "name": "GTP37 Gatekeep", "path": "GTP37Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP37_RouterStatus" },
      { "id": "GTP38", "name": "GTP38 Gatekeep", "path": "GTP38Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP38_RouterStatus" },
      { "id": "GTP39", "name": "GTP39 Gatekeep", "path": "GTP39Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP39_RouterStatus" },
      { "id": "GTP40", "name": "GTP40 Gatekeep", "path": "GTP40Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP40_RouterStatus" },
      { "id": "GTP41", "name": "GTP41 Gatekeep", "path": "GTP41Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP41_RouterStatus" },
      { "id": "GTP42", "name": "GTP42 Gatekeep", "path": "GTP42Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP42_RouterStatus" },
      { "id": "GTP43", "name": "GTP43 Gatekeep", "path": "GTP43Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP43_RouterStatus" },
      { "id": "GTP44", "name": "GTP44 Gatekeep", "path": "GTP44Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP44_RouterStatus" },
      { "id": "GTP45", "name": "GTP45 Gatekeep", "path": "GTP45Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP45_RouterStatus" },
      { "id": "GTP46", "name": "GTP46 Gatekeep", "path": "GTP46Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP46_RouterStatus" },
      { "id": "GTP47", "name": "GTP47 Gatekeep", "path": "GTP47Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP47_RouterStatus" },
      { "id": "GTP48", "name": "GTP48 Gatekeep", "path": "GTP48Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP48_RouterStatus" },
      { "id": "GTP49", "name": "GTP49 Gatekeep", "path": "GTP49Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP49_RouterStatus" },
      { "id": "GTP50", "name": "GTP50 Gatekeep", "path": "GTP50Gatekeep-stormcar820-Wshao777", "type": "core", "schedule": "GTP50_RouterStatus" },
      { "id": "GTP-A1", "name": "GTP-A1 Gatekeep", "path": "GTP-A1-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-B2", "name": "GTP-B2 Gatekeep", "path": "GTP-B2-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-C3", "name": "GTP-C3 Gatekeep", "path": "GTP-C3-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-D4", "name": "GTP-D4 Gatekeep", "path": "GTP-D4-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-E5", "name": "GTP-E5 Gatekeep", "path": "GTP-E5-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-F6", "name": "GTP-F6 Gatekeep", "path": "GTP-F6-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-G7", "name": "GTP-G7 Gatekeep", "path": "GTP-G7-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-H8", "name": "GTP-H8 Gatekeep", "path": "GTP-H8-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-I9", "name": "GTP-I9 Gatekeep", "path": "GTP-I9-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP-J0", "name": "GTP-J0 Gatekeep", "path": "GTP-J0-Gatekeep-stormcar820-Wshao777", "type": "extended", "schedule": null },
      { "id": "GTP50Termux", "name": "Termux All-AI Gatekeep", "path": "GTP50TermuxAll-AiGatekeep-stormcar820-Wshao777", "type": "special", "schedule": null }
    ],
    "tools": [
      { "id": "gemini", "name": "Gemini", "type": "ai-model" },
      { "id": "deepseek", "name": "DeepSeek", "type": "ai-model" },
      { "id": "chatgpt", "name": "ChatGPT", "type": "ai-model" },
      { "id": "copilot", "name": "GitHub Copilot", "type": "ai-model" },
      { "id": "m365_copilot", "name": "M365 Copilot", "type": "ai-model" },
      { "id": "m365", "name": "Microsoft 365", "type": "service" },
      { "id": "termux", "name": "Termux", "type": "shell" },
      { "id": "chrome", "name": "Google Chrome", "type": "browser" },
      { "id": "gmail", "name": "Gmail", "type": "service" },
      { "id": "instagram", "name": "Instagram", "type": "social" },
      { "id": "maps", "name": "Google Maps", "type": "service" },
      { "id": "drive", "name": "Google Drive / Grab雲端硬碟", "type": "storage" },
      { "id": "github_docs", "name": "GitHub Docs", "type": "dev" },
      { "id": "play_store", "name": "Google Play Store", "type": "store" },
      { "id": "pydroid", "name": "Pydroid 3", "type": "dev-mobile" },
      { "id": "python_coding", "name": "PythonCodingE...", "type": "dev" },
      { "id": "html_editor", "name": "Html Editor", "type": "dev" },
      { "id": "rustcode", "name": "RustCode", "type": "dev" },
      { "id": "pycode", "name": "PyCode", "type": "dev" },
      { "id": "jvdroid", "name": "Jvdroid / Jv", "type": "dev" },
      { "id": "sound_locator", "name": "Sound Locator", "type": "utility" },
      { "id": "qr_scanner", "name": "二維碼掃描儀Analytics", "type": "utility" },
      { "id": "ai_studio", "name": "AI Studio", "type": "dev" },
      { "id": "powerpoint", "name": "PowerPoint", "type": "office" },
      { "id": "word", "name": "Word", "type": "office" },
      { "id": "star_city", "name": "星城 / 星城OnlineFlash", "type": "game" },
      { "id": "lightning_alarm", "name": "Lightning Alarm", "type": "utility" },
      { "id": "files", "name": "Files (系統檔案)", "type": "system" },
      { "id": "grab", "name": "Grab", "type": "service" },
      { "id": "weather", "name": "天氣", "type": "service" },
      { "id": "redhat_dev", "name": "Redhat Dev", "type": "dev" },
      { "id": "pyramide", "name": "Pyramide", "type": "dev" },
      { "id": "翻译", "name": "Google 翻譯", "type": "service" },
      { "id": "地图", "name": "地圖", "type": "service" },
      { "id": "链接至Windows", "name": "連結至 Windows", "type": "system" },
      { "id": "google", "name": "Google", "type": "service" }
    ]
  }
}
'@ -replace '{date}', (Get-Date -Format 'yyyy-MM-dd HH:mm') | Out-File -FilePath "D:\Lightning-AI-ALL\config\bot_registry.json" -Encoding UTF8

Write-Host "✅ bot_registry.json 已建立" -ForegroundColor Green
# Manage-Bots.ps1
$registry = Get-Content "D:\Lightning-AI-ALL\config\bot_registry.json" | ConvertFrom-Json

Write-Host "🛡️ Gatekeep Bots: $($registry.layers.gatekeep.Count)" -ForegroundColor Cyan
Write-Host "🧰 Tool Bots: $($registry.layers.tools.Count)" -ForegroundColor Cyan

Write-Host "`n=== Gatekeep 排程狀態 ===" -ForegroundColor Yellow
$registry.layers.gatekeep | ForEach-Object {
    if ($_.schedule) {
        $task = Get-ScheduledTask -TaskName $_.schedule -ErrorAction SilentlyContinue
        $state = if ($task) { $task.State } else { "未註冊" }
        Write-Host "$($_.id) : $state"
    }
}

Write-Host "`n=== 工具 Bot 快速索引 ===" -ForegroundColor Yellow
$registry.layers.tools | Select-Object id, name, type | Format-Table -AutoSize
# === 1. 建立 GTP00TermuxAll-Ai Gatekeep Bot ===
$botName = "GTP00TermuxAll-Ai-Gatekeep-stormcar820-Wshao777"
$botPath = Join-Path "D:\Lightning-AI-ALL" $botName

if (-not (Test-Path $botPath)) {
    New-Item -ItemType Directory -Path $botPath -Force | Out-Null
    @"
# $botName
建立時間：$(Get-Date -Format 'yyyy-MM-dd HH:mm')
類型：5G 主權網關終端節點 (Termux 環境)
狀態：已部署（由 Commander Hus Chih Li 於 $(Get-Date -Format 'yyyy-MM-dd') 建立）
"@ | Out-File -FilePath "$botPath\README.md" -Encoding UTF8
    Write-Host "✅ 已建立 $botName" -ForegroundColor Green
} else {
    Write-Host "ℹ️  已存在 $botName" -ForegroundColor Cyan
}

# === 2. 更新 bot_registry.json（加入 GTP00） ===
$registryPath = "D:\Lightning-AI-ALL\config\bot_registry.json"
if (Test-Path $registryPath) {
    $reg = Get-Content $registryPath -Encoding UTF8 | ConvertFrom-Json
    # 檢查是否已存在
    $exists = $reg.layers.gatekeep | Where-Object { $_.id -eq "GTP00Termux" }
    if (-not $exists) {
        $newBot = [PSCustomObject]@{
            id = "GTP00Termux"
            name = "GTP00 Termux All-AI Gatekeep"
            path = $botName
            type = "special"
            schedule = $null
        }
        $reg.layers.gatekeep += $newBot
        $reg | ConvertTo-Json -Depth 3 | Out-File $registryPath -Encoding UTF8
        Write-Host "✅ 已將 GTP00Termux 加入註冊表" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  GTP00Termux 已在註冊表中" -ForegroundColor Cyan
    }
} else {
    Write-Host "⚠️  找不到 bot_registry.json，請先執行註冊表建立腳本" -ForegroundColor Yellow
}

# === 3. 產生完整「系統總列表」Markdown ===
$doc = @"
# 閃電帝國 AI Factory 系統總列表
更新時間：$(Get-Date -Format 'yyyy-MM-dd HH:mm')

## 🛡️ Gatekeep 核心節點 (目前 38 個)
| 編號 | Bot ID | 名稱 | 排程 |
|------|--------|------|------|
"@

$reg = Get-Content $registryPath -Encoding UTF8 | ConvertFrom-Json
$i = 1
foreach ($g in $reg.layers.gatekeep) {
    $doc += "| $i | $($g.id) | $($g.name) | $($g.schedule) |`n"
    $i++
}

$doc += @"

## 🧰 工具 Bot 列表 (共 $($reg.layers.tools.Count) 個)
| 序號 | ID | 名稱 | 類型 |
|------|----|------|------|
"@
$j = 1
foreach ($t in $reg.layers.tools) {
    $doc += "| $j | $($t.id) | $($t.name) | $($t.type) |`n"
    $j++
}

$doc += @"

## 📊 總計
- Gatekeep 節點：$($reg.layers.gatekeep.Count) 個
- 工具節點：$($reg.layers.tools.Count) 個
- 目前總註冊數：$($reg.layers.gatekeep.Count + $reg.layers.tools.Count) 個
- 語言層（英文 26 / 注音 37 / 數字 10）待建立分類後匯入

---
*由 Commander Hus Chih Li 授權，2026-06-20*
"@

$doc | Out-File -FilePath "D:\Lightning-AI-ALL\docs\系統總列表.md" -Encoding UTF8
Write-Host "✅ 系統總列表已產生：docs\系統總列表.md" -ForegroundColor Green
# === 1. 建立 GTP00TermuxAll-Ai Gatekeep Bot ===
$botName = "GTP00TermuxAll-Ai-Gatekeep-stormcar820-Wshao777"
$botPath = Join-Path "D:\Lightning-AI-ALL" $botName

if (-not (Test-Path $botPath)) {
    New-Item -ItemType Directory -Path $botPath -Force | Out-Null
    @"
# $botName
建立時間：$(Get-Date -Format 'yyyy-MM-dd HH:mm')
類型：5G 主權網關終端節點 (Termux 環境)
狀態：已部署（由 Commander Hus Chih Li 於 $(Get-Date -Format 'yyyy-MM-dd') 建立）
"@ | Out-File -FilePath "$botPath\README.md" -Encoding UTF8
    Write-Host "✅ 已建立 $botName" -ForegroundColor Green
} else {
    Write-Host "ℹ️  已存在 $botName" -ForegroundColor Cyan
}

# === 2. 更新 bot_registry.json（加入 GTP00） ===
$registryPath = "D:\Lightning-AI-ALL\config\bot_registry.json"
if (Test-Path $registryPath) {
    $reg = Get-Content $registryPath -Encoding UTF8 | ConvertFrom-Json
    # 檢查是否已存在
    $exists = $reg.layers.gatekeep | Where-Object { $_.id -eq "GTP00Termux" }
    if (-not $exists) {
        $newBot = [PSCustomObject]@{
            id = "GTP00Termux"
            name = "GTP00 Termux All-AI Gatekeep"
            path = $botName
            type = "special"
            schedule = $null
        }
        $reg.layers.gatekeep += $newBot
        $reg | ConvertTo-Json -Depth 3 | Out-File $registryPath -Encoding UTF8
        Write-Host "✅ 已將 GTP00Termux 加入註冊表" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  GTP00Termux 已在註冊表中" -ForegroundColor Cyan
    }
} else {
    Write-Host "⚠️  找不到 bot_registry.json，請先執行註冊表建立腳本" -ForegroundColor Yellow
}

# === 3. 產生完整「系統總列表」Markdown ===
$doc = @"
# 閃電帝國 AI Factory 系統總列表
更新時間：$(Get-Date -Format 'yyyy-MM-dd HH:mm')

## 🛡️ Gatekeep 核心節點 (目前 38 個)
| 編號 | Bot ID | 名稱 | 排程 |
|------|--------|------|------|
"@

$reg = Get-Content $registryPath -Encoding UTF8 | ConvertFrom-Json
$i = 1
foreach ($g in $reg.layers.gatekeep) {
    $doc += "| $i | $($g.id) | $($g.name) | $($g.schedule) |`n"
    $i++
}

$doc += @"

## 🧰 工具 Bot 列表 (共 $($reg.layers.tools.Count) 個)
| 序號 | ID | 名稱 | 類型 |
|------|----|------|------|
"@
$j = 1
foreach ($t in $reg.layers.tools) {
    $doc += "| $j | $($t.id) | $($t.name) | $($t.type) |`n"
    $j++
}

$doc += @"

## 📊 總計
- Gatekeep 節點：$($reg.layers.gatekeep.Count) 個
- 工具節點：$($reg.layers.tools.Count) 個
- 目前總註冊數：$($reg.layers.gatekeep.Count + $reg.layers.tools.Count) 個
- 語言層（英文 26 / 注音 37 / 數字 10）待建立分類後匯入

---
*由 Commander Hus Chih Li 授權，2026-06-20*
"@

$doc | Out-File -FilePath "D:\Lightning-AI-ALL\docs\系統總列表.md" -Encoding UTF8
Write-Host "✅ 系統總列表已產生：docs\系統總列表.md" -ForegroundColor Green