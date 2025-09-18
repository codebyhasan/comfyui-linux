
# 🖼️ ComfyUI Linux Setup Script

This script automates the installation and setup of ComfyUI on Linux systems, providing a seamless experience for users to deploy ComfyUI with Stable Diffusion models and access it via a public tunnel.

> **Note:** You can run this script in Google Colab to use free NVIDIA GPUs for faster model inference.

---

## 🚀 One-Line Installer

To install and run the script in one command:

```bash
sudo wget -c https://raw.githubusercontent.com/codebyhasan/comfyui-linux/main/comfyui-linux.sh; sudo chmod +x comfyui-linux.sh; sudo ./comfyui-linux.sh
```

---

## 📦 What the Script Does

* **Installs Required System Dependencies**: Ensures your system has all necessary packages.
* **Clones the ComfyUI Repository**: Retrieves the latest ComfyUI code from GitHub.
* **Installs Python Dependencies**: Sets up Python environment and installs required packages.
* **Downloads Pre-trained Models**: Fetches Stable Diffusion and Wan 2.2 models for image generation.
* **Sets Up Model Directories**: Creates necessary directories for model storage.
* **Installs Cloudflared**: Downloads and installs the Cloudflare tunnel client.
* **Starts ComfyUI Server**: Launches the ComfyUI application.
* **Creates a Public Tunnel**: Exposes the local ComfyUI server to the internet via Cloudflare Tunnel.
* **Saves Tunnel URL**: Stores the generated public URL in `tunnel.txt` for easy access.

---

## 🛠️ Requirements

* Linux-based operating system
* Bash shell
* `curl` and `bash` installed
* Internet connection

---

## 📁 Output

* **ComfyUI Installation Directory**: `~/ComfyUI`
* **Tunnel URL**: Saved in `tunnel.txt` in the current directory

---

## 🔐 Accessing ComfyUI

After running the script:

1. Open the `tunnel.txt` file to find the public URL.
2. Navigate to the URL in your web browser to access ComfyUI.

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
