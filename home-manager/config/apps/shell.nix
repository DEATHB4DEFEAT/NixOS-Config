{
    pkgs,
    ...
}:

{
    services.gpg-agent = {
        enableBashIntegration = true;
        enableNushellIntegration = true;
    };

    programs = {
        bash = {
            enable = true;
            shellAliases = {
                reconf = "git add .; nh os switch . -- --impure; hyprctl switchxkblayout all 1";
                hs = "cat ~/.bash_history | grep -i";
                nano = "nano -ZDEFLSil%0T4";
                c = "clear";
            };
            bashrcExtra = ''
                eval "$(zoxide init bash)"
            '';
            historyFileSize = 2147483647;
            historySize = 2147483647;
        };


        starship =
            let catppuccin-flavour = "mocha";
        in {
            enable = true;
            enableNushellIntegration = true;

            settings = {
                # [❄️]@death — ~/.setup
                # §❯ echo hi
                format = "$os$username — $directory\n$sudo$character";
                # 13:07:02
                right_format = "$time";


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

                + builtins.readFile ./config/starship/default.toml
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
