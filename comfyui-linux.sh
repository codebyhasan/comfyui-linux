#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="$HOME/ComfyUI"

echo "=== 🖼️ Setting up ComfyUI ==="

# ── System dependencies ──
sudo apt update
sudo apt install -y git wget python3 python3-venv python3-pip jq netcat

# ── Clone repo ──
if [ ! -d "$WORKSPACE" ]; then
  git clone https://github.com/comfyanonymous/ComfyUI "$WORKSPACE"
else
  echo "[*] ComfyUI already exists at $WORKSPACE"
fi

cd "$WORKSPACE"

# ── Python deps ──
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cu121

# ── Create model folders ──
mkdir -p ./models/checkpoints ./models/vae ./models/text_encoders ./models/diffusion_models ./models/loras

# ── Download models ──
wget -c https://huggingface.co/Comfy-Org/stable-diffusion-v1-5-archive/resolve/main/v1-5-pruned-emaonly-fp16.safetensors -P ./models/checkpoints/
wget -c https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors -P ./models/vae/
wget -c https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors -P ./models/text_encoders/
wget -c https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors -P ./models/vae/
wget -c https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors -P ./models/diffusion_models/
wget -c https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors -P ./models/diffusion_models/
wget -c https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors -P ./models/loras/
wget -c https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors -P ./models/loras/

# ── Install cloudflared ──
wget -O cloudflared-linux-amd64.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb || true

# ── Start ComfyUI ──
echo "[*] Starting ComfyUI..."
python3 main.py --dont-print-server &

echo "[*] Waiting for ComfyUI on port 8188..."
while ! nc -z 127.0.0.1 8188; do sleep 1; done

# ── Start cloudflared and save URL ──
echo "[*] Starting cloudflared tunnel..."
cloudflared tunnel --url http://127.0.0.1:8188 2>&1 | tee >(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' | head -n 1 > tunnel.txt)
