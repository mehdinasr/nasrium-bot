window.NASRIUM_I18N = {
    translations: {},
    currentLang: "en",
    isRTL: false,

    async init() {
        let langCode = "en";
        try {
            const tgUser = window.Telegram?.WebApp?.initDataUnsafe?.user;
            if (tgUser && tgUser.language_code) {
                langCode = tgUser.language_code;
            }
        } catch (e) {
            console.warn("[i18n] Could not read Telegram language_code, defaulting to en.");
        }

        try {
            const res = await fetch(`/api/localization/${langCode}`);
            const data = await res.json();
            this.translations = data.translations || {};
            this.currentLang = data.code || "en";
            this.isRTL = !!data.rtl;
        } catch (e) {
            console.error("[i18n] Failed to load localization, using empty fallback.", e);
            this.translations = {};
        }

        if (this.isRTL) {
            document.documentElement.setAttribute("dir", "rtl");
            document.documentElement.setAttribute("lang", this.currentLang);
        } else {
            document.documentElement.setAttribute("dir", "ltr");
            document.documentElement.setAttribute("lang", this.currentLang);
        }

        console.log(`[i18n] Loaded language: ${this.currentLang} (RTL: ${this.isRTL})`);
        window.dispatchEvent(new Event("nasrium-i18n-ready"));
    },

    t(key) {
        return this.translations[key] || key;
    }
};

window.t = (key) => window.NASRIUM_I18N.t(key);

