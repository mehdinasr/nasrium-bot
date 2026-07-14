class DynastyEngine:
    # قطعات قابل ترکیب برای نشان
    ASSETS = {
        "symbols": ["Eagle", "Circuit", "Shield", "Skull", "Star"],
        "borders": ["Classic", "Neon", "Imperial", "Cyber"],
        "colors": ["#f1c40f", "#00f3ff", "#ff4757", "#2ecc71"]
    }

    @staticmethod
    def save_emblem(player_data, symbol, border, color):
        # هزینه طراحی نشان: 10,000 طلا و 10 NSM Hard (در صورت تغییر)
        cost_gold = 10000
        if player_data.get("gold", 0) < cost_gold:
            return False, "Insufficient Gold for heraldry services."

        player_data["gold"] -= cost_gold
        player_data["active_emblem"] = {
            "symbol": symbol,
            "border": border,
            "color": color
        }
        return True, "Imperial Decree: Your Dynasty Emblem has been etched in the archives."

    @staticmethod
    def get_assets():
        return DynastyEngine.ASSETS
