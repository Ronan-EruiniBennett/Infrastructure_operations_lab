#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./scripts/config.sh
source "$SCRIPT_DIR/config.sh"

### HOST DOCKER NETWORK STATE ###
# Confirms Docker's host-side bridge exists and has an IP address.
# Also checks that the VM host has a route to the Docker bridge subnet via docker0.

echo "== Host Docker network state =="

# Check if the docker0 interface exists.
echo "[1] Checking data link layer state of docker0 interface:"
if ip link show docker0 >/dev/null 2>&1; then
    echo "PASS: docker0 interface exists"
else
    echo "FAIL: docker0 interface does not exist"
    echo "Meaning: Docker may not be running, bridge networking may be disabled, or Docker may be misconfigured."
    exit 1
fi

# Check if the docker0 interface has an IPv4 address assigned.
echo
echo "[2] Checking IPv4 address of docker0 interface:"
if ip -4 addr show docker0 2>/dev/null | grep -q "inet "; then
    echo "PASS: docker0 interface has an IPv4 address"
    ip -4 addr show docker0
else
    echo "FAIL: docker0 interface does not have an IPv4 address"
    echo "Meaning: docker0 exists at Layer 2, but may not have a usable Layer 3 subnet."
    exit 1
fi

# Check if the VM host has a route to the Docker bridge subnet via docker0.
echo
echo "[3] Checking VM host route to the Docker bridge subnet via docker0:"
if ip route show dev docker0 2>/dev/null | grep -q .; then
    echo "PASS: VM host has a route to the Docker bridge subnet via docker0"
    ip route show dev docker0
else
    echo "FAIL: VM host does not have a route to the Docker bridge subnet via docker0"
    echo "Meaning: docker0 may exist, but the VM host may not know how to route traffic to containers on the Docker bridge subnet."
    exit 1
fi


### CONTAINER NETWORK STATE ###
# Confirms the running container has an IP address and a default route.
# This verifies the container's network namespace is configured.

### EGRESS TESTS ###
# Confirms the VM and container can reach the public internet by IP.
# Then checks DNS resolution separately so DNS failures are not confused with general connectivity failures.

### INGRESS / SERVICE PATH TESTS ###
# Confirms the VM has expected listening ports.
# Then tests the backend directly and through Nginx to distinguish app/container faults from reverse-proxy faults.

### INGRESS TESTS ###
# IP link to check container brigde exists at data link layer
# IP addr to check container bridge has an ip address
# IP route to check container bridge has a default route
# ss -tulpen to check listening ports



### EGRESS TESTS ###
# Vm connectivity test ping
# Vm dns test ping google.com
# Container connectivity test ping
# Container dns test ping google.com
# Container exec ip route to check default route exists
# Container exec ip addr to check container has an ip address

