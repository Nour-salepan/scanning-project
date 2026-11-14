# Security Assessment Report — DVWA Lab

**Author:** Nour Salepan
**Date:** 2026-11-14
**Target:** Damn Vulnerable Web Application (DVWA) — local lab (`localhost:8080`)
**Scope:** Authorised testing of my own lab environment only.

> ⚠️ **Legal note:** This assessment was performed on a deliberately vulnerable
> application running on my own machine, set up for learning. No third-party
> systems were scanned.

---

## 1. Executive Summary

A reconnaissance and configuration review of a local DVWA instance identified
**one critical vulnerability**: database credentials were exposed through a
publicly readable backup file, made reachable by an enabled directory listing.
Two lower-risk information-disclosure issues were also noted.

| # | Finding | Severity |
|---|---------|----------|
| 1 | Database credentials exposed via directory listing | 🔴 Critical |
| 2 | Web server version disclosure | 🟡 Medium |
| 3 | Backup/template files left on server | 🟠 High |

---

## 2. Methodology

The assessment followed a standard reconnaissance workflow using **Nmap**:

```
1. Host discovery      nmap -sn localhost
2. Port scanning       nmap -p- localhost
3. Service/version      nmap -sV -p 8080 localhost
4. OS detection        sudo nmap -O localhost
5. NSE scripts         nmap --script=http-enum,http-headers,http-methods -p 8080 localhost
6. Manual review       Browsed exposed directories in a web browser
```

---

## 3. Target Profile (Fingerprint)

| Attribute | Value |
|-----------|-------|
| Open port | 8080/tcp (http) |
| Web server | Apache/2.4.25 (Debian) |
| Operating system | Linux (Debian) |
| Application | DVWA v1.10 |
| Language | PHP |
| Security level | low |
| HTTP methods | GET, HEAD, POST, OPTIONS (no PUT/DELETE — good) |

---

## 4. Findings

### Finding 1 — Database Credentials Exposed via Directory Listing
**Severity:** 🔴 Critical

**Description:**
Directory listing is enabled on `/config/`. This allowed browsing to a backup
configuration file (`config.inc.php.bak`) which, unlike the live `.php` file,
is served as plain text and reveals the database credentials.

**Evidence:**
```
$ nmap --script=http-enum -p 8080 localhost
  /config/: Potentially interesting directory w/ listing

Exposed at: http://localhost:8080/config/config.inc.php.bak

  db_user     = 'app'
  db_password = 'vulnerables'
  db_database = 'dvwa'
```

**Impact:**
An unauthenticated attacker obtains valid database credentials and could read,
alter, or delete the entire database.

**Remediation:**
1. Disable directory listing (`Options -Indexes` in Apache).
2. Remove backup files (`.bak`, `.old`, `.dist`) from the web root.
3. Store configuration outside the web root.
4. Never store passwords in plain text.

---

### Finding 2 — Web Server Version Disclosure
**Severity:** 🟡 Medium

**Description:**
HTTP response headers reveal the exact server software and version
(`Apache/2.4.25 (Debian)`), helping an attacker search for version-specific
exploits.

**Evidence:**
```
$ nmap --script=http-headers -p 8080 localhost
  Server: Apache/2.4.25 (Debian)
```

**Impact:**
Speeds up an attacker's search for known vulnerabilities (CVEs) for that version.

**Remediation:**
Set `ServerTokens Prod` and `ServerSignature Off` in Apache so only "Apache"
is shown, with no version.

---

### Finding 3 — Backup and Template Files Left on Server
**Severity:** 🟠 High

**Description:**
The `/config/` directory contained `config.inc.php.bak` and
`config.inc.php.dist`. Because the server does not execute `.bak`/`.dist`
files as PHP, their source is served as plain text.

**Evidence:**
```
Index of /config
  config.inc.php
  config.inc.php.bak   <-- served as plain text
  config.inc.php.dist  <-- served as plain text
```

**Impact:**
Exposes source code and secrets that the live `.php` file would normally hide.

**Remediation:**
Remove all backup and template files from production servers; block these
extensions in the web server configuration.

---

## 5. Conclusion

The DVWA lab, as expected, contained serious misconfigurations. The most
critical was the exposure of database credentials through a combination of
directory listing and a leftover backup file — a realistic chain that causes
real-world breaches. All findings have clear, low-cost remediations.

**Skills demonstrated:** network scanning (Nmap), service enumeration (NSE),
manual verification, vulnerability analysis, and professional reporting.
