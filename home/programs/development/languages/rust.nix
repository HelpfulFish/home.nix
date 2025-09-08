# Rust development environment
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer  # Language server
    
    # Rust development tools
    cargo-watch     # Auto-rebuild on file changes
    cargo-edit      # Cargo subcommands for editing Cargo.toml
    cargo-outdated  # Check for outdated dependencies
    # cargo-audit   # Security audit (uncomment if needed)
    # cargo-deny    # Cargo plugin for linting dependencies (uncomment if needed)
  ];

  home.sessionVariables = {
    # Rust configuration
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";
  };

  # Rust development aliases
  programs.zsh.shellAliases = {
    # Cargo shortcuts
    cb = "cargo build";
    cr = "cargo run";
    ct = "cargo test";
    cc = "cargo check";
    ccl = "cargo clippy";
    cf = "cargo fmt";
    
    # Cargo project management
    cn = "cargo new";
    ci = "cargo init";
    ca = "cargo add";
    
    # Development workflow
    cw = "cargo watch -x check -x test -x run";  # Watch mode
    cargo-update = "cargo install-update -a";   # Update all cargo tools
  };
}
