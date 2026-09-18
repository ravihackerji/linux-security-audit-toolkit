# Linux Security Audit Toolkit — Security Methodology

## 1. Purpose

The Linux Security Audit Toolkit performs a structured defensive security assessment of a Linux host.

The methodology is designed around:

1. Reconnaissance
2. Enumeration
3. Baseline comparison
4. Detection
5. Evidence collection
6. Severity assessment
7. Remediation
8. Verification

The toolkit is intended for systems that the operator owns or is authorized to assess.

---

# 2. Assessment Lifecycle

```text
+----------------+
| Reconnaissance |
+-------+--------+
        |
        v
+----------------+
|  Enumeration   |
+-------+--------+
        |
        v
+----------------+
|    Baseline    |
+-------+--------+
        |
        v
+----------------+
|    Detection   |
+-------+--------+
        |
        v
+----------------+
|    Evidence    |
+-------+--------+
        |
        v
+----------------+
|    Severity    |
+-------+--------+
        |
        v
+----------------+
|  Remediation   |
+-------+--------+
        |
        v
+----------------+
|  Verification  |
+----------------+
