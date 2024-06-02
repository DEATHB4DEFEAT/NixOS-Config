{
    pkgs,
    ...
}:

{
    services.gpg-agent = {
        enableBashIntegration = true;
        enableNushellIntegration = true;
    };

    programs =
        let shellAliases = {
            reconf = "git add .; nh os switch . -- --impure"; # Damn impure symlinks...
            hs = "cat ~/.bash_history | grep -i";
        };
    in {
        bash = {
            enable = true;
            shellAliases = shellAliases;
        };

        nushell = {
            enable = true;
            configFile.source = ./config/nushell/config.nu;
            envFile.source = ./config/nushell/env.nu;
            shellAliases = shellAliases;
        };


        starship =
            let catppuccin-flavour = "mocha";
        in {
            enable = true;
            enableNushellIntegration = true;
            settings = {
                time = {
                    disabled = false;
                    time_format = "%Y-%m-%d %H:%M:%S";
                };
                aws.disabled = true;
                gcloud.disabled = true;
                openstack.disabled = true;
                hostname.disabled = true;
                nix_shell = {
                    disabled = true;
                    # heuristic = true;
                };
                palette = "catppuccin_${catppuccin-flavour}";
            }
            // builtins.fromTOML (
                builtins.readFile (
                    pkgs.fetchFromGitHub {
                        owner = "catppuccin";
                        repo = "starship";
                        rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
                        hash = "sha256-nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
                    }
                    + /palettes/${catppuccin-flavour}.toml
                )
            );
        };

        direnv = {
            enable = true;
            enableBashIntegration = true;
            enableNushellIntegration = true;
            nix-direnv.enable = true;
        };
    };
}
