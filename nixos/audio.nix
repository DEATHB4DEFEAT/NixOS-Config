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
        extraConfig.pipewire."91-null-sinks"."context.objects" =
        let
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
        in
        [
            ((sinker "Null-Music-Sink") "Null Music Sink")
            ((sinker "Null-Comms-Sink") "Null Comms Sink")
            ((sinker "Null-Experimental-Sink") "Null Experimental Sink")
        ];
    };
}
