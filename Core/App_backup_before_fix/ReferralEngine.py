class ReferralEngine:
    # پاداش‌ها
    INVITE_BONUS_SOFT = 5000  # پاداش اولیه
    ROYALTY_BONUS_HARD = 1    # پاداش در صورت پیشرفت (نمادین)

    @staticmethod
    def generate_referral_link(user_id):
        # تولید لینک اختصاصی تلگرام برای مینی‌اپ ناصریوم
        return f"https://t.me/NasriumBot/app?startapp=ref_{user_id}"

    @staticmethod
    def process_new_recruit(inviter_data, recruit_id):
        # ثبت نفر جدید در لیست سفیر
        recruits = inviter_data.get("recruits", [])
        if recruit_id not in recruits:
            recruits.append(recruit_id)
            inviter_data["recruits"] = recruits
            # واریز پاداش اولیه
            inviter_data["nsm_soft"] = inviter_data.get("nsm_soft", 0) + ReferralEngine.INVITE_BONUS_SOFT
            return True, f"New Recruit synchronized. {ReferralEngine.INVITE_BONUS_SOFT} NSM credited to Envoy."
        return False, "Recruit already registered."
