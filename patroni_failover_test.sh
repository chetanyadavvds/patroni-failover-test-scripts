#!/bin/bash
###############################################################################
# Script Name : patroni_failover_test.sh
#
# Purpose:
#   Automate PostgreSQL Patroni cluster failover testing.
#
# Description:
#   - Detect current Patroni cluster leader
#   - Stop leader node
#   - Validate automatic failover
#   - Confirm new leader election
#
# Usage:
#   ./patroni_failover_test.sh
#
# Requirements:
#   - Patroni installed
#   - patronictl available in PATH
#   - SSH access to cluster nodes
#   - PostgreSQL cluster already configured
#
# Exit Codes:
#   0 = Success
#   1 = Error
#
###############################################################################

LOG_DIR="./logs"
DATE=$(date '+%Y%m%d_%H%M%S')
LOG_FILE="$LOG_DIR/patroni_failover_test_$DATE.log"

mkdir -p "$LOG_DIR"

echo "=================================" | tee -a "$LOG_FILE"
echo "Patroni Failover Test Started" | tee -a "$LOG_FILE"
echo "Time: $(date)" | tee -a "$LOG_FILE"
echo "=================================" | tee -a "$LOG_FILE"

echo "Checking Patroni cluster status..." | tee -a "$LOG_FILE"
patronictl list | tee -a "$LOG_FILE"

LEADER=$(patronictl list | awk '/Leader/ {print $2}')

if [ -z "$LEADER" ]; then
    echo "ERROR: Could not determine cluster leader." | tee -a "$LOG_FILE"
    exit 1
fi

echo "Current Leader Node: $LEADER" | tee -a "$LOG_FILE"

echo "Simulating leader failure..." | tee -a "$LOG_FILE"

ssh "$LEADER" "sudo systemctl stop patroni" 2>&1 | tee -a "$LOG_FILE"

echo "Waiting for failover..." | tee -a "$LOG_FILE"
sleep 15

echo "Checking cluster status after failover..." | tee -a "$LOG_FILE"
patronictl list | tee -a "$LOG_FILE"

NEW_LEADER=$(patronictl list | awk '/Leader/ {print $2}')

if [ "$NEW_LEADER" == "$LEADER" ]; then
    echo "FAILOVER FAILED - Leader did not change." | tee -a "$LOG_FILE"
    exit 1
else
    echo "SUCCESS - New Leader elected: $NEW_LEADER" | tee -a "$LOG_FILE"
fi

echo "=================================" | tee -a "$LOG_FILE"
echo "Failover Test Completed" | tee -a "$LOG_FILE"
echo "=================================" | tee -a "$LOG_FILE"

exit 0
