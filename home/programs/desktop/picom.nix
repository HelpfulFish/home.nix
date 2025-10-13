{
  config,
  pkgs,
  lib,
  ...
}: {
  # Picom compositor configuration
  # Don't use services.picom because nixgl wrapper doesn't work well with systemd
  # Instead, start picom-nixgl manually or via X session
  
  # For manual testing, you can run: picom-nixgl --config ~/.config/picom/picom.conf
  
  # Create picom config file
  xdg.configFile."picom/picom.conf".text = ''
    # Basic settings
    fade-in-step = 0.03;
    fade-out-step = 0.03;
    fade-delta = 10;
    
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
