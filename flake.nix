{
  description = "Panos' Nixos Configuration";

  inputs = {
    nixpkgs = { 
      # url = "github:NixOS/nixpkgs/nixos-26.05";
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };

    home-manager = {
      # url = "github:nix-community/home-manager/release-26.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: { 
    nixosConfigurations.wisp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs;
        configDir = "/home/pano/.nixos"; 
      };
      modules = [
        home-manager.nixosModules.home-manager
        ./hosts/wisp
      ];
    };
  };
}

