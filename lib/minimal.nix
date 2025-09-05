{
  lib,
  pkgs,
  ...
}: {
  # Essential helper functions only
  
  # Function to wrap applications with nixGL (keep - essential for non-NixOS)
  wrapWithNixGL = app: wrapper: (wrapper.wrap app);
  
  # Function to safely import modules if they exist (keep - useful)
  importIfExists = path: 
    if builtins.pathExists path 
    then [ path ] 
    else [];

  # Simple shell aliases (keep - commonly used)
  mkAliases = aliases:
    lib.mapAttrs (name: value:
      if lib.isString value 
      then value
      else value.command
    ) aliases;
}
