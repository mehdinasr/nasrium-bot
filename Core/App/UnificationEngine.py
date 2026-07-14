class UnificationEngine:
    # تثبیت نام‌های رسمی پروژه
    IDENTITY = {
        "EN": "Nasrium",
        "FA": "نصریوم",
        "AR": "نصریوم"
    }

    @staticmethod
    def get_brand_name(lang="EN"):
        return UnificationEngine.IDENTITY.get(lang, "Nasrium")

    @staticmethod
    def lock_alpha_state():
        # قفل کردن وضعیت برای لانچ آلفا
        return {
            "version": "1.0.0-ALPHA",
            "naming_standard": "VERIFIED",
            "core_integrity": "SEALED"
        }
