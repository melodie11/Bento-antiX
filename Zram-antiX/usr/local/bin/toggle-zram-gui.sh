#!/bin/bash
#
# ZRAM control script with YAD graphical interface.
#
# Debugging lines - Uncomment two next lines to debug
# REMOVE THESE LINES AFTER DEBUGGING IF NOT NEEDED ANYMORE!
#set -x # Enable command tracing
#exec > /tmp/toggle-zram-gui-debug.log 2>&1 # Redirect all output to a log file
# End Debugging lines

ZRAM_INIT_SCRIPT="/etc/init.d/zram"

# Function to display final status messages (success or error) with Yad and notify-send.
# This message will require an OK click to close, as it's a final status report.
# Usage: show_final_message <type> <title> <text>
show_final_message() {
    local type="$1"
    local title="$2"
    local text="$3"
    local icon=""

    case "$type" in
        info) icon="dialog-information" ;;
        error) icon="dialog-error" ;;
        *) icon="dialog-information" ;; # Default
    esac

    notify-send --expire-time=5000 --icon="$icon" "$title" "$text" 2>/dev/null &
    yad --title="$title" --text="$text" --image="$icon" --button=OK:0 --center &
}

# Function to display temporary messages that close automatically.
# Usage: show_temporary_message <type> <title> <text> <timeout_seconds>
show_temporary_message() {
    local type="$1"
    local title="$2"
    local text="$3"
    local timeout_seconds="$4"
    local icon=""

    case "$type" in
        info) icon="dialog-information" ;;
        error) icon="dialog-error" ;;
        *) icon="dialog-information" ;; # Default
    esac

    notify-send --expire-time=3000 --icon="$icon" "$title" "$text" 2>/dev/null &
    yad --title="$title" --text="$text" --image="$icon" --timeout="$timeout_seconds" --no-buttons --center &
}


# --- Script Execution Start ---

# Check if YAD is installed
if ! command -v yad &> /dev/null; then
    show_final_message error "Error" "YAD is not installed. Please install it to use this script."
    exit 1
fi

# Check if the ZRAM init script exists
if [ ! -f "${ZRAM_INIT_SCRIPT}" ]; then
    show_final_message error "ZRAM Error" "ZRAM init script not found at ${ZRAM_INIT_SCRIPT}."
    exit 1
fi

# Main script logic based on arguments
case "$1" in
    start|stop)
        action_verb="$1"
        action_past_participle=""

        if [ "$action_verb" = "start" ]; then
            action_past_participle="started"
        else
            action_past_participle="stopped"
        fi

        # Display a temporary message while the operation is in progress
        show_temporary_message info "ZRAM Control" "Attempting to ${action_verb} ZRAM..." 3

        # Execute the ZRAM init script directly. Assumes root privileges are already granted.
        # Output is redirected to a temporary log for potential debugging of the init script itself.
        temp_log="/tmp/zram_script_output.log"
        "${ZRAM_INIT_SCRIPT}" "$action_verb" > "$temp_log" 2>&1
        command_status=$? # Status of the init script command

        # Check the actual state of ZRAM after the command execution
        zram_active=$(grep -c "/dev/zram" /proc/swaps) # Count active zram devices

        # Determine success/failure based on actual ZRAM state
        if [ "$action_verb" = "start" ]; then
            if [ "$zram_active" -gt 0 ]; then
                show_final_message info "ZRAM Control" "ZRAM ${action_past_participle} successfully."
            else
                # If ZRAM is not active after a 'start' command, it's a failure.
                show_final_message error "ZRAM Error" "Failed to ${action_verb} ZRAM. Exit status: $command_status. Check logs for details: $temp_log"
            fi
        elif [ "$action_verb" = "stop" ]; then
            if [ "$zram_active" -eq 0 ]; then
                show_final_message info "ZRAM Control" "ZRAM ${action_past_participle} successfully."
            else
                # If ZRAM is still active after a 'stop' command, it's a failure.
                show_final_message error "ZRAM Error" "Failed to ${action_verb} ZRAM. Exit status: $command_status. Check logs for details: $temp_log"
            fi
        fi

        # Clean up temporary log file
        rm -f "$temp_log"
        ;;
    *)
        # The main YAD menu (if the script is called without start/stop arguments).
        # This one must remain in the foreground as it's the main interactive form.
        yad --form --title="ZRAM Control" --text="Choose an action for ZRAM." \
            --field="Start ZRAM":fbtn "bash -c '${0} start'" \
            --field="Stop ZRAM":fbtn "bash -c '${0} stop'" \
            --button="Close:1" \
            --center --fixed --width=300 --height=150
        ;;
esac

exit 0
