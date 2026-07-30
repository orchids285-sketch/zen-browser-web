// Native Zen interface — the ONLY pref change is suppressing the first-run
// welcome/onboarding page. No theming, no font override, no newtab override,
// no disabling of Zen's workspaces/sidebar. Zen looks + behaves like default.
user_pref("zen.welcome-screen.seen", true);
user_pref("zen.welcomeScreen.seen", true);
user_pref("zen.first-run.seen", true);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);

// Zen's signature FLOATING content look: the webpage floats in a rounded card
// with a margin all around (native Zen prefs, not a CSS overlay).
user_pref("zen.theme.content-element-separation", 10);
user_pref("zen.theme.border-radius", 12);
