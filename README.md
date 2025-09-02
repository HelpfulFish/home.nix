# Home Manager Configuration

A comprehensive Nix Home Manager configuration with i3 window manager, development tools

Man page: `man home-configuration.nix`

## Installation

### Install Nix

Since we are the only one using the computer, use [single-user installation](https://nixos.org/download.html):

```bash
bash <(curl -L https://nixos.org/nix/install) --no-daemon
```

Source nix shell commands:

```bash
. /home/${USER}/.nix-profile/etc/profile.d/nix.sh
```

### Enable Nix Flakes (Recommended)

To permanently enable nix flakes and commands, create a nix configuration file:

```bash
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
auto-optimise-store = true
EOF
```

This enables:

- `nix-command` - Modern nix CLI commands
- `flakes` - Reproducible and composable packages
- `auto-optimise-store` - Automatic deduplication to save disk space

### Install Home Manager

[Home Manager manual](https://nix-community.github.io/home-manager/)

#### Install standalone mode

```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
```

### Install nixGL

NixGL solve the "OpenGL" problem with nix. We are going to use: `nixVulkanNvidia` and `nixGLNvidia`, view all wrappers on GitHub

Source: [https://github.com/nix-community/nixGL](https://github.com/nix-community/nixGL)

```bash
nix-channel --add https://github.com/nix-community/nixGL/archive/main.tar.gz nixgl
nix-channel --update
nix-env -iA nixgl.auto.nixVulkanNvidia
nix-env -iA nixgl.auto.nixGLNvidia
```

### Clone This Repository

```bash
git clone --depth 1 https://github.com/HelpfulFish/home.nix.git ~/.config/home-manager
```

## Basic Usage

### First Time Setup

On your first install use:

```bash
nix-shell '<home-manager>' -A install
```

### Traditional Channel-Based Usage

Going forward use:

```bash
home-manager switch
```

### Flake-Based Usage (Recommended)

1. **Update the flake configuration** in `flake.nix`:

   - Find the `userConfig` section (around line 36) and replace the placeholder values:

   ```nix
   userConfig = {
     username = "your-actual-username"; # <-- Replace with your actual username
     homeDirectory = "/home/your-actual-username"; # <-- Replace with your actual home directory
   };
   ```

2. **Switch to the configuration**:
   ```bash
   home-manager switch --flake .#your-actual-username
   ```

**Note:** Replace `your-actual-username` with your real username throughout this README.

### Updating Packages

```bash
nix-channel --update
home-manager switch
```

Or with flakes:

```bash
nix flake update
home-manager switch --flake .#your-actual-username
```

### Clean Up Nix Store

```bash
nix-collect-garbage
```

## Available Configurations

- `<your_username>` - Main configuration for your user
- `<your_username>-minimal` - Minimal configuration without desktop environment
- `<your_username>-aarch64` - Configuration for ARM64 systems
- `default` - Alias for the main configuration

## Development

Enter the development shell:

```bash
nix develop
```

Format the code:

```bash
nix fmt
```

Check the flake:

```bash
nix flake check --all-systems
```

## Configuration Structure

- `flake.nix` - Main flake configuration with multi-system support
- `home/` - Home Manager modules organized by function:
  - `packages/` - Package definitions (desktop, development, system)
  - `programs/` - Program configurations (shell, editors, development, desktop)
  - `services/` - System services configuration
  - `tools/` - Custom scripts and i3blocks components
  - `hardware/` - Hardware-specific configs (temporarily disabled)
- `config/` - Application configurations (dotfiles):
  - `alacritty/` - Terminal emulator config
  - `dunst/` - Notification daemon config
  - `i3/` - i3 window manager config
  - `i3blocks/` - Status bar config
  - `nvim/` - Neovim LazyVim configuration
  - `p10k/` - Powerlevel10k theme config
  - `wallpapers/` - Desktop wallpapers
- `lib/` - Custom library functions for Nix
- `overlays/` - Package overlays and pinned versions
- `scripts/` - Shell scripts (nvm, utilities)

## Usage Examples

### First-time Setup

```bash
# 1. Clone or copy this configuration
git clone <repository-url> ~/.config/home-manager
cd ~/.config/home-manager

# 2. Update flake.nix with your username
# Edit the userConfig section in flake.nix to replace <your_username> placeholders

# 3. Apply the configuration
home-manager switch --flake .#your-actual-username
```

### Daily Usage

```bash
# Apply configuration changes
home-manager switch --flake .#your-actual-username

# Use minimal configuration
home-manager switch --flake .#your-actual-username-minimal

# Update inputs
nix flake update

# Rollback to previous generation
home-manager generations
home-manager switch --flake .#your-actual-username --generation <generation-number>
```

### Development Workflow

```bash
# Enter development environment
nix develop

# Format all Nix files
nix fmt

# Validate the flake
nix flake check --all-systems

# Build without switching
nix build .#homeConfigurations.your-actual-username.activationPackage

# Show flake structure
nix flake show
```

## Customization

### Adding New Packages

Edit `home/packages/` files to add new packages:

```nix
# In home/packages/development.nix
home.packages = with pkgs; [
  # ...existing packages...
  your-new-package
];
```

### Adding New Programs

Create new program configurations in `home/programs/`:

```nix
# home/programs/your-program.nix
{ config, pkgs, ... }: {
  programs.your-program = {
    enable = true;
    # configuration options
  };
}
```

### Custom Scripts and Tools

Add custom tools in `home/tools/`:

```nix
# home/tools/my-tool.nix
{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    (writeShellScriptBin "my-script" ''
      echo "Hello from my custom script!"
    '')
  ];
}
```

## Troubleshooting

### Common Issues

**Username not found error:**

- Make sure you've updated the `userConfig` in `flake.nix` (around line 36)
- Replace `<your_username>` placeholders with your actual username
- Verify the username matches your system user

**Build failures:**

- Run `nix flake check` to validate the configuration
- Check for syntax errors in Nix files
- Update flake inputs: `nix flake update`

**NixGL issues (for non-NixOS systems):**

- Ensure nixGL overlay is properly configured
- Use `nixgl.nixGLIntel` or `nixgl.nixGLNvidia` as needed

**Permission errors:**

- Ensure you have write access to `/nix/store`
- On non-NixOS systems, make sure Nix is properly installed

### Getting Help

1. Check the Home Manager manual: `man home-configuration.nix`
2. Browse available options: `man home-configuration.nix`
3. Search for packages: `nix search nixpkgs <package-name>`
4. Check flake status: `nix flake check`

## Resources

- Home Manager: <https://github.com/nix-community/home-manager>
- Nixpkgs source: <https://github.com/NixOS/nixpkgs>
- Package search: <https://search.nixos.org/packages>
- Home Manager manual: <https://nix-community.github.io/home-manager/>
- NixGL: <https://github.com/nix-community/nixGL>
