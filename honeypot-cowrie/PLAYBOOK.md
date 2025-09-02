# Playbook: SSH Activity on Cowrie Honeypot

**Use when one of these rules fires:**
- **R1 (MED):** ≥10 failed SSH logins from the same `src_ip` within 5 minutes
- **R2 (HIGH):** any `cowrie.login.success` on the honeypot

---

## 0) Prep (1 minute)
- Open:
  - `results/events.csv` (timeline of attempts)
  - `results/top_attackers.csv` (counts by IP)
  - SIEM alert page (if you’re using one)
- Confirm which rule fired: R1 or R2.

---

## 1) Triage (first 5 minutes)
- [ ] Identify **source IP** from alert.
- [ ] Count **failures in 5m window** (R1) using `results/events.csv`.
- [ ] Check for **any success** from same IP (`cowrie.login.success`).
- [ ] Review **usernames/passwords tried** (look for defaults: `root`, `pi`).
- [ ] If available, review **commands** (see `results/commands.csv`).
- [ ] **Enrich IP** (whois/reputation/geo); note **cloud ASN** if applicable.

**Quick severity guidance**
- **HIGH**: any success OR commands seen → proceed to containment + escalate.
- **MEDIUM**: threshold brute force only; proceed to contain or tune.

---

## 2) Decision
- [ ] **Contain** (lab only): block the **source IP** at the edge or VM firewall.
- [ ] **Escalate**: open an **IR ticket** (Jira/ServiceNow). Title:  
  `Cowrie SSH Activity - <MED/HIGH> - <src_ip>`
- [ ] **Close/Tune**: if known scanner/benign, raise threshold or add allowlist.

---

## 3) Evidence to attach (copy/paste or upload)
- [ ] 3–5 lines from `results/events.csv` that show the pattern
- [ ] `results/top_attackers.csv` row for the offending IP
- [ ] (Optional) 1–2 lines from `results/commands.csv` if commands seen
- [ ] Screenshot of the alert/rule query in your SIEM

---

## 4) Post-incident (within 24h)
- [ ] Update **detections** if noisy (e.g., `≥15/5m`, or exclude known scanner ASN).
- [ ] Document any **IOCs** (IPs, user agents, command strings).
- [ ] Write **Lessons Learned** (what would have sped up triage?).
- [ ] Link the ticket here: `<CASE_URL>` (if using a tracker).

---

## Notes
- This is a **lab** playbook. Do not apply blocks to production networks.
- Cowrie is high-interaction; keep sessions only in isolated networks.

