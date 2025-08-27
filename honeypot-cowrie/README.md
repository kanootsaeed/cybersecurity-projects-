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
![step 2](./screenshots/02-install-dependencies.png)

### 3. Create a Dedicated User for Cowrie

Create a non-privileged user account for running Cowrie:

```bash
sudo adduser --disabled-password cowrie
```
You will be prompted to enter user details (Full Name, Room Number, etc.).
Press ENTER to accept the defaults, or enter placeholder values if you prefer.
![step 3](./screenshots/03-create-cowrie-user.png)

### 4. Clone the Cowrie Repository  

Switch to the `cowrie` user and clone the official Cowrie repository from GitHub:  

```bash
su - cowrie
git clone https://github.com/cowrie/cowrie.git
cd cowrie
```
![step 4](./screenshots/04-clone-cowrie-repo.png) 

### 5. Create and Activate Python Virtual Environment  

Cowrie should be installed inside a virtual environment to keep dependencies isolated.  

```bash
python3 -m venv cowrie-env
source cowrie-env/bin/activate
```
![step 5](./screenshots/05-setup-venv.png)

### 6. Install Python Dependencies

Cowrie requires several Python libraries. Install all dependencies listed in the `requirements.txt` file:

```bash
pip install --upgrade pip
pip install -r requirements.txt
```
After installation, verify the packages with:
```
pip list
```
![step 6](./screenshots/06-install-pip-dependencies.png) 


