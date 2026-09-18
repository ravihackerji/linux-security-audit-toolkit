# Linux Security Audit Toolkit — Architecture

## 1. Overview

The Linux Security Audit Toolkit is a modular Bash-based security assessment framework designed to inspect a Linux host for common security weaknesses, configuration problems, suspicious services, persistence mechanisms, and system-level security controls.

The toolkit follows a modular architecture so that individual security checks can be executed independently or through the main orchestrator.

---

## 2. High-Level Architecture

```text
                    Linux Host
                        |
                        v
                +---------------+
                |    main.sh    |
                +-------+-------+
                        |
        +---------------+----------------+
        |               |                |
        v               v                v
   System Audit     User Audit      Network Audit
        |               |                |
        +---------------+----------------+
                        |
                        v
              +-------------------+
              | Security Baseline |
              +---------+---------+
                        |
                        v
              +-------------------+
              | Findings Engine   |
              +---------+---------+
                        |
                +-------+-------+
                |               |
                v               v
          Text Report      JSON Report
