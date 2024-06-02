{
    description = "Death's system flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-index-database.url = "github:nix-community/nix-index-database";
        nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    };


    outputs = { nixpkgs, home-manager, nix-index-database, ... }:
        let system = "x86_64-linux";
    in {
        nixosConfigurations = {
            DTLinix = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./nixos/configuration.nix

                    home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                            useUserPackages = true;
                            useGlobalPkgs = true;
                            users.death = ./home-manager/users/death.nix;
                            backupFileExtension = "bak";
                        };
                    }

                    nix-index-database.nixosModules.nix-index
                    {
                        programs.nix-index-database.comma.enable = true;
                        programs.command-not-found.enable = false;
                    }
                ];
            };
        };
    };
}
