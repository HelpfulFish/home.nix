# nixGL Configuration

This configuration includes automatic nixGL wrapping for GPU-accelerated applications on non-NixOS systems.

https://github.com/nix-community/nixGL

## Quick Setup

1. **Install nixGL globally** (required first step):

   ```bash
   nix profile install github:nix-community/nixGL --impure
   ```

2. **Apply Home Manager configuration**:
   ```bash
   home-manager switch --flake .#username
   ```

## What's Included

- **Automatic GPU wrapping**: Applications like `anki-nixgl` are pre-wrapped
- **Manual wrapper**: Use `ngl <app>` for any application
- **QT fixes**: Environment variables set for common GL issues

## Available Commands

- `anki-nixgl`: GPU-accelerated Anki (automatically wrapped)
- `ngl <application>`: Manual nixGL wrapper for any app
- `nixGL <application>`: Direct nixGL command

## Usage Examples

```bash
# Pre-wrapped applications (recommended)
anki-nixgl

# Manual wrapping
ngl firefox
ngl alacritty
nixGL steam

# Check if working
nvidia-smi  # Should show GPU info if NVIDIA
```

## Troubleshooting

If applications crash with GL errors:

1. Ensure nixGL is installed: `which nixGL`
2. Check GPU drivers are working: `nvidia-smi` or `glxinfo`
3. Try different wrappers: `nixGL`, `nixGLNvidia`, etc.

## Configuration Details

This setup includes:

- **Overlay**: Automatic nixGL wrapping for common applications
- **Environment**: `QT_XCB_GL_INTEGRATION=none` for QT app compatibility
- **Hardware**: Auto-detection of NVIDIA/Intel GPU drivers

---

_This configuration automatically handles nixGL setup for this Home Manager environment._
