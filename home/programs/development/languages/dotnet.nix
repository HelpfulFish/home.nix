# .NET development environment
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # .NET SDKs (choose versions you need)
    (with dotnetCorePackages; combinePackages [
      sdk_9_0
      # sdk_8_0
      # sdk_6_0         # Add older versions if needed
    ])

    # .NET tools
    nuget
  ];

  home.sessionVariables = {
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_8_0}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1"; # Disable telemetry
    DOTNET_NOLOGO = "1"; # Disable startup logo
  };

  # .NET development aliases
  programs.zsh.shellAliases = {
    # Clean commands
    dotnet-clean = "dotnet clean && find . -name 'bin' -o -name 'obj' | xargs rm -rf";
    dotnet-restore = "dotnet restore --no-cache";

    # Common dotnet commands
    dn = "dotnet";
    dnr = "dotnet run";
    dnb = "dotnet build";
    dnt = "dotnet test";
    dnp = "dotnet publish";
  };
}
