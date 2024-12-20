{ pkgs, ... }:

let
  gpu-info = pkgs.writeShellScriptBin "gpu-info" ''
    #!/bin/sh

    GPU_METRICS=$(nvidia-smi --query-gpu=temperature.gpu,fan.speed,power.draw --format=csv,noheader,nounits)

    # Parse the output
    GPU_TEMP=$(echo "$GPU_METRICS" | awk -F', ' '{print $1}')
    GPU_FAN=$(echo "$GPU_METRICS" | awk -F', ' '{print $2}')
    GPU_POWER=$(echo "$GPU_METRICS" | awk -F', ' '{print $3}')

    [ -z "$GPU_TEMP" ] && GPU_TEMP="N/A"
    [ -z "$GPU_FAN" ] && GPU_FAN="N/A"
    [ -z "$GPU_POWER" ] && GPU_POWER="N/A"

    echo "GPU:  $GPU_TEMP°C - 󱐋 $GPU_POWER W - 󰈐 $GPU_FAN%"
  '';
in {
  home.packages = [
    gpu-info
  ];
}

