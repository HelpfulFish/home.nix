{ pkgs, ... }:

let
  network-traffic = pkgs.writeShellScriptBin "network-traffic" ''
    #!/bin/bash

    # Find the primary ethernet interface (usually eth0, enp*, eno*, etc.)
    ETH_INTERFACE=$(ip route | grep default | awk '{print $5}' | head -1)

    if [ -z "$ETH_INTERFACE" ]; then
        echo "NET: 󰈀 NO ETH"
        exit 1
    fi

    # Get link speed from ethtool (requires root or proper permissions)
    LINK_SPEED=$(ethtool "$ETH_INTERFACE" 2>/dev/null | grep "Speed:" | awk '{print $2}' | sed 's/Mb\/s//' 2>/dev/null)

    # Get interface statistics
    RX_BYTES=$(cat "/sys/class/net/$ETH_INTERFACE/statistics/rx_bytes" 2>/dev/null || echo "0")
    TX_BYTES=$(cat "/sys/class/net/$ETH_INTERFACE/statistics/tx_bytes" 2>/dev/null || echo "0")

    # Store previous values in temp files
    RX_PREV_FILE="/tmp/rx_bytes_prev"
    TX_PREV_FILE="/tmp/tx_bytes_prev"
    TIME_PREV_FILE="/tmp/time_prev"

    CURRENT_TIME=$(date +%s)

    if [ -f "$RX_PREV_FILE" ] && [ -f "$TX_PREV_FILE" ] && [ -f "$TIME_PREV_FILE" ]; then
        RX_PREV=$(cat "$RX_PREV_FILE")
        TX_PREV=$(cat "$TX_PREV_FILE")
        TIME_PREV=$(cat "$TIME_PREV_FILE")
        
        TIME_DIFF=$((CURRENT_TIME - TIME_PREV))
        
        if [ "$TIME_DIFF" -gt 0 ]; then
            RX_RATE=$(( (RX_BYTES - RX_PREV) / TIME_DIFF ))
            TX_RATE=$(( (TX_BYTES - TX_PREV) / TIME_DIFF ))
            
            # Convert to human readable format
            if [ "$RX_RATE" -gt 1048576 ]; then
                RX_DISPLAY="$(( RX_RATE / 1048576 ))MB/s"
            elif [ "$RX_RATE" -gt 1024 ]; then
                RX_DISPLAY="$(( RX_RATE / 1024 ))KB/s"
            else
                RX_DISPLAY="''${RX_RATE}B/s"
            fi
            
            if [ "$TX_RATE" -gt 1048576 ]; then
                TX_DISPLAY="$(( TX_RATE / 1048576 ))MB/s"
            elif [ "$TX_RATE" -gt 1024 ]; then
                TX_DISPLAY="$(( TX_RATE / 1024 ))KB/s"
            else
                TX_DISPLAY="''${TX_RATE}B/s"
            fi
            
            # Show UP and DOWN stats
            if [ -n "$LINK_SPEED" ]; then
                echo "󰈀  󰈀 ''${LINK_SPEED}Mb |  $RX_DISPLAY |  $TX_DISPLAY"
            else
                echo "󰈀   $RX_DISPLAY |  $TX_DISPLAY"
            fi
        else
            echo "󰈀  󰈀 ''${LINK_SPEED:-???}Mb"
        fi
    else
        echo "󰈀  󰈀 ''${LINK_SPEED:-???}Mb"
    fi

    # Store current values for next iteration
    echo "$RX_BYTES" > "$RX_PREV_FILE"
    echo "$TX_BYTES" > "$TX_PREV_FILE"
    echo "$CURRENT_TIME" > "$TIME_PREV_FILE"
  '';
in {
  home.packages = [
    network-traffic
  ];
}
