{ pkgs, ... }:

let
  vpn-status = pkgs.writeShellScriptBin "vpn-status" ''
    #!/bin/bash

    # Check for common VPN processes
    if pgrep -f "openvpn|wg-quick|wireguard|strongswan|pptp|ipsec" > /dev/null 2>&1; then
        # Try to get VPN interface name (tun0, wg0, etc.)
        VPN_INTERFACE=$(ip link show | grep -E "(tun|wg|ppp)" | head -1 | awk '{print $2}' | sed 's/:$//')
        
        if [ -n "$VPN_INTERFACE" ]; then
            echo "VPN: 󰖂 $VPN_INTERFACE"
        else
            echo "VPN: 󰖂 Connected"
        fi
    else
        # Don't show anything if no VPN is connected
        exit 0
    fi
  '';
in {
  home.packages = [
    vpn-status
  ];
}
