### Password Cracker with John the Ripper

---

### 🔎 Overview
This project demonstrates the use of **John the Ripper**, an industry-standard password cracking tool, to highlight the risks of weak passwords.  
By simulating a small cracking exercise inside a controlled environment, I show how attackers can recover plaintext passwords from hashes when weak wordlists are used.  

This lab reinforces the importance of strong password policies, salted/slow hashing algorithms, and multi-factor authentication.

---

### 🖥️ Environment Setup
- **Host Machine:** macOS (Apple Silicon)  
- **Virtualization:** UTM (QEMU-based hypervisor for ARM)  
- **Guest OS:** Ubuntu 24.04 LTS (ARM64)  
- **Tool Used:** John the Ripper  

---

### ⚙️ Lab Steps

### Step 1 — Install John the Ripper
```bash
sudo apt update && sudo apt install -y john
john --version
```
