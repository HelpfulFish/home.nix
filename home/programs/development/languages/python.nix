# Python development environment
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python and tools
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.pipx
    
    # Python development tools
    python3Packages.black     # Code formatter
    python3Packages.flake8    # Linter
    python3Packages.mypy      # Type checker
    python3Packages.pytest    # Testing framework
    
    # Python language server
    python3Packages.python-lsp-server
  ];

  home.sessionVariables = {
    # Python configuration
    PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH";
  };

  # Python development aliases
  programs.zsh.shellAliases = {
    # Python shortcuts
    py = "python3";
    pip = "python3 -m pip";
    
    # Virtual environment
    venv-create = "python3 -m venv venv";
    venv-activate = "source venv/bin/activate";
    
    # Common commands
    py-format = "black .";
    py-lint = "flake8 .";
    py-test = "pytest";
  };
}
