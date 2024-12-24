### PowerShell Script: Install and Configure Ollama, Python, and Open WebUI
clear-host

# Configuration
$config = @{
    ollamaInstaller = "https://ollama.com/download/OllamaSetup.exe"
    ollamaPath = "C:\Program Files\Ollama\ollama.exe"
    dockerImage = "ghcr.io/open-webui/open-webui:main"
    containerName = "open-webui"
    webUIPort = 8080
    dataVolume = "open-webui"
    stableDiffusionRepo = "https://github.com/AUTOMATIC1111/stable-diffusion-webui.git"
    clonePath = "D:\AI\Automatic1111\stable-diffusion-webui"
    pythonInstaller = "https://www.python.org/ftp/python/3.10.6/python-3.10.6-amd64.exe"
    pythonPath = ""
}

# Function to find an available port
function Get-AvailablePort {
    param ([int]$startPort = 8080)
    $port = $startPort
    while ($true) {
        $test = netstat -an | Select-String ":$port"
        if (-not $test) {
            return $port
        }
        $port++
    }
}

# Function to add Python to environment variables if not present
function Add-PythonToPath {
    param ([string]$pythonPath)
    $envPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if ($envPath -notmatch [regex]::Escape($pythonPath)) {
        Write-Host "Adding Python to system PATH..."
        [System.Environment]::SetEnvironmentVariable("Path", "$envPath;$pythonPath", [System.EnvironmentVariableTarget]::Machine)
    }
}

# Function to find all Python installations and locate Python 3.10.x
function Find-Python310 {
    $potentialPaths = @(
        "C:\Python310\python.exe",
        "C:\Program Files\Python310\python.exe",
        "C:\Program Files (x86)\Python310\python.exe",
        "$env:LOCALAPPDATA\Programs\Python\Python310\python.exe",
        "$env:APPDATA\Python\Python310\python.exe"
    )
    $foundVersions = @()
    foreach ($path in $potentialPaths) {
        if (Test-Path $path) {
            $version = & $path --version 2>&1
            $foundVersions += "Python $version at $path"
            if ($version -match "3.10.") {
                Write-Host "Found compatible Python at: $path"
                $config.pythonPath = $path
                Add-PythonToPath (Split-Path -Parent $path)
                return $true
            }
        }
    }
    
    Write-Host "Python 3.10.x not found in standard paths. Checking system PATH..."
    $pythonPaths = & where python | Select-String "python.exe"
    foreach ($path in $pythonPaths) {
        $version = & $path --version 2>&1
        $foundVersions += "Python $version at $path"
        if ($version -match "3.10.") {
            Write-Host "Found compatible Python in PATH at: $path"
            $config.pythonPath = $path
            return $true
        }
    }
    
    Write-Host "All detected Python versions:"
    $foundVersions | ForEach-Object { Write-Host $_ }
    Write-Host "Python 3.10.x not found."
    return $false
}

# Function to check Python version
function Check-PythonVersion {
    if ($config.pythonPath -ne "") {
        $version = & $config.pythonPath --version 2>&1
        if ($version -match "3.10.6") {
            Write-Host "Compatible Python version detected: $version"
            return $true
        } else {
            Write-Host "Incompatible Python version: $version"
            return $false
        }
    }
    return $false
}

# Function to install Python with retry
function Install-Python {
    $installerPath = "$env:TEMP\python-3.10.6-amd64.exe"
    Write-Host "Downloading Python 3.10.6..."
    Invoke-WebRequest -Uri $config.pythonInstaller -OutFile $installerPath
    
    Write-Host "Running Python installer as Administrator..."
    Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait -Verb RunAs
    
    # Retry if the installation fails
    if (!(Find-Python310)) {
        Write-Host "Retrying Python installation..."
        Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait -Verb RunAs
    }

    if (Find-Python310) {
        Write-Host "Python installed successfully."
    } else {
        Write-Host "Python installation failed after retry. Please install manually."
        Exit 1
    }
}

# Function to check if Ollama is running
function Check-OllamaRunning {
    $ollamaRunning = Get-Process | Where-Object { $_.ProcessName -like "*ollama*" }
    if ($ollamaRunning) {
        Write-Host "Ollama process is running."
        return $true
    } else {
        Write-Host "Ollama process not found. Proceeding with installation..."
        return $false
    }
}

# Function to install Ollama
function Install-Ollama {
    $installerPath = "$env:TEMP\OllamaSetup.exe"
    Write-Host "Downloading Ollama installer..."
    Invoke-WebRequest -Uri $config.ollamaInstaller -OutFile $installerPath
    
    Write-Host "Running Ollama installer..."
    Start-Process -FilePath $installerPath -ArgumentList "/silent" -Wait
    
    if (Test-Path $config.ollamaPath) {
        Write-Host "Ollama installed successfully."
    } else {
        Write-Host "Ollama installation failed. Please install manually."
        Exit 1
    }
}

# Main script logic
if (-not (Find-Python310)) {
    Install-Python
}

if (-not (Check-OllamaRunning)) {
    Install-Ollama
}

Clone-Or-UpdateStableDiffusion
Install-OpenWebUI
