{
  config,
  pkgs,
  lib,
  ...
}: {
  # Notification system configuration
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display settings
        monitor = 0;
        follow = "none";
        
        # Geometry
        width = 350;
        height = 80;
        origin = "top-right";
        offset = "15x40";
        scale = 0;
        notification_limit = 10;
        
        # Progress bar - Compact
        progress_bar = true;
        progress_bar_height = 8;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 120;
        progress_bar_max_width = 280;
        progress_bar_corner_radius = 4;
        progress_bar_corners = "all";
        
        # Icon settings
        icon_corner_radius = 0;
        icon_corners = "all";
        indicate_hidden = true;
        
        # Window appearance
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 12;
        text_icon_padding = 8;
        frame_width = 1;
        frame_color = "#30363d";
        gap_size = 0;
        separator_color = "#21262d";
        sort = true;
        
        # Text settings
        font = "FiraCode Nerd Font 8";
        line_height = 1;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = true;
        
        # Icon configuration - Compact
        enable_recursive_icon_lookup = true;
        icon_theme = "Adwaita";
        icon_position = "left";
        min_icon_size = 24;
        max_icon_size = 32;
        icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";
        
        # History
        sticky_history = true;
        history_length = 20;
        
        # Misc
        dmenu = "${pkgs.dmenu}/bin/dmenu -p dunst:";
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        # Compact rounded corners
        corner_radius = 8;
        corners = "all";
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        
        # Mouse actions
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      
      experimental = {
        per_monitor_dpi = false;
      };
      
      # === DARK CYBERPUNK THEME (ACTIVE) ===
      urgency_low = {
        background = "#0d1117";
        foreground = "#58a6ff";
        frame_color = "#21262d";
        timeout = 10;
        default_icon = "dialog-information";
      };
      
      urgency_normal = {
        background = "#161b22";
        foreground = "#f0f6fc";
        frame_color = "#30363d";
        timeout = 10;
        override_pause_level = 30;
        default_icon = "dialog-information";
      };
      
      urgency_critical = {
        background = "#21262d";
        foreground = "#ff7b72";
        frame_color = "#da3633";
        timeout = 0;
        override_pause_level = 60;
        default_icon = "dialog-warning";
      };
    };
  };
}
