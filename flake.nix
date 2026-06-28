{
  description = "Panos' Nixos Configuration";

  inputs = {
    nixpkgs = { 
      url = "github:NixOS/nixpkgs/nixos-26.05";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
    };
  };

  outputs = { nixpkgs, home-manager, ... }: { 
    nixosConfigurations.wisp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        ./hosts/wisp
      ];
    };
  };
}

