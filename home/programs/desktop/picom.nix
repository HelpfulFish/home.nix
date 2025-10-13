{
  config,
  pkgs,
  lib,
  ...
}: {
  # Picom compositor configuration
  # Don't use services.picom because nixgl wrapper doesn't work well with systemd
  # Instead, start picom-nixgl manually or via X session
  
  # For manual testing, you can run:
  # pkill picom
  # picom-nixgl --config ~/.config/picom/picom.conf &
  
  # FADE SPEED ADJUSTMENT GUIDE:
  # To make fading FASTER: INCREASE fade-in-step and fade-out-step values
  #   - 0.05 = faster
  #   - 0.08 = very fast  
  #   - 0.1+ = almost instant
  # To make fading SLOWER: DECREASE fade-in-step and fade-out-step values
  #   - 0.02 = slower
  #   - 0.01 = much slower
  #   - 0.005 = very slow
  # fade-delta controls timing between steps (lower = faster overall)
  
  # Create picom config file
  xdg.configFile."picom/picom.conf".text = ''
    # Fading settings - Normal speed
    fading = true;
    fade-in-step = 0.08;    # INCREASE for faster fade (try 0.05 or 0.08)
    fade-out-step = 0.08;   # INCREASE for faster fade (try 0.05 or 0.08)
    fade-delta = 10;        # DECREASE for faster overall timing (try 5 or 7)
    
    # Transparency
    active-opacity = 1.0;
    inactive-opacity = 0.95;
    
    # Shadows
    shadow = true;
    shadow-radius = 7;
    shadow-offset-x = -7;
    shadow-offset-y = -7;
    shadow-opacity = 0.7;
    
    # Exclude shadows from certain windows
    shadow-exclude = [
      "class_g = 'i3-frame'",
      "class_g = 'i3bar'",
      "_GTK_FRAME_EXTENTS@:c"
    ];
    
    # Opacity rules - keep browsers at full opacity
    opacity-rule = [
      "100:class_g = 'firefox'",
      "100:class_g = 'Firefox'", 
      "100:class_g = 'brave-browser'",
      "100:class_g = 'Brave-browser'",
      "100:class_g = 'chromium'",
      "100:class_g = 'Chromium'"
    ];
    
    # Backend
    backend = "glx";
    vsync = true;
    
    # Performance
    mark-wmwin-focused = true;
    mark-ovredir-focused = true;
    detect-rounded-corners = true;
    detect-client-opacity = true;
  '';
}
