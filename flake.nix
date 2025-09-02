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
    # Supported systems
    systems = [ "x86_64-linux" "aarch64-linux" ];
    
    # Helper function to generate configs for all systems
    forAllSystems = nixpkgs.lib.genAttrs systems;
    
    # User configuration - loads from local.conf or uses defaults
    userConfig = {
      username = "<your_username>"; # <-- Replace with your actual username
      homeDirectory = "/home/<your_username>"; # <-- Replace with your actual home directory
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
        myLib = import ./lib { 
          inherit (nixpkgs) lib; 
          inherit pkgs; 
        };
        
        # NixGL packages for the system
        nixgl-pkgs = nixgl.packages.${system};
      };
      
      modules = [
        ./home
      ] ++ modules;
    };

  in {
    # Home Manager configurations
    homeConfigurations = {
      # Main configuration using settings from local.conf
      "${userConfig.username}" = mkHomeConfiguration {
        system = "x86_64-linux";
      };
      
      # Alias for the main configuration
      default = mkHomeConfiguration {
        system = "x86_64-linux";
      };

      # Minimal configuration example
      "${userConfig.username}-minimal" = mkHomeConfiguration {
        system = "x86_64-linux";
        modules = [
          {
            # Override to disable desktop environment
            programs.i3.enable = nixpkgs.lib.mkForce false;
            home.packages = [];
          }
        ];
      };
      
      # Multi-architecture examples
      "${userConfig.username}-aarch64" = mkHomeConfiguration {
        system = "aarch64-linux";
      };
    };


    # Custom packages (useful for sharing)
    packages = forAllSystems (system: let
      pkgs = mkPkgs system;
    in {
      # Default package is the home configuration activation package
      default = self.homeConfigurations.${userConfig.username}.activationPackage;
      
      # Example: You can add custom packages here
      # my-script = pkgs.writeShellScript "my-script" "echo Hello World";
    });

    # Apps for `nix run`
    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = "${self.homeConfigurations.${userConfig.username}.activationPackage}/activate";
        meta = {
          description = "Activate the Home Manager configuration";
        };
      };
      
      activate = {
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
