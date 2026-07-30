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
// with a gap + shadow (native Zen prefs, not a CSS overlay). Separation maxed at
// 12 (Zen's hard limit), rounded corners, and an accent color so the backdrop is
// tinted → the white content card visibly pops (floats) against it.
user_pref("zen.theme.content-element-separation", 12);
user_pref("zen.theme.border-radius", 14);
user_pref("zen.theme.accent-color", "#7b6ef6");
