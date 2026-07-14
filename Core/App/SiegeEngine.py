import time

class SiegeEngine:
    # مشخصات غول جهانی (در نسخه نهایی در DB ذخیره می‌شود)
    BOSS = {
        "name": "VOID REBEL PRIME",
        "max_hp": 1000000,
        "current_hp": 1000000,
        "last_reset": time.time()
    }

    @staticmethod
    def get_boss_status(db):
        # خواندن وضعیت از کالکشن جهانی
        status = db.world_state.find_one({"type": "world_boss"})
        if not status:
            status = SiegeEngine.BOSS
            db.world_state.insert_one({"type": "world_boss", **status})
        return status

    @staticmethod
    def attack_boss(db, player_data, damage):
        # کاهش سلامتی غول و ثبت امتیاز برای بازیکن
        db.world_state.update_one(
            {"type": "world_boss"},
            {"$inc": {"current_hp": -damage}}
        )
        # پاداش ایردراپ و تجربه به بازیکن بابت شجاعت
        from Core.App.ExperienceEngine import ExperienceEngine
        player_data, _ = ExperienceEngine.add_xp(player_data, int(damage / 10))
        return player_data
