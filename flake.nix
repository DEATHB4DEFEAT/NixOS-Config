{
    description = "Death's system flake";

    inputs = {
        determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
        hyprpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-pin.url = "github:nixos/nixpkgs/nixos-unstable";
        nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

        nix-index-database = {
            url = "github:nix-community/nix-index-database";
            inputs.nixpkgs.follows = "nixpkgs";
        };


        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        # millennium.url = "git+https://github.com/SteamClientHomebrew/Millennium";
        # dolphin-overlay.url = "github:rumboon/dolphin-overlay";
        stylix = {
            url = "github:nix-community/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "github:hyprwm/Hyprland";
        hypr-dynamic-cursors = { url = "github:VirtCode/hypr-dynamic-cursors"; inputs.hyprland.follows = "hyprland"; };
        hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
        # Hyprspace = { url = "github:KZDKM/Hyprspace"; inputs.hyprland.follows = "hyprland"; };
        # split-monitor-workspaces = { url = "github:zjeffer/split-monitor-workspaces"; inputs.hyprland.follows = "hyprland"; };

        # nix-minecraft = {
        #     url = "github:Infinidoge/nix-minecraft";
        #     inputs.nixpkgs.follows = "nixpkgs";
        # };
        bedrock-on-linux = {
            url = "github:Wyze3306/BedrockOnLinux";
            inputs.nixpkgs.follows = "nixpkgs-pin";
        };

        zen-browser = {
            url = "github:youwen5/zen-browser-flake";
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

                    inputs.determinate.nixosModules.default

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


                    inputs.stylix.nixosModules.stylix

                    # inputs.nix-minecraft.nixosModules.minecraft-servers { nixpkgs.overlays = [ inputs.nix-minecraft.overlay ]; }
                ];
            };
        };
    };
}
