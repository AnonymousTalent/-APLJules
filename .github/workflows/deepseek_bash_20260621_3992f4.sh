#!/data/data/com.termux/files/usr/bin/bash
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