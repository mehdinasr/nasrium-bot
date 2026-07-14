import time

class SuspensionEngine:
    # متون اخطار به زبان‌های مختلف طبق دستور فرمانده
    MESSAGES = {
        "fa": "«هشدار امنیتی ناصریوم: تشخیص آنومالی»\n\nشهروند گرامی، هسته مرکزی امنیت پروژه ناصریوم فعالیت شما را خارج از پروتکل‌های قانونی و تخطی از نظم اکوسیستم تشخیص داده است.\nبر اساس «پروتکل رحمت استراتژیک»، حساب شما برای اولین بار تنها به مدت ۳ ساعت به حالت تعلیق درآمد. در صورت تکرار، برخوردهای بسیار سخت‌گیرانه‌تری اعمال خواهد شد.\n\nنظم، بقای امپراتوری است.",
        "en": "«Nasrium Security Alert: Anomaly Detected»\n\nCitizen, the core security engine has identified activity outside legal protocols. Under the 'Strategic Mercy Protocol', your account is suspended for 3 hours. Further violations will result in stricter actions.\n\nOrder is the survival of the Empire.",
        "ru": "«Оповещение безопасности Nasrium: Аномалия»\n\nГражданин, служба безопасности выявила нарушения протоколов. Согласно «Протоколу милосердия», ваш аккаунт приостановлен на 3 часа. Повторные нарушения приведут к более строгим мерам.\n\nПорядок — залог выживания Империи."
    }

    @staticmethod
    def mask_id(user_id):
        # تبدیل آی‌دی به فرمت ستاره‌دار (مثلاً 123456789 -> 123***89)
        s = str(user_id)
        if len(s) < 5: return s[0] + "***" + s[-1]
        return s[:3] + "***" + s[-2:]

    @staticmethod
    def is_suspended(player_data):
        return time.time() < player_data.get("suspended_until", 0)

    @staticmethod
    def get_remaining_time(player_data):
        return max(0, int((player_data.get("suspended_until", 0) - time.time()) / 60))
