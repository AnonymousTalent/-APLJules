# usb_service.py
import win32serviceutil
import win32service
import win32event
import servicemanager
import socket
import sys
from usb_watcher import wmi_loop

class USBWatcherService(win32serviceutil.ServiceFramework):
    _svc_name_ = "LightningUSBWatcher"
    _svc_display_name_ = "Lightning AI USB Watcher"
    _svc_description_ = "監聽 USB 插入事件並自動觸發 AI 部署"

    def __init__(self, args):
        win32serviceutil.ServiceFramework.__init__(self, args)
        self.hWaitStop = win32event.CreateEvent(None, 0, 0, None)
        socket.setdefaulttimeout(60)

    def SvcStop(self):
        self.ReportServiceStatus(win32service.SERVICE_STOP_PENDING)
        win32event.SetEvent(self.hWaitStop)

    def SvcDoRun(self):
        servicemanager.LogMsg(servicemanager.EVENTLOG_INFORMATION_TYPE,
                              servicemanager.PYS_SERVICE_STARTED,
                              (self._svc_name_, ''))
        self.main()

    def main(self):
        wmi_loop()   # 這個函數會持續監聽 USB 事件

if __name__ == '__main__':
    win32serviceutil.HandleCommandLine(USBWatcherService)