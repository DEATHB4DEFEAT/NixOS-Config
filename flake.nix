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

        ags.url = "github:aylur/ags/v1";

        hyprland = {
            type = "git";
            url = "https://github.com/hyprwm/Hyprland";
            # rev = "29e2e59fdbab8ed2cc23a20e3c6043d5decb5cdc"; # v0.48.1
        rev = "9958d297641b5c84dcff93f9039d80a5ad37ab00"; # v0.49.0
            submodules = true;
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hypr-dynamic-cursors = { url = "github:VirtCode/hypr-dynamic-cursors"; inputs.hyprland.follows = "hyprland"; };
        hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
        Hyprspace = { url = "github:KZDKM/Hyprspace"; inputs.hyprland.follows = "hyprland"; };
        split-monitor-workspaces = { url = "github:Duckonaut/split-monitor-workspaces"; inputs.hyprland.follows = "hyprland"; };


        nix-minecraft = {
            url = "github:Infinidoge/nix-minecraft";
            inputs.nixpkgs.follows = "nixpkgs";
        };


        jovian-nixos = {
            url = "github:Jovian-Experiments/Jovian-NixOS";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };


    outputs = inputs: {
        nixosConfigurations = {
            DTLinix = inputs.nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
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
                            verbose = true;
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
