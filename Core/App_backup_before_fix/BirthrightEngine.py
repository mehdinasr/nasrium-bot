import time

class BirthrightEngine:
    # متون تبریک لود شده بر اساس انتخاب فرمانده (گزینه ۳)
    BDAY_GREETINGS = {
        "fa": "ناصریوم فراتر از یک اکوسیستم، یک خانواده است. خوشحالیم که در این مسیر همراه ما هستید. تولدتان مبارک! بهترین آرزوها برای شکوفایی و موفقیت شما. هدیه کوچک ما را بپذیرید. 🎂❤️",
        "en": "Nasrium is more than an ecosystem; it's a family. We are happy to have you on this journey. Happy Birthday! Best wishes for your prosperity and success. Please accept our small gift. 🎂❤️",
        "ru": "Nasrium — это больше, чем экосистема, это семья. Мы рады, что вы с нами в этом путешествии. С днем рождения! Наилучшие пожелания процветания и успеха. Пожалуйста, примите наш небольшой подарок. 🎂❤️"
    }

    @staticmethod
    def check_and_grant_gift(db, player_data):
        bday = player_data.get("birthday") # Format: "MM-DD"
        if not bday: return False, None
        
        current_date = time.strftime("%m-%d")
        current_year = time.strftime("%Y")
        last_gift_year = player_data.get("last_birthday_gift_year", "")
        
        if bday == current_date and last_gift_year != current_year:
            # هدیه امپراتوری: 10,000 طلا و 500 NSM Soft
            gift_gold = 10000
            gift_nsm = 500
            
            db.players.update_one(
                {"user_id": player_data["user_id"]},
                {
                    "$inc": {"gold": gift_gold, "nsm_soft": gift_nsm},
                    "$set": {"last_birthday_gift_year": current_year}
                }
            )
            
            lang = player_data.get("lang", "fa")
            msg = BirthrightEngine.BDAY_GREETINGS.get(lang, BirthrightEngine.BDAY_GREETINGS["en"])
            
            return True, {"gold": gift_gold, "nsm": gift_nsm, "message": msg}
        return False, None
