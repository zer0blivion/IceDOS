{
  inputs = {
    # Update channels
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
      follows = "chaotic/nixpkgs";
    };

    # Modules
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nerivations = {
      url = "github:icedborn/nerivations";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    steam-session = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      follows = "chaotic/jovian";
    };

    # Apps
    hyprland.url = "github:hyprwm/Hyprland";

    phps = {
      url = "github:fossar/nix-phps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pipewire-screenaudio = {
      url = "github:IceDBorn/pipewire-screenaudio";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    shell-in-netns = {
      url = "github:jim3692/shell-in-netns";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yuzu = {
      url = "git+https:///codeberg.org/K900/yuzu-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      chaotic,
      nixpkgs,
      home-manager,
      nerivations,
      steam-session,
      hyprland,
      phps,
      pipewire-screenaudio,
      shell-in-netns,
      yuzu,
    }@inputs:
    {
      nixosConfigurations.${nixpkgs.lib.fileContents "/etc/hostname"} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          # Read configuration location
          (
            { lib, ... }:
            let
              inherit (lib) mkOption types fileContents;
            in
            {
              options.icedos.configurationLocation = mkOption {
                type = types.str;
                default = fileContents "/tmp/configuration-location";
              };
            }
          )

          # Internal modules
          ./modules.nix

          # External modules
          chaotic.nixosModules.default
          home-manager.nixosModules.home-manager
          hyprland.nixosModules.default
          nerivations.nixosModules.default
          steam-session.nixosModules.default
        ];
      };
    };
}
