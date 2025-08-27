# Cowrie SSH/Telnet Honeypot  

## 🔎 Overview  
This project demonstrates the deployment and configuration of **Cowrie**, a medium-interaction SSH/Telnet honeypot. The honeypot is designed to emulate a vulnerable system, attract attackers, and capture their behavior in a controlled environment.  

By setting this up, I simulated how adversaries attempt to connect to exposed SSH services and captured the logs of their login attempts and commands. This is a foundational project for developing skills in intrusion detection, log analysis, and adversary emulation.  

---

## 🛠️ Environment Setup  

- **Host Machine:** macOS (Apple Silicon)  
- **Virtualization:** [UTM](https://mac.getutm.app/) (QEMU-based hypervisor for ARM)  
- **Guest OS:** Ubuntu 24.04 LTS (ARM64)  
- **Honeypot Software:** Cowrie (Python3-based)  

---

## ⚙️ Installation Steps  

### 1. System Update  
After installing Ubuntu, updated and upgraded system packages:  

```bash
sudo apt update && sudo apt upgrade -y
```
![Step 1](./screenshots/01-system-update.png)

### 2. Install Required Dependencies  

Cowrie requires Python3, Git, and several supporting libraries.  

```bash
sudo apt install -y git python3 python3-venv python3-dev libssl-dev libffi-dev build-essential authbind less
```
