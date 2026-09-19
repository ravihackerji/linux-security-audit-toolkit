# Usage Guide

## Run Complete Audit

```bash
./scripts/main.sh


Run Individual Modules

./scripts/system_audit.sh
./scripts/user_audit.sh
./scripts/network_audit.sh
./scripts/process_audit.sh
./scripts/log_audit.sh
./scripts/service_audit.sh
./scripts/persistence_audit.sh
./scripts/security_baseline.sh

#Generate JSON Report

./scripts/json_report.sh

#View Reports

ls -lah reports/
cat reports/security-report.txt
cat reports/security-report.json

#Check Git Status
git status

#Security Requirements

Run the toolkit only against systems you own or are authorized to assess.

The toolkit is designed for detection and assessment. It does not automatically perform destructive remediation.


---

# 3. Create `docs/incident-response.md`

```bash
nano docs/incident-response.md

Paste:

# Incident Response Guide

## Detection

Identify suspicious findings from the audit.

Examples:

- Unexpected UID 0 account
- Unauthorized service
- Suspicious listening port
- Unexpected persistence
- SSH configuration weakness
- Modified security-sensitive file

## Investigation

Collect evidence before changing the system.

Useful commands:

```bash
ps aux
sudo ss -lntup
systemctl status <service>
systemctl cat <service>
journalctl -u <service>
sudo ausearch -k identity_changes
sudo ausearch -k privilege_changes
Timeline

Determine:

When did the activity begin?
Which user performed it?
What process executed it?
What files changed?
What network connections existed?
Containment

Contain the affected component only after collecting appropriate evidence.

Examples:

Isolate a host
Restrict network access
Disable an unauthorized service
Revoke suspicious credentials
Eradication

Remove the confirmed malicious or unauthorized component.

Recovery

Restore normal operation and verify security controls.

Verification

Run the audit again:

./scripts/main.sh

The original finding should no longer appear.

Documentation

Record:

Finding ID
Evidence
Timeline
Impact
Actions taken
Verification results

---

# 4. Commit everything

```bash
git add .
git status

Then:

git commit -m "feat: finalize Linux security audit toolkit"
git push

Finally:

git status

Expected:

nothing to commit, working tree clean
