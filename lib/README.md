# Library Functions

This directory contains helper functions and utilities for the home-manager configuration.

## Available Functions

### `wrapWithNixGL`

Wraps applications with nixGL for GPU acceleration.

```nix
wrapWithNixGL pkgs.alacritty nixgl.nixVulkanNvidia
```

### `createDesktopEntry`

Creates desktop entries for applications.

```nix
createDesktopEntry {
  name = "My App";
  exec = "myapp";
  icon = "myapp-icon";
  comment = "My custom application";
  categories = [ "Development" ];
}
```

### `importIfExists`

Safely imports modules only if they exist.

```nix
imports = myLib.importIfExists ./optional-module.nix;
```

### `conditionalPackages`

Includes packages based on conditions.

```nix
packages = myLib.conditionalPackages (system == "x86_64-linux") [
  pkgs.nvidia-docker
  pkgs.cuda-toolkit
];
```

### `mkAliases`

Creates shell aliases with optional descriptions.

```nix
shellAliases = myLib.mkAliases {
  ll = "ls -la";
  gs = "git status";
  update = "nix flake update && home-manager switch";
};
```

### `getGitUser`

Gets git user info from environment variables with fallbacks.

```nix
# Set environment variables:
# export GIT_USER_NAME="Your Name"
# export GIT_USER_EMAIL="your@email.com"

gitUser = myLib.getGitUser {
  defaultName = "Default User";
  defaultEmail = "user@example.com";
};
```

### `mkFontConfig`

Creates consistent font configurations.

```nix
fontConfig = myLib.mkFontConfig {
  defaultFont = "Fira Code";
  fontSize = 12;
  extraFonts = [ "JetBrains Mono" "Source Code Pro" ];
};
```

### `mkDevScript`

Creates development shell scripts.

```nix
updateScript = myLib.mkDevScript "update-home" ''
  cd ~/.config/home-manager
  nix flake update
  home-manager switch --flake .#default
'';
```

### `enableForHost` / `enableForUser`

Conditionally enable configurations based on hostname or username.

```nix
# Only enable on specific hosts
imports = lib.optionals (myLib.enableForHost ["workstation" "laptop"]) [
  ./work-specific.nix
];

# Only enable for specific users
programs.git.enable = myLib.enableForUser ["username" "developer"];
```

### `mergePackages`

Merges multiple package lists with deduplication.

```nix
allPackages = myLib.mergePackages [
  devPackages
  guiPackages
  systemPackages
];
```

## Usage in Modules

To use these functions in your modules, add `myLib` to the function arguments:

```nix
{
  config,
  pkgs,
  lib,
  myLib,  # Add this
  ...
}: {
  # Use myLib.functionName here
  home.packages = myLib.conditionalPackages true [ pkgs.git ];
}
```

## Examples

See `example-usage.nix` for complete examples of how to use these functions.

## Adding New Functions

When adding new helper functions:

1. Add them to `default.nix`
2. Document them in this README
3. Add examples to `example-usage.nix`
4. Keep functions pure and composable
5. Use descriptive names and good defaults
