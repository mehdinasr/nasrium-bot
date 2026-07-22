class BrandEngine:
    # نام برند به صورت ثابت و غیرقابل تغییر
    IDENTITY = "Nasrium"
    SLOGAN = "The High-Engineering Web3 & AI Ecosystem"

    @staticmethod
    def get_manifesto():
        return {
            "brand": BrandEngine.IDENTITY,
            "slogan": BrandEngine.SLOGAN,
            "rule_01": "The name 'Nasrium' must never be translated or transliterated.",
            "rule_02": "Nasrium is the global standard for all sectors."
        }

    @staticmethod
    def enforce_name(text):
        # این تابع در نسخه‌های آینده برای فیلتر کردن متون پویا استفاده می‌شود
        return text
