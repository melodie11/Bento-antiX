#!/bin/bash
#
# Network fix script for antiX Live
# Launched via a desktop file in /etc/xdg/autostart
#

LOG_FILE="/var/log/fix-live-network-autostart.log"

# Logging function for debugging
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE" 2>&1
}

log_message "Starting antiX Live Network Fix script via autostart."

# Check if we are in Live mode
if [ ! -d "/live" ]; then
    log_message "Not in Live mode, script not executed."
    exit 0
fi

log_message "Live mode detected."

# Test internet connectivity with ping
log_message "Testing internet connectivity via ping..."
if ping -c 3 www.example.com > /dev/null 2>&1; then
    log_message "Internet connectivity already active. No action required."
    exit 0
else
    log_message "No internet connectivity detected. Launching fix procedure."
fi

# Attempt to restart the network service
log_message "Attempting to restart network service via /etc/init.d/networking restart..."
/etc/init.d/networking restart >> "$LOG_FILE" 2>&1

# Verify after a delay
sleep 2 # Give DHCP time to work after restart
if ip a show | grep -q "inet "; then
    log_message "Network successfully restarted."
else
    log_message "Failed to restart /etc/init.d/networking. Attempting direct dhclient..."
    dhclient >> "$LOG_FILE" 2>&1 & # Run in background
sleep 2
    if ip a show | grep -q "inet "; then
        log_message "Direct dhclient worked."
    else
        log_message "Complete failure to start network."
    fi
fi

log_message "End of antiX Live Network Fix script."
exit 0
