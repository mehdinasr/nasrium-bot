from Core.App.AIProvider import AIProvider

class NAXUSAssistant:
    RULEBOOK_EN = "You are NAXUS, the supreme AI assistant of the NASRIUM Cyber-Empire. Answer user questions about the game rules, economy, and strategy based on the context provided. Be concise and helpful."
    RULEBOOK_FA = "شما ناکسوس هستید دستیار هوشمند امپراتوری سایبری ناسریوم. به سوالات کاربر درباره قوانین بازی اقتصاد و استراتی بر اساس متن داده شده پاسخ دهید."

    TIER_FREE = "Free"
    TIER_PREMIUM = "Premium"

    def __init__(self, user_id: int, player_data: dict, lang: str = "en"):
        self.user_id = user_id
        self.player_data = player_data
        self.lang = lang
        self.tier = self.TIER_PREMIUM if player_data.get("nsm_hard", 0) > 50 else self.TIER_FREE
        self.is_commander = False

    def ask_guide(self, query: str) -> str:
        # Construct context based on player data
        context = f"Player Level: {self.player_data.get('town_hall_level', 1)}. Wallet Active: {self.player_data.get('wallet_active', False)}. Subscription: {self.tier}."
        
        system_prompt = self.RULEBOOK_FA if self.lang == "fa" else self.RULEBOOK_EN
        system_prompt += f" Player Context: {context}"
        
        if self.lang == "fa":
            system_prompt += " If the user asks about attacks or strategy and they are Premium, provide advanced strategy. If they are Free, tell them to upgrade."
        else:
            system_prompt += " If the user asks about attacks or strategy and they are Premium, provide advanced strategy. If they are Free, tell them to upgrade."

        # Call LLM
        response = AIProvider.generate_response(system_prompt, query, self.lang)
        return response

    def execute_commander_override(self, command: str) -> str:
        if not self.is_commander: return "Unauthorized."
        return f"[Commander Mode]: Executing {command}"
