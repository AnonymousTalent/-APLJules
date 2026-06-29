FastAPI Routes (AI Factory Control Tower v1.0)
from fastapi import APIRouter, WebSocket
from typing import Dict, Any, List
import asyncio

router = APIRouter()

# =========================
# In-memory state (MVP)
# =========================
STATE = {
    "tasks": [],
    "workers": [{"id": 1, "status": "idle"}, {"id": 2, "status": "idle"}],
    "mutations": [],
    "logs": [],
    "system": {
        "status": "offline",
        "version": "v1.0"
    }
}

# =========================
# TASK ROUTES
# =========================
@router.get("/tasks")
def list_tasks():
    return {"tasks": STATE["tasks"]}

@router.post("/tasks")
def create_task(task: Dict[str, Any]):
    STATE["tasks"].append(task)
    STATE["logs"].append({"type": "TASK_CREATED", "data": task})
    return {"status": "created", "task": task}

@router.delete("/tasks")
def clear_tasks():
    STATE["tasks"] = []
    STATE["logs"].append({"type": "TASKS_CLEARED"})
    return {"status": "cleared"}


# =========================
# WORKER ROUTES
# =========================
@router.get("/workers")
def get_workers():
    return {"workers": STATE["workers"]}

@router.post("/workers/scale")
def scale_workers(count: int):
    STATE["workers"] = [
        {"id": i, "status": "idle"} for i in range(1, count + 1)
    ]
    STATE["logs"].append({"type": "WORKERS_SCALED", "count": count})
    return {"status": "scaled", "count": count}


# =========================
# MUTATION SYSTEM (PR8 core)
# =========================
@router.get("/mutations")
def list_mutations():
    return {"mutations": STATE["mutations"]}

@router.post("/mutations/propose")
def propose_mutation(mutation: Dict[str, Any]):
    mutation["status"] = "pending"
    STATE["mutations"].append(mutation)
    STATE["logs"].append({"type": "MUTATION_PROPOSED", "data": mutation})
    return {"status": "proposed", "mutation": mutation}

@router.post("/mutations/approve")
def approve_mutation(index: int):
    if index < len(STATE["mutations"]):
        STATE["mutations"][index]["status"] = "approved"
        STATE["logs"].append({"type": "MUTATION_APPROVED", "index": index})
        return {"status": "approved"}
    return {"error": "invalid index"}

@router.post("/mutations/reject")
def reject_mutation(index: int):
    if index < len(STATE["mutations"]):
        STATE["mutations"][index]["status"] = "rejected"
        STATE["logs"].append({"type": "MUTATION_REJECTED", "index": index})
        return {"status": "rejected"}
    return {"error": "invalid index"}


# =========================
# SYSTEM CONTROL (Control Tower)
# =========================
@router.post("/bootstrap")
def bootstrap_system():
    STATE["system"]["status"] = "online"
    STATE["logs"].append({"type": "BOOTSTRAP"})
    return {"status": "AI_FACTORY_ONLINE"}

@router.post("/shutdown")
def shutdown_system():
    STATE["system"]["status"] = "offline"
    STATE["logs"].append({"type": "SHUTDOWN"})
    return {"status": "AI_FACTORY_OFFLINE"}

@router.get("/status")
def system_status():
    return STATE["system"]


# =========================
# LOGS / OBSERVABILITY
# =========================
@router.get("/logs")
def get_logs(limit: int = 50):
    return {"logs": STATE["logs"][-limit:]}


# =========================
# REALTIME STREAM (WebSocket)
# =========================
@router.websocket("/ws")
async def websocket_stream(websocket: WebSocket):
    await websocket.accept()

    while True:
        await asyncio.sleep(1)

        await websocket.send_json({
            "system": STATE["system"],
            "tasks": STATE["tasks"],
            "workers": STATE["workers"],
            "mutations": STATE["mutations"],
            "logs": STATE["logs"][-10:]
        })
echo "[Termux] AI 啟動腳本開始執行" >> /sdcard/ai_log.txt
pkg update -y && pkg upgrade -y
pkg install -y python git cmake wget

cd ~
if [ ! -d "llama.cpp" ]; then
    git clone https://github.com/ggerganov/llama.cpp
fi
cd llama.cpp
make -j4

# 下載輕量模型（僅首次）
if [ ! -f "models/qwen2.5-0.5b-q4_k_m.gguf" ]; then
    mkdir -p models
    wget -O models/qwen2.5-0.5b-q4_k_m.gguf \
    https://huggingface.co/Qwen/Qwen2.5-0.5B-GGUF/resolve/main/qwen2.5-0.5b-q4_k_m.gguf
fi

# 啟動服務（背景）
nohup ./llama-cli -m models/qwen2.5-0.5b-q4_k_m.gguf -p "AI ready" > /sdcard/ai_output.log 2>&1 &
echo "[Termux] AI 服務已啟動" >> /sdcard/ai_log.txt
