# Patroni Failover Test Scripts

Automation scripts to test failover behavior in PostgreSQL Patroni clusters.

These scripts simulate leader failure and verify automatic leader election.

---

## Features

- Detect current Patroni leader
- Simulate leader node failure
- Validate automatic failover
- Confirm new leader election
- Generate failover logs

---

## Prerequisites

- PostgreSQL cluster managed by Patroni
- SSH access between nodes
- patronictl installed
- Linux environment

---

## Installation

Clone repository:

```bash
git clone https://github.com/chetanyadavvds/patroni-failover-test-scripts.git
cd patroni-failover-test-scripts
## Make script executable:
chmod +x patroni_failover_test.sh

Run the failover test:
./patroni_failover_test.sh

Example Output
Current Leader Node: node1
Simulating leader failure...
Waiting for failover...

SUCCESS - New Leader elected: node2
