# Go development environment
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Go toolchain
    go

    # Go development tools
    gopls # Go language server (for Neovim LSP)
    # gofumpt # Stricter gofmt
    # gotools # Additional tools (goimports, godoc, etc.)
    # golangci-lint # Fast linters runner
    # delve # Go debugger

    # Popular Go tools
    # air # Live reload for Go apps
    # go-migrate    # Database migrations (uncomment if needed)
    # sqlc          # Generate type-safe Go from SQL (uncomment if needed)
  ];

  home.sessionVariables = {
    # Go configuration
    GOPATH = "$HOME/go";
    GOBIN = "$HOME/go/bin";
    # GO111MODULE = "on";
  };

  # Go development aliases
  programs.zsh.shellAliases = {
    # Go shortcuts
    gob = "go build";
    gor = "go run";
    got = "go test";
    gom = "go mod";
    gof = "go fmt";
    goc = "go clean";
    gov = "go version";

    # Go module management
    gomi = "go mod init";
    gomt = "go mod tidy";
    gomv = "go mod vendor";
    gomd = "go mod download";

    # Testing
    # gotv = "go test -v";
    # gotc = "go test -cover";
    # gotb = "go test -bench=.";

    # Build variations
    # gobb = "go build -race"; # Build with race detector
    # gobc = "CGO_ENABLED=0 go build"; # Build without CGO

    # Linting and formatting
    # golint = "golangci-lint run";
    # gofmt = "gofumpt -w .";

    # Development workflow
    # goair = "air"; # Live reload
    # gowork = "go work"; # Go workspaces
  };
}
