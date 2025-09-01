# Playbook: SSH Brute Force on Cowrie

## Trigger
- R1: ≥10 failed SSH / 5m by src_ip (MED)
- R2: any SUCCESS to Cowrie (HIGH)

## Triage (first 5 min)
- [ ] Confirm alert details (src_ip, count, window)
- [ ] Check `cowrie.login.success` from same IP
- [ ] Review usernames in `results/events.csv`
- [ ] Enrich IP (whois/reputation/geo)
- [ ] Look for commands (see `results/commands.csv`)

## Decision
- Contain: block IP (lab)
- Escalate: create IR case (Jira/ServiceNow)
- Close/Tune: raise threshold / whitelist known scanner

## Evidence to attach
- `results/events.csv` excerpt
- `results/top_attackers.csv`
- Alert/query screenshot
