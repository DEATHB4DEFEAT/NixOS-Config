{
    pkgs,
    lib,
    ...
}:

{
    environment = {
        systemPackages = with pkgs; [
            carla
            lsp-plugins
            speexdsp
            rnnoise-plugin
            deepfilternet
        ];

        variables =
            let
                makePluginPath = format:
                    (lib.makeSearchPath format [
                        "$HOME/.nix-profile/lib"
                        "/run/current-system/sw/lib"
                        "/etc/profiles/per-user/$USER/lib"
                    ])
                    + ":$HOME/.${format}";
            in
                {
                    DSSI_PATH = makePluginPath "dssi";
                    LADSPA_PATH = makePluginPath "ladspa";
                    LV2_PATH = makePluginPath "lv2";
                    LXVST_PATH = makePluginPath "lxvst";
                    VST_PATH = makePluginPath "vst";
                    VST3_PATH = makePluginPath "vst3";
                };
    };

    services.pipewire = {
        extraConfig.pipewire = let
            sinker = name: (desc: {
                factory = "adapter";
                args = {
                    "factory.name" = "support.null-audio-sink";
                    "node.name" = name;
                    "node.description" = desc;
                    "media.class" = "Audio/Sink";
                    "audio.position" = "FL,FR";
                };
            });
            sourcer = name: (desc: {
                name = "libpipewire-module-loopback";
                args = {
                    "audio.position" = [ "FL" "FR" ];
                    "capture.props" = {
                        "media.class" = "Audio/Sink";
                        "node.name" = name;
                        "node.description" = desc;
                    };
                    "playback.props" = {
                        "media.class" = "Audio/Source";
                        "node.name" = name;
                        "node.description" = desc;
                    };
                };
            });
        in {
            "91-null-sinks" = {
                "context.objects" = [
                    ((sinker "Null-Music-Sink") "Null Music Sink")
                    ((sinker "Null-Comms-Sink") "Null Comms Sink")
                    ((sinker "Null-Experimental-Sink") "Null Experimental Sink")
                ];
                "context.modules" = [
                    ((sourcer "Null-Comms-Source") "Null Comms Source")
                    ((sourcer "Null-Experimental-Source") "Null Experimental Source")
                ];
            };
        };
    };

    # systemd.services = {
    #     carla = {
    #         enable = true;
    #         description = "Carla Patchbay Auto Starter";
    #         wantedBy = [ "default.target" ];
    #         environment = {
    #             PIPEWIRE_LINK_PASSIVE=true;
    #         };
    #         serviceConfig = {
    #             execStart = "${pkgs.carla}/bin/carla-rack --no-gui %h/Documents/carla_default.carxp";
    #         };
    #     };
    # };
}
