# Nmap Recon Project

A simple network reconnaissance toolkit I built while learning **Nmap** and the
basics of cybersecurity. It automates the standard scanning workflow
(host discovery → port scan → version detection → NSE scripts) and saves the
results.

> ⚖️ **Legal / ethics:** Only use these scripts on machines you **own** or have
> **written permission** to test (your own lab, [scanme.nmap.org](http://scanme.nmap.org),
> or platforms like TryHackMe). Scanning systems without permission is illegal.

---

## What's in this project

| File | Description |
|------|-------------|
| `recon-simple.sh` | A plain, beginner-friendly version. No colours, just the raw Nmap steps. I wrote this one fully myself. |
| `recon.sh` | An improved version with colour output and saved report files. I used an AI assistant to help with the colour formatting; the scanning logic is my own. |
| `DVWA-Security-Assessment.md` | A sample security assessment report I wrote after testing a local DVWA lab. |

---

## The scanning workflow

Both scripts follow the methodology I learned:

```
1. Host discovery     -> is the target alive?      (nmap -sn)
2. Port scan          -> which ports are open?      (nmap)
3. Service versions   -> what software is running?  (nmap -sV)
4. Default scripts    -> gather extra info          (nmap -sC)
```

---

## How to use

```bash
# make the scripts executable (one time)
chmod +x recon-simple.sh recon.sh

# run the simple version
./recon-simple.sh scanme.nmap.org

# run the improved version (saves reports to a folder)
./recon.sh scanme.nmap.org
```

---

## Example output

Running `./recon.sh scanme.nmap.org` found:

```
PORT      SERVICE    VERSION
21/tcp    ftp        tcpwrapped
22/tcp    ssh        OpenSSH 6.6.1p1 Ubuntu
80/tcp    http       Apache httpd 2.4.7 (Ubuntu)
9929/tcp  nping-echo Nping echo
```

The improved version saves each stage to a `recon_<target>/` folder.

---

## What I learned building this

- How IP addresses, ports, and subnets work
- The TCP three-way handshake (SYN → SYN-ACK → ACK)
- The difference between connect scans (`-sT`) and stealth scans (`-sS`)
- Service version detection (`-sV`) and OS detection (`-O`)
- The Nmap Scripting Engine (NSE) for deeper enumeration
- How to write a basic security assessment report

---

## Tools used

- [Nmap](https://nmap.org/) — network scanner
- Bash — scripting
- DVWA — practice target (local lab)

---

*Built by Nour Salepan while learning cybersecurity.
AI was used to help with the colour formatting in `recon.sh`; all scanning
logic and testing is my own.*
