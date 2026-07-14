class TranslationEngine:
    # شبیه‌سازی لایه‌ی ترجمه هوش مصنوعی
    SUPPORTED_LANGS = ["EN", "FA", "RU", "AR", "ZH"]

    @staticmethod
    def translate_signal(text, target_lang="EN"):
        # در این گام، منطق تشخیص و ترجمه شبیه‌سازی می‌شود
        # در فاز نهایی به API مدل‌های زنده (مثل DeepL یا GPT) متصل می‌گردد
        prefix = f"[{target_lang}] "
        return prefix + text # شبیه‌سازی ترجمه
    
    @staticmethod
    def detect_language(text):
        # منطق تشخیص زبان (ساده‌سازی شده)
        return "AUTO"
