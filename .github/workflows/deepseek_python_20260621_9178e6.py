# 在 main.py 中新增或確認存在
from fastapi import FastAPI, HTTPException
import json
from pathlib import Path
from datetime import datetime

app = FastAPI(title="Lightning AI Control Tower", version="2.0")

# ... 其他端點 ...

REGISTRY_PATH = Path("D:/Lightning-AI-ALL/config/bot_registry.json")

@app.post("/device/register")
def register_device(device: dict):
    serial = device.get("serial")
    status = device.get("status", "unknown")
    if not serial:
        raise HTTPException(status_code=400, detail="缺少 serial")
    # 更新 registry
    if not REGISTRY_PATH.exists():
        data = {"devices": []}
    else:
        with open(REGISTRY_PATH, "r", encoding="utf-8") as f:
            data = json.load(f)
    if "devices" not in data:
        data["devices"] = []
    # 更新或新增
    existing = next((d for d in data["devices"] if d["serial"] == serial), None)
    if existing:
        existing["status"] = status
        existing["last_seen"] = datetime.now().isoformat()
    else:
        data["devices"].append({
            "serial": serial,
            "status": status,
            "registered_at": datetime.now().isoformat()
        })
    with open(REGISTRY_PATH, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    return {"message": f"Device {serial} updated to {status}"}

@app.get("/devices")
def list_devices():
    if not REGISTRY_PATH.exists():
        return {"devices": []}
    with open(REGISTRY_PATH, "r", encoding="utf-8") as f:
        data = json.load(f)
    return {"devices": data.get("devices", [])}