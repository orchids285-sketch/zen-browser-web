// Stock Zen — the ONLY change is suppressing the first-run welcome/presentation
// page. No theming, no rebrand, no font/newtab/sidebar changes.
user_pref("zen.welcome-screen.seen", true);
user_pref("zen.welcomeScreen.seen", true);
user_pref("zen.first-run.seen", true);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);
