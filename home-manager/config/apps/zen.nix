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

        policies = {
            AIControls = {
                Default.Value = "blocked";
                Translations.Value = "available";
            };
            AutofillCreditCardEnabled = false;
            DisableFirefoxStudies = true;
            DisablePocket = true;
            DisableProfileImport = true;
            DisableSetDesktopBackground = true;
            GenerativeAI = {
                Enabled = false;
            };
            OfferToSaveLogins = false;
        };

        profiles."Default Profile" = {
            sine.enable = true;

            settings = {
                "browser.aboutConfig.showWarning" = false;
                "browser.newtabpage.enabled" = false;
                "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
                "browser.tabs.allow_transparent_browser" = true;
                "browser.tabs.fadeOutUnloadedTabs" = true;
                "browser.urlbar.suggest.bookmark" = false;
                "browser.urlbar.suggest.clipboard" = false;
                "browser.urlbar.suggest.engines" = false;
                "browser.urlbar.suggest.openpage" = false;
                "browser.urlbar.suggest.recentsearches" = false;
                "browser.urlbar.suggest.searches" = false;
                "general.autoScroll" = true;
                "zen.widget.linux.transparency" = true;
                "zen.workspaces.continue-where-left-off" = true;
            };
        };
    };
}
