# adb_handler.py (增強版)
import subprocess
import time
import requests
import json

def deploy_to_device(serial, max_retries=3):
    for attempt in range(max_retries):
        try:
            # 1. 確保 ADB 連線
            subprocess.run(["adb", "-s", serial, "connect"], check=True, timeout=10)
            # 2. 推送啟動腳本
            subprocess.run(["adb", "-s", serial, "push", "android_agent/boot_ai_agent.sh", "/data/local/tmp/"], check=True)
            subprocess.run(["adb", "-s", serial, "shell", "chmod", "+x", "/data/local/tmp/boot_ai_agent.sh"], check=True)
            # 3. 在 Termux 中執行
            cmd = f'adb -s {serial} shell "echo \'bash /data/local/tmp/boot_ai_agent.sh\' | /data/data/com.termux/files/usr/bin/bash"'
            subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            # 4. 回報成功給 Control Tower
            requests.post("http://127.0.0.1:8000/device/status", json={"serial": serial, "status": "ai_started"})
            print(f"[ADB] 部署成功至 {serial}")
            return True
        except Exception as e:
            print(f"[ADB] 嘗試 {attempt+1} 失敗：{e}")
            time.sleep(3)
    # 全部失敗：回報錯誤
    requests.post("http://127.0.0.1:8000/device/status", json={"serial": serial, "status": "deploy_failed"})
    return False