# daemon/usb_watcher_service.py
import win32serviceutil
import win32service
import win32event
import servicemanager
import socket
import sys
import time
import subprocess
import requests
import json
import logging
from pathlib import Path

# 設定日誌
LOG_FILE = Path("D:/Lightning-AI-ALL/logs/usb_watcher.log")
LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
logging.basicConfig(filename=LOG_FILE, level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

class USBWatcherService(win32serviceutil.ServiceFramework):
    _svc_name_ = "LightningUSBWatcher"
    _svc_display_name_ = "Lightning AI USB Watcher"
    _svc_description_ = "監聽 USB 插入事件，自動部署 AI 到手機"

    def __init__(self, args):
        win32serviceutil.ServiceFramework.__init__(self, args)
        self.hWaitStop = win32event.CreateEvent(None, 0, 0, None)
        socket.setdefaulttimeout(60)

    def SvcStop(self):
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        win32event.SetEvent(self.hWaitStop)
        logging.info("服務停止")

    def SvcDoRun(self):
        servicemanager.LogMsg(servicemanager.EVENTLOG_INFORMATION_TYPE,
                              servicemanager.PYS_SERVICE_STARTED,
                              (self._svc_name_, ''))
        logging.info("服務啟動")
        self.main()

    def main(self):
        # 使用 WMI 監聽 USB 裝置變更
        import wmi
        import pythoncom
        pythoncom.CoInitialize()
        c = wmi.WMI()
        watcher = c.WatchFor(notification_type="Creation",
                             wmi_class="Win32_DeviceChangeEvent")
        while True:
            try:
                event = watcher()
                logging.info("偵測到裝置變更，掃描 ADB...")
                self.handle_usb_event()
            except Exception as e:
                logging.error(f"WMI 錯誤: {e}")
                time.sleep(2)

    def handle_usb_event(self):
        # 呼叫 ADB 處理腳本
        try:
            subprocess.run(["python", "daemon/adb_handler.py", "auto"],
                           cwd="D:/Lightning-AI-ALL",
                           timeout=60,
                           check=False)
        except Exception as e:
            logging.error(f"ADB 處理失敗: {e}")

if __name__ == '__main__':
    win32serviceutil.HandleCommandLine(USBWatcherService)