{ pkgs, ... }:

let
  network-latency = pkgs.writeShellScriptBin "network-latency" ''
    #!/bin/bash

    # Ping Quad9 DNS (9.9.9.9)
    PING_RESULT=$(ping -c 1 -W 2 9.9.9.9 2>/dev/null | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')

    if [ -n "$PING_RESULT" ]; then
        # Convert to integer for comparison
        PING_MS=$(echo "$PING_RESULT" | cut -d'.' -f1)
        
        # Color coding based on latency
        if [ "$PING_MS" -lt 20 ]; then
            echo "🏓 ''${PING_RESULT}ms"  # Excellent
        elif [ "$PING_MS" -lt 50 ]; then
            echo "🏓 ''${PING_RESULT}ms"  # Good
        elif [ "$PING_MS" -lt 100 ]; then
            echo "🏓 ''${PING_RESULT}ms"  # Fair
        else
            echo "🏓 ''${PING_RESULT}ms"  # Poor
        fi
    else
        echo "🏓 OFFLINE"  # No connection
    fi
  '';
in {
  home.packages = [
    network-latency
  ];
}
