{ pkgs, ... }:

let
  # Define the binary using writeShellScriptBin
  memory = pkgs.writeShellScriptBin "memory" ''
    #!/bin/sh

    # Hardcoded values for TYPE and PERCENT
    TYPE="mem"
    PERCENT="true"

    # Use awk to parse /proc/meminfo and calculate memory usage
    awk -v type=$TYPE -v percent=$PERCENT '
    /^MemTotal:/ {
        mem_total=$2
    }
    /^MemFree:/ {
        mem_free=$2
    }
    /^Buffers:/ {
        mem_free+=$2
    }
    /^Cached:/ {
        mem_free+=$2
    }
    /^SwapTotal:/ {
        swap_total=$2
    }
    /^SwapFree:/ {
        swap_free=$2
    }
    END {
        if (type == "swap") {
            free=swap_free/1024/1024
            used=(swap_total-swap_free)/1024/1024
            total=swap_total/1024/1024
        } else {
            free=mem_free/1024/1024
            used=(mem_total-mem_free)/1024/1024
            total=mem_total/1024/1024
        }

        pct=0
        if (total > 0) {
            pct=used/total*100
        }

        # Full text output
        if (percent == "true" ) {
            printf("🐏 %.1fG/%.1fG (%.f%%)\n", used, total, pct)
        } else {
            printf("🐏 %.1fG/%.1fG\n", used, total)
        }

        # Short text (just percentage)
        printf("%.f%%\n", pct)

        # Color coding based on percentage usage
        if (pct > 90) {
            print("#FF0000")  # Red
        } else if (pct > 80) {
            print("#FFAE00")  # Orange
        } else if (pct > 70) {
            print("#FFF600")  # Yellow
        }
    }
    ' /proc/meminfo
  '';
in {
  # Ensure the binary is added to the PATH
  home.packages = [
    memory
  ];
}

