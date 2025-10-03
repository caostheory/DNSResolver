# 🌐 UnboundConfig

A personal **Unbound DNS** configuration repository, ready for **AdGuard Home** or **Pi-hole** integration.  
Includes ready-to-use configuration files and detailed setup instructions.

![GitHub Repo Size](https://img.shields.io/github/repo-size/caostheory/DNSResolver) ![License](https://img.shields.io/github/license/caostheory/DNSResolver) ![Last Commit](https://img.shields.io/github/last-commit/caostheory/DNSResolver)

---

## 📑 Table of Contents

1. [Features](#features)    
2. [Installation](#installation)    
3. [Testing Your Setup](#testing-your-setup)
4. [Integration](#integration)  
5. [Tips](#tips)  

---

## 🚀 Features of This Configuration <a name="features"></a>

This configuration is optimized for **security**, **privacy**, and **performance** in both BSD and Linux environments, designed to integrate seamlessly with **AdGuard Home** or **Pi-hole**.  
Key features include:

- 🔒 **Security Enhancements**  
  - Runs in a **chroot jail** for additional process isolation.  
  - Configured as a [recursive resolver](#why-a-recursive-resolver) querying authoritative servers directly (no external forwarders).  
  - Full **DNSSEC validation** with hardened settings (against stripped signatures, glue records, and downgrade attacks).  
  - Strict access control, allowing only local queries (`127.0.0.1` / `::1`).  
  - Filtering of private and reserved IP ranges to prevent DNS leaks.  
  - Protection against ANY queries (`deny-any: yes`).  

- 🕵️ **Privacy Protections**  
  - **QNAME minimisation** enabled to limit data shared upstream.  
  - Hides server identity, version, and trust anchor information.  
  - No EDNS Client Subnet forwarding.  

- ⚡ **Performance Optimizations**  
  - Large cache sizes (`rrset: 256 MB`, `msg: 128 MB`) with prefetching of popular records.  
  - Support for expired record serving to improve resilience during outages.  
  - Multithreaded operation with memory slab separation for efficiency.  
  - Optimized buffer sizes and round-robin response ordering.  

- 🖥️ **Logging & Control**  
  - Centralized logging with adjustable verbosity.  
  - Remote control enabled (`unbound-control`) for status, stats, and dynamic reconfiguration.  

---

## 🔍 Why a Recursive Resolver? <a name="why-a-recursive-resolver"></a>

Unlike a forwarder (which depends on external DNS servers), this setup runs as a **fully recursive resolver**:

- ✅ Queries root servers directly → no third-party dependency  
- ✅ Stronger privacy → no ISP or external service can log your queries  
- ✅ Better security → combined with DNSSEC validation for trusted responses  

---

## Installation <a name="installation"></a>

   * Download the configuration file

     ```bash
     sudo fetch -o /usr/local/etc/unbound/unbound.conf \
     https://raw.githubusercontent.com/caostheory/DNSResolver/refs/heads/main/unbound.conf
     ```

   * Download Root Hints and Root Key

     ```bash
     # Download root.hints
     sudo fetch -o /usr/local/etc/unbound/root.hints \
     https://www.internic.net/domain/named.cache

     # Generate root.key
     sudo unbound-anchor -a /usr/local/etc/unbound/root.key
     ```

   * Create a directory for logs

     ```bash
     sudo mkdir -p /usr/local/etc/unbound/logs/
     ```

   * Generate server and control keys

     ```bash
     sudo unbound-control-setup
     ```

   * Set proper permissions

     ```bash
     sudo chown -R unbound:unbound /usr/local/etc/unbound/
     sudo chmod 600 /usr/local/etc/unbound/*.key
     ```

## Testing Your Setup <a name="testing-your-setup"></a>

   * Check DNS resolution:
   
     ```bash
     dig @127.0.0.1 -p 5335 example.com
     ```

   * Verify DNSSEC validation:
   
     ```bash
     dig @127.0.0.1 -p 5335 +dnssec www.internic.net
     ```

   * Check Unbound status and stats:
   
     ```bash
     sudo unbound-control status
     sudo unbound-control stats_noreset
     ```

## Integration <a name="integration"></a>

   * **AdGuard Home:** Use `127.0.0.1:5335` and `[::1]:5335` as upstream DNS.  
   * **Pi-hole:** Set custom DNS to `127.0.0.1#5335` and `::1#5335`.

## Tips <a name="tips"></a>

   * Regularly update `root.hints` using `rootUpdate.sh` in a cronjob.
   ```bash
   sudo fetch -o /usr/local/sbin/rootUpdate.sh \
   https://raw.githubusercontent.com/caostheory/DNSResolver/refs/heads/main/rootUpdate.sh

   # Make the script executable
   sudo chmod +x /usr/local/sbin/rootUpdate.sh
   ```
---

Made with ❤️ by [caostheory](https://github.com/caostheory)
