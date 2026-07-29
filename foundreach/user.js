// FoundReach Browser — enforced defaults (re-applied on every launch).

// ── Start page = our page, no Zen landing / welcome / onboarding ─────────────
// Hosted over HTTPS on the SaaS domain (Firefox refuses file:// as a homepage).
user_pref("browser.startup.homepage", "https://foundreach-app.vercel.app/browser-home.html");
user_pref("browser.startup.page", 1);                       // open homepage on start
user_pref("browser.sessionstore.resume_from_crash", false); // never restore old session
user_pref("browser.sessionstore.max_resumed_crashes", 0);
user_pref("browser.startup.couldRestoreSession.count", 0);
user_pref("browser.startup.homepage_override.mstone", "ignore");
user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("startup.homepage_override_url", "");
user_pref("browser.aboutwelcome.enabled", false);
user_pref("trailhead.firstrun.didSeeAboutWelcome", true);
user_pref("browser.messaging-system.whatsNewPanel.enabled", false);
user_pref("browser.startup.firstrunSkipsHomepage", false);
// Zen's own welcome / first-run
user_pref("zen.welcome-screen.seen", true);
user_pref("zen.welcomeScreen.seen", true);
user_pref("zen.first-run.seen", true);
user_pref("browser.disableResetPrompt", true);

// ── New tab = clean (our style via userContent.css); kill sponsored/pocket ───
user_pref("browser.newtabpage.enabled", true);
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.system.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.default.sites", "");
user_pref("browser.topsites.contile.enabled", false);
user_pref("extensions.pocket.enabled", false);

// ── Remove the vertical tab sidebar "languette" → normal horizontal tabs ─────
user_pref("zen.tabs.vertical", false);
user_pref("zen.tabs.vertical.right-side", false);
user_pref("zen.view.sidebar-expanded", false);
user_pref("zen.view.sidebar-expanded.on-hover", false);
user_pref("zen.view.compact.hide-tabbar", false);
user_pref("zen.view.compact.hide-toolbar", false);
user_pref("zen.workspaces.enabled", false);
user_pref("zen.theme.accent-color", "#1b1b1a");

// ── Enable our userChrome.css / userContent.css theming ──────────────────────
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.uidensity", 0);

// ── Quiet, private, clean ────────────────────────────────────────────────────
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shopping.experience2023.enabled", false);
user_pref("browser.tabs.firefox-view", false);
user_pref("browser.search.suggest.enabled", true);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
