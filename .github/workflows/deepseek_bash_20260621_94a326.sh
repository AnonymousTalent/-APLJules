#!/data/data/com.termux/files/usr/bin/bash
# android_agent/boot_ai_agent.sh

LOG_FILE="/sdcard/ai_boot.log"
echo "[$(date)] AI 啟動腳本開始執行" >> $LOG_FILE

# 更新套件
pkg update -y && pkg upgrade -y >> $LOG_FILE 2>&1
pkg install -y python git cmake wget >> $LOG_FILE 2>&1

# 下載 llama.cpp（若無）
cd ~
if [ ! -d "llama.cpp" ]; then
    git clone https://github.com/ggerganov/llama.cpp >> $LOG_FILE 2>&1
fi
cd llama.cpp
make -j4 >> $LOG_FILE 2>&1

# 下載輕量模型（若無）
if [ ! -f "models/qwen2.5-0.5b-q4_k_m.gguf" ]; then
    mkdir -p models
    wget -O models/qwen2.5-0.5b-q4_k_m.gguf \
         https://huggingface.co/Qwen/Qwen2.5-0.5B-GGUF/resolve/main/qwen2.5-0.5b-q4_k_m.gguf \
         >> $LOG_FILE 2>&1
fi

# 啟動 AI 服務（背景執行）
nohup ./llama-cli -m models/qwen2.5-0.5b-q4_k_m.gguf \
                  -p "AI ready, waiting for tasks." \
                  > /sdcard/ai_output.log 2>&1 &

echo "[$(date)] AI 服務已啟動" >> $LOG_FILE