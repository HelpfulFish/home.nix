{
  config,
  pkgs,
  lib,
  ...
}: {
  # System services
  services = {
    # Keyring management
    gnome-keyring = {
      enable = true;
      # components = [ "secrets" "ssh" "pkcs11" ];
    };

    # Notification daemon (handled by dunst config files)
    # dunst.enable = true;  # We use config files instead

    # Screen locker (optional)
    # screen-locker = {
    #   enable = false;
    #   inactiveInterval = 10;
    # };

    # GPG agent
    gpg-agent = {
      enable = false;  # Enable if you use GPG
      # defaultCacheTtl = 1800;
      # enableSshSupport = true;
    };
  };
}
