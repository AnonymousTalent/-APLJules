.\start_bot.ps1from fastapi import FastAPI, WebSocket
from fastapi.middleware.cors import CORSMiddleware
import asyncio

app = FastAPI(title="AI Factory Control Tower")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ======================
# Mock System State
# ======================
STATE = {
    "tasks": [],
    "workers": 3,
    "mutations": [],
    "logs": []
}

# ======================
# TASK API
# ======================
@app.get("/tasks")
def get_tasks():
    return STATE["tasks"]

@app.post("/tasks")
def create_task(task: dict):
    STATE["tasks"].append(task)
    STATE["logs"].append({"type": "TASK_CREATED", "task": task})
    return {"status": "ok"}

# ======================
# WORKER STATUS
# ======================
@app.get("/workers")
def get_workers():
    return {"active_workers": STATE["workers"]}

# ======================
# MUTATION HISTORY
# ======================
@app.get("/mutations")
def get_mutations():
    return STATE["mutations"]

# ======================
# CONTROL ACTIONS
# ======================
@app.post("/bootstrap")
def bootstrap():
    STATE["logs"].append({"type": "BOOTSTRAP"})
    return {"status": "AI FACTORY ONLINE"}

@app.post("/restart")
def restart():
    STATE["logs"].append({"type": "RESTART"})
    return {"status": "restarted"}

@app.post("/stop")
def stop():
    STATE["logs"].append({"type": "STOP"})
    return {"status": "stopped"}

# ======================
# WEB SOCKET (REALTIME)
# ======================
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()

    while True:
        await asyncio.sleep(1)

        await websocket.send_json({
            "tasks": STATE["tasks"],
            "workers": STATE["workers"],
            "logs": STATE["logs"][-10:]
        }) stop
