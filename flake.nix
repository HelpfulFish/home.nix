{
  description = "Personal Home Manager configuration with i3, development tools, and custom scripts";

  inputs = {
    # Nix packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # NixGL for GPU support on non-NixOS
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixgl,
    ...
  } @ inputs: let
    # System configuration
    systems = [ "x86_64-linux" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    
    # User configuration
    userConfig = {
      username = "your_username";
      homeDirectory = "/home/your_username";
    };
    
    # Helper function to create pkgs for a system
    mkPkgs = system: import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      overlays = [
        nixgl.overlay
        (import ./overlays)
      ];
    };

    # Helper function to create stable pkgs for a system  
    mkStablePkgs = system: import nixpkgs-stable {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    # Helper function to create a home configuration
    mkHomeConfiguration = { system, username ? userConfig.username, homeDirectory ? userConfig.homeDirectory, modules ? [] }: let
      pkgs = mkPkgs system;
      pkgs-stable = mkStablePkgs system;
    in home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      
      extraSpecialArgs = {
        inherit inputs nixgl;
        inherit pkgs-stable;
        
        # User configuration
        userConfig = {
          inherit username homeDirectory;
        };
        
        # Custom library functions
        myLib = import ./lib/minimal.nix { 
          inherit (nixpkgs) lib; 
          inherit pkgs; 
        };
        
        # NixGL packages for the system
        nixgl-pkgs = nixgl.packages.${system};
      };
      
      modules = [
        ./home.nix
      ] ++ modules;
    };

  in {
    # Home Manager configurations
    homeConfigurations = {
      # Main configuration
      "${userConfig.username}" = mkHomeConfiguration {
        system = "x86_64-linux";
      };
    };


    # Custom packages (useful for sharing)
    packages = forAllSystems (system: let
      pkgs = mkPkgs system;
    in {
      # Default package is the home configuration activation package
      default = self.homeConfigurations.${userConfig.username}.activationPackage;
    });

    # Apps for `nix run`
    apps = forAllSystems (system: let
      pkgs = mkPkgs system;
    in {
      default = {
        type = "app";
        program = "${self.homeConfigurations.${userConfig.username}.activationPackage}/activate";
        meta = {
          description = "Activate the Home Manager configuration";
        };
      };
    });

    # Formatter for `nix fmt`
    formatter = forAllSystems (system: (mkPkgs system).nixfmt-rfc-style);

    # Checks for CI/CD  
    checks = forAllSystems (system: let
      pkgs = mkPkgs system;
    in {
      # Home configuration builds successfully
      homeConfiguration = self.homeConfigurations.${userConfig.username}.activationPackage;
    });
    
    # Templates for creating new configurations
    templates = {
      default = {
        path = ./.;
        description = "A basic Home Manager configuration with i3 and development tools";
      };
    };
  };
}
