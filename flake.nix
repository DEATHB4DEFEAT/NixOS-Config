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

        plasma-manager = {
            url = "github:pjones/plasma-manager";
            inputs = {
                nixpkgs.follows = "nixpkgs";
                home-manager.follows = "home-manager";
            };
        };
    };


    outputs = { nixpkgs, nix-index-database, home-manager, plasma-manager, ... }:
        let system = "x86_64-linux";
    in {
        nixosConfigurations = {
            DTLinix = nixpkgs.lib.nixosSystem {
                inherit system;
                modules = [
                    ./nixos/configuration.nix

                    nix-index-database.nixosModules.nix-index
                    {
                        programs = {
                            nix-index-database.comma.enable = true;
                            command-not-found.enable = false;
                        };
                    }


                    home-manager.nixosModules.home-manager
                    {
                        home-manager = {
                            useUserPackages = true;
                            useGlobalPkgs = true;
                            users.death = ./home-manager/users/death.nix;
                            # users.test = ./home-manager/users/test.nix;
                            backupFileExtension = "bak";
                        };
                    }

                    # plasma-manager.nixosModules.plasma-manager
                ];
            };
        };
    };
}
