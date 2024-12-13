{ pkgs, ... }:

let
  gpu-info = pkgs.writeShellScriptBin "gpu-info" ''
    #!/bin/sh

    GPU_TEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
    GPU_FAN=$(nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits)
    GPU_POWER=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits)

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

