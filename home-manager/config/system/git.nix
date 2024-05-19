{
    programs = {
        git = {
            enable = true;
            userEmail = "zachcaffee@outlook.com";
            userName = "DEATHB4DEFEAT";
            signing = {
                key = "62B0D3993D872EBB";
                signByDefault = true;
            };
            extraConfig = {
                init.defaultBranch = "master";
                pull.rebase = false;
                http.postBuffer = 524288000;
            };
        };

        gh = {
            enable = true;
            gitCredentialHelper = {
                enable = true;
                hosts = [
                    "https://github.com"
                    "https://gist.github.com"
                ];
            };
        };
    };
}
