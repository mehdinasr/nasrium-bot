class HighwayEngine:
    # ضرایب بهینه‌سازی بر اساس سطح شاه‌راه
    VELOCITY_BUFF = 0.30 # ۳۰٪ افزایش سرعت ثابت

    @staticmethod
    def calculate_transfer_time(base_time, highway_level):
        # کاهش زمان انتقال بر اساس سطح زیرساخت
        reduction = base_time * (HighwayEngine.VELOCITY_BUFF + (highway_level * 0.05))
        return max(base_time - reduction, base_time * 0.1) # حداقل ۱۰٪ زمان پایه

    @staticmethod
    def upgrade_bandwidth(player_data):
        # هزینه ارتقا: 100,000 طلا و 50 بلور اولیه
        cost_gold = 100000
        cost_crystals = 50
        
        if player_data.get("gold", 0) < cost_gold or player_data.get("primal_crystals", 0) < cost_crystals:
            return False, "Insufficient resources for bandwidth expansion."

        player_data["gold"] -= cost_gold
        player_data["primal_crystals"] -= cost_crystals
        player_data["highway_level"] = player_data.get("highway_level", 1) + 1
        
        return True, f"Cyber-Highway upgraded to Level {player_data['highway_level']}. Global velocity increased."
