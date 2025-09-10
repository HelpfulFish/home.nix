{ pkgs, ... }:

let
  cpu-monitor = pkgs.writeShellScriptBin "cpu-monitor" ''
    #!/bin/bash

    # Get CPU temperature from sensors (requires lm-sensors)
    CPU_TEMP=$(sensors 2>/dev/null | grep -E "(Core 0|Tctl|CPU)" | head -1 | awk '{print $3}' | sed 's/+//;s/°C.*//' | cut -d'.' -f1 2>/dev/null)

    # Fallback to thermal zone if sensors doesn't work
    if [ -z "$CPU_TEMP" ]; then
        CPU_TEMP=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null)
        if [ -n "$CPU_TEMP" ]; then
            CPU_TEMP=$((CPU_TEMP / 1000))
        fi
    fi

    # Get CPU usage percentage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')

    # If top format is different, try alternative
    if [ -z "$CPU_USAGE" ]; then
        CPU_USAGE=$(awk '{u=$2+$4; t=$2+$4+$5; if (NR==1){u1=u; t1=t;} else print ($2+$4-u1) * 100 / (t-t1) "%"; }' <(grep 'cpu ' /proc/stat; sleep 1; grep 'cpu ' /proc/stat) | cut -d'.' -f1)
    fi

    # Clean up CPU usage (remove % if present)
    CPU_USAGE=$(echo "$CPU_USAGE" | sed 's/%//' | cut -d'.' -f1)

    # Build output string
    OUTPUT=""

    # Add temperature with appropriate icon
    if [ -n "$CPU_TEMP" ]; then
        if [ "$CPU_TEMP" -lt 50 ]; then
            OUTPUT="󰏈 ''${CPU_TEMP}°C"  # Cool
        elif [ "$CPU_TEMP" -lt 70 ]; then
            OUTPUT="󱃃 ''${CPU_TEMP}°C"  # Warm
        elif [ "$CPU_TEMP" -lt 85 ]; then
            OUTPUT="󰸁 ''${CPU_TEMP}°C"  # Hot
        else
            OUTPUT="󱃂 ''${CPU_TEMP}°C"  # Very hot
        fi
    else
        OUTPUT="CPU: 󰏈 N/A"
    fi

    # Add CPU usage
    if [ -n "$CPU_USAGE" ]; then
        OUTPUT="$OUTPUT - 󰻠 ''${CPU_USAGE}%"
    fi

    echo "$OUTPUT"
  '';
in
{
  home.packages = [
    cpu-monitor
  ];
}
