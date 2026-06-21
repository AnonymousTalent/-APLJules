# daemon/adb_handler.py
import subprocess
import time
import requests
import sys
import os
import logging

LOG_FILE = "D:/Lightning-AI-ALL/logs/adb_handler.log"
logging.basicConfig(filename=LOG_FILE, level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

def list_devices():
    result = subprocess.run(["adb", "devices"], capture_output=True, text=True)
    devices = []
    for line in result.stdout.splitlines():
        if "device" in line and "List" not in line:
            serial = line.split()[0]
            if "emulator" not in serial:
                devices.append(serial)
    return devices

def deploy_to_device(serial, max_retries=3):
    for attempt in range(max_retries):
        try:
            logging.info(f"嘗試部署至 {serial} (嘗試 {attempt+1}/{max_retries})")
            # 確保連線
            subprocess.run(["adb", "-s", serial, "connect"], timeout=10, check=False)
            # 推送啟動腳本
            script_local = "D:/Lightning-AI-ALL/android_agent/boot_ai_agent.sh"
            script_remote = "/data/local/tmp/boot_ai_agent.sh"
            subprocess.run(["adb", "-s", serial, "push", script_local, script_remote], timeout=30, check=True)
            subprocess.run(["adb", "-s", serial, "shell", "chmod", "+x", script_remote], timeout=10, check=True)
            # 在 Termux 中執行
            cmd = f'adb -s {serial} shell "echo \'bash {script_remote}\' | /data/data/com.termux/files/usr/bin/bash"'
            subprocess.Popen(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            # 通知 Control Tower
            try:
                requests.post("http://127.0.0.1:8000/device/register",
                              json={"serial": serial, "status": "deployed"},
                              timeout=5)
            except:
                pass
            logging.info(f"部署成功至 {serial}")
            return True
        except Exception as e:
            logging.error(f"部署失敗 (嘗試 {attempt+1}): {e}")
            time.sleep(5)
    # 全部失敗
    try:
        requests.post("http://127.0.0.1:8000/device/register",
                      json={"serial": serial, "status": "deploy_failed"},
                      timeout=5)
    except:
        pass
    logging.error(f"部署至 {serial} 最終失敗")
    return False

def main():
    if len(sys.argv) > 1 and sys.argv[1] == "list":
        devices = list_devices()
        print("\n".join(devices))
        return
    # 自動模式：找到所有裝置並部署
    devices = list_devices()
    if not devices:
        logging.info("未找到任何裝置")
        return
    for serial in devices:
        deploy_to_device(serial)

if __name__ == "__main__":
    main()