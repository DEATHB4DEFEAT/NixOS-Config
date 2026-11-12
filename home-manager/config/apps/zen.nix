{
    inputs,
    ...
}:

{
    imports = [
        inputs.zen-browser.homeModules.beta
    ];

    programs.zen-browser = {
        enable = true;
        setAsDefaultBrowser = true;
        profiles."Default Profile".sine.enable = true;
    };
}
