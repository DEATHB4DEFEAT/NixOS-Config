{
    description = "Death's system flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };


        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland = {
            type = "git";
            url = "https://github.com/hyprwm/Hyprland";
            submodules = true;
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hypr-dynamic-cursors = { url = "github:VirtCode/hypr-dynamic-cursors"; inputs.hyprland.follows = "hyprland"; };
        Hyprspace = { url = "github:KZDKM/Hyprspace"; inputs.hyprland.follows = "hyprland"; };
        split-monitor-workspaces = { url = "github:Duckonaut/split-monitor-workspaces"; inputs.hyprland.follows = "hyprland"; };


        nix-minecraft = {
            url = "github:Infinidoge/nix-minecraft";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };


    outputs = inputs: let
        system = "x86_64-linux";
    in {
        nixosConfigurations = {
            DTLinix = inputs.nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs; };
                modules = [
                    ./nixos/configuration.nix

                    inputs.nix-index-database.nixosModules.nix-index
                    {
                        programs = {
                            nix-index-database.comma.enable = true;
                            command-not-found.enable = false;
                        };
                    }


                    inputs.home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                            useUserPackages = true;
                            useGlobalPkgs = true;
                            users.death = ./home-manager/users/death.nix;
                            backupFileExtension = "bak";
                            extraSpecialArgs = { inherit inputs; };
                        };
                    }


                    inputs.nix-minecraft.nixosModules.minecraft-servers { nixpkgs.overlays = [ inputs.nix-minecraft.overlay ]; }
                ];
            };
        };
    };
}
