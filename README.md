<div align="center">
  <h1 align="center">home.nix</h1>
</div>

Man page: `man home-configuration.nix`

## Install nix

Since we are the only one using the computer, use [single-user installation](https://nixos.org/download.html)

```
bash <(curl -L https://nixos.org/nix/install) --no-daemon
```

Source nix shell commands:

```
. /home/${USER}/.nix-profile/etc/profile.d/nix.sh
```

## Install home-manager

[Home manager manual](https://nix-community.github.io/home-manager/)

### Install standalone mode

```
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

## Install nixGL

NixGL solve the "OpenGL" problem with nix. We are going to use: `nixVulkanNvidia` and `nixGLNvidia`, view all wrappers on GitHub

Source: https://github.com/nix-community/nixGL

```
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl
nix-channel --update
nix-env -iA nixgl.auto.nixVulkanNvidia
nix-env -iA nixgl.auto.nixGLNvidia
```

## Clone repo

```
git clone --depth 1 https://github.com/HelpfulFish/home.nix.git ~/.config/home-manager
mkdir ~/.config/nixpkgs
cp ~/.config/home-manager/config.nix ~/.config/nixpkgs/config.nix
```

## Run home manager

On your first install use:

```
nix-shell '<home-manager>' -A install
```

Going forward use

```
home-manager switch
```

## Updating packages

```
nix-channel --update
home-manager switch
```

## Clean up nix store

```
nix-collect-garbage
```

## Resources

- Home manager: https://github.com/nix-community/home-manager
- Nixpkgs source: https://github.com/NixOS/nixpkgs
- Package search: https://search.nixos.org/packages
