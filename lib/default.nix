{
  lib,
  pkgs,
  ...
}: {
  # Helper functions for the home-manager configuration
  
  # Function to wrap applications with nixGL
  wrapWithNixGL = app: wrapper: (wrapper.wrap app);
  
  # Function to create desktop entries
  createDesktopEntry = {
    name,
    exec,
    icon ? "",
    comment ? "",
    categories ? []
  }: {
    "${name}" = {
      name = name;
      exec = exec;
      icon = icon;
      comment = comment;
      categories = categories;
      terminal = false;
      type = "Application";
    };
  };
  
  # Function to safely import modules if they exist
  importIfExists = path: 
    if builtins.pathExists path 
    then [ path ] 
    else [];

  # Function to conditionally include packages based on system features
  conditionalPackages = condition: packages:
    if condition then packages else [];

  # Function to create shell aliases with descriptions
  mkAliases = aliases:
    lib.mapAttrs (name: value:
      if lib.isString value 
      then value
      else value.command
    ) aliases;

  # Function to get git user info from environment or defaults
  getGitUser = {
    name ? (builtins.getEnv "GIT_USER_NAME"),
    email ? (builtins.getEnv "GIT_USER_EMAIL"),
    defaultName ? "User",
    defaultEmail ? "user@example.com"
  }: {
    userName = if name != "" then name else defaultName;
    userEmail = if email != "" then email else defaultEmail;
  };

  # Function to create consistent font configurations
  mkFontConfig = {
    defaultFont ? "Fira Code",
    fontSize ? 12,
    extraFonts ? []
  }: {
    fonts = [ defaultFont ] ++ extraFonts;
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ defaultFont ];
      };
    };
  };

  # Function to create development shell scripts
  mkDevScript = name: script: pkgs.writeShellScriptBin name script;

  # Function to conditionally enable modules based on hostname or user
  enableForHost = hostnames: lib.elem (builtins.getEnv "HOSTNAME") hostnames;
  enableForUser = usernames: lib.elem (builtins.getEnv "USER") usernames;

  # Function to merge multiple package lists with deduplication
  mergePackages = packageLists: 
    lib.unique (lib.flatten packageLists);

  # Function to read .env file and parse environment variables
  readEnvFile = envPath: 
    let
      envContent = builtins.readFile envPath;
      lines = lib.splitString "\n" envContent;
      nonEmptyLines = builtins.filter (line: line != "" && !(lib.hasPrefix "#" (lib.trim line))) lines;
      parseEnvLine = line:
        let
          parts = lib.splitString "=" line;
          key = lib.trim (builtins.head parts);
          value = lib.trim (lib.concatStringsSep "=" (builtins.tail parts));
        in
          lib.nameValuePair key value;
      envVars = builtins.listToAttrs (map parseEnvLine nonEmptyLines);
    in
      envVars;
  
  # Function to get env var with fallback
  getEnvWithFallback = envVars: varName: fallback:
    if builtins.hasAttr varName envVars
    then envVars.${varName}
    else fallback;
}
