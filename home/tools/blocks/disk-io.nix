{ pkgs, ... }:

let
  disk-io = pkgs.writeShellScriptBin "disk-io" ''
    #!/bin/bash

    # Get the primary disk device (usually sda, nvme0n1, etc.)
    PRIMARY_DISK=$(lsblk -no NAME,TYPE | grep disk | head -1 | awk '{print $1}')

    if [ -z "$PRIMARY_DISK" ]; then
        echo "DISK: 󰋊 NO DISK"
        exit 1
    fi

    # Get disk statistics from /proc/diskstats
    # Fields: read_sectors, write_sectors (multiply by 512 for bytes)
    DISK_STATS=$(grep "^[[:space:]]*[0-9]*[[:space:]]*[0-9]*[[:space:]]*$PRIMARY_DISK[[:space:]]" /proc/diskstats)
    
    if [ -z "$DISK_STATS" ]; then
        echo "DISK: 󰋊 NO STATS"
        exit 1
    fi

    READ_SECTORS=$(echo "$DISK_STATS" | awk '{print $6}')
    WRITE_SECTORS=$(echo "$DISK_STATS" | awk '{print $10}')

    # Convert sectors to bytes (1 sector = 512 bytes)
    READ_BYTES=$((READ_SECTORS * 512))
    WRITE_BYTES=$((WRITE_SECTORS * 512))

    # Store previous values in temp files
    READ_PREV_FILE="/tmp/disk_read_prev"
    WRITE_PREV_FILE="/tmp/disk_write_prev"
    DISK_TIME_PREV_FILE="/tmp/disk_time_prev"

    CURRENT_TIME=$(date +%s)

    if [ -f "$READ_PREV_FILE" ] && [ -f "$WRITE_PREV_FILE" ] && [ -f "$DISK_TIME_PREV_FILE" ]; then
        READ_PREV=$(cat "$READ_PREV_FILE")
        WRITE_PREV=$(cat "$WRITE_PREV_FILE")
        TIME_PREV=$(cat "$DISK_TIME_PREV_FILE")
        
        TIME_DIFF=$((CURRENT_TIME - TIME_PREV))
        
        if [ "$TIME_DIFF" -gt 0 ]; then
            READ_RATE=$(( (READ_BYTES - READ_PREV) / TIME_DIFF ))
            WRITE_RATE=$(( (WRITE_BYTES - WRITE_PREV) / TIME_DIFF ))
            
            # Convert to human readable format
            if [ "$READ_RATE" -gt 1073741824 ]; then
                READ_DISPLAY="$(( READ_RATE / 1073741824 ))GB/s"
            elif [ "$READ_RATE" -gt 1048576 ]; then
                READ_DISPLAY="$(( READ_RATE / 1048576 ))MB/s"
            elif [ "$READ_RATE" -gt 1024 ]; then
                READ_DISPLAY="$(( READ_RATE / 1024 ))KB/s"
            else
                READ_DISPLAY="''${READ_RATE}B/s"
            fi
            
            if [ "$WRITE_RATE" -gt 1073741824 ]; then
                WRITE_DISPLAY="$(( WRITE_RATE / 1073741824 ))GB/s"
            elif [ "$WRITE_RATE" -gt 1048576 ]; then
                WRITE_DISPLAY="$(( WRITE_RATE / 1048576 ))MB/s"
            elif [ "$WRITE_RATE" -gt 1024 ]; then
                WRITE_DISPLAY="$(( WRITE_RATE / 1024 ))KB/s"
            else
                WRITE_DISPLAY="''${WRITE_RATE}B/s"
            fi
            
            # Only show if there's activity
            if [ "$READ_RATE" -gt 0 ] || [ "$WRITE_RATE" -gt 0 ]; then
                echo " 󰋊 󰙒 $READ_DISPLAY 󰙓 $WRITE_DISPLAY"
            else
                echo " 󰋊 󰙒 0B/s 󰙓 0B/s"
            fi
        else
            echo " 󰋊 ---"
        fi
    else
        echo " 󰋊 ---"
    fi

    # Store current values for next iteration
    echo "$READ_BYTES" > "$READ_PREV_FILE"
    echo "$WRITE_BYTES" > "$WRITE_PREV_FILE"
    echo "$CURRENT_TIME" > "$DISK_TIME_PREV_FILE"
  '';
in {
  home.packages = [
    disk-io
  ];
}
