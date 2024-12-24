
# 🚀 Ollama, Python & Open WebUI Setup

Welcome to **Ollama WebUI Automator** – the ultimate script for installing and configuring Ollama, Python 3.10.x, Docker, and Open WebUI! This automation tool streamlines the setup process, ensuring you have everything ready to go with minimal effort.

## 🔧 Features
- **Automated Installation** of Ollama and Python 3.10.x
- **Docker Image Management** for Open WebUI
- **Port Availability Detection** to avoid conflicts
- **Stable Diffusion WebUI Cloning/Updating**
- **Python Path Auto-Detection & Configuration**
- **Retry Logic** for Python Installation

## 📋 Requirements
- **Windows 10/11**
- **Administrator Privileges** for Installations
- **Docker Desktop** (installed and running)
- **Internet Connection** for downloads

## 📥 Installation
### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/ollama-webui-automator.git
cd ollama-webui-automator
```

### 2. Run the Script
```powershell
./setup.ps1
```
- The script will detect existing installations of Python and Ollama.
- If Python 3.10.x is not found, the script downloads and installs it.
- Docker images for Open WebUI will be pulled and started.

## 🛠️ Configuration
### Python Detection and Path Configuration
- The script checks common Python installation paths:
  - `C:\Python310\`
  - `C:\Program Files\Python310\`
  - `C:\Users\<User>\AppData\Local\Programs\Python\Python310\`
- If Python is found but not added to the system PATH, the script adds it automatically.

### Docker Setup
- If Docker Desktop is not installed, the script will prompt you to install it.
- The Open WebUI Docker container is automatically restarted if it already exists.

## 🖥️ Usage
Once installed, access Open WebUI by visiting:
```
http://localhost:8080
```

## 🧩 Troubleshooting
- **Python Not Detected**: Ensure Python is installed at one of the common paths or manually install Python 3.10.x.
- **Docker Issues**: Ensure Docker Desktop is running and that no other containers are occupying the specified ports.
- **Firewall/Permissions**: Grant permissions if Windows prompts during installation.

## 📦 Updating Stable Diffusion WebUI
To manually update Stable Diffusion WebUI, run:
```powershell
cd D:\AI\Automatic1111\stable-diffusion-webui
git pull
```

## 🎯 Contributing
Feel free to submit PRs and issues! Contributions are welcome to improve the script or add new features.

## 📄 License
MIT License. See `LICENSE` for details.

---

**By**: [Your Name](https://github.com/yourusername) 😊
