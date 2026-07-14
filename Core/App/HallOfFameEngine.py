class HallOfFameEngine:
    # لیست مشاهیر جاویدان {user_id: {username, achievement, date}}
    LEGENDS = [
        {"user_id": "COMMANDER_MEHDI_ID", "username": "Mehdi", "achievement": "The Architect of Nasrium", "rank": "Sovereign Apex"}
    ]

    @staticmethod
    def get_legends():
        return HallOfFameEngine.LEGENDS

    @staticmethod
    def nominate_legend(player_data, achievement_desc):
        # بررسی صلاحیت: حداقل لول 50 و امتیاز افتخار بالا
        if player_data.get("town_hall_lvl", 1) < 50 or player_data.get("honor_score", 0) < 1000000:
            return False, "Your legacy is not yet weighty enough for the Eternal Hall."
        
        # ثبت در لیست مشاهیر (در سیستم واقعی نیاز به تایید فرمانده دارد)
        new_legend = {
            "user_id": player_data["user_id"],
            "username": player_data.get("username", "Unknown Hero"),
            "achievement": achievement_desc,
            "rank": "Legendary Citizen"
        }
        HallOfFameEngine.LEGENDS.append(new_legend)
        return True, "Imperial Honor: Your name has been etched into the Eternal Hall of Fame."
