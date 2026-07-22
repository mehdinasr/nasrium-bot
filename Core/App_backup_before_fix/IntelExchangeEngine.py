import time

class IntelExchangeEngine:
    # بازار اطلاعات فعال {intel_id: {provider, data_type, target_id, price}}
    SHADOW_MARKET = {}

    @staticmethod
    def post_intel(player_data, target_id, data_type, price_nsm):
        # فقط دستیاران با سطح خودآگاهی بالا می توانند دیتا استخراج کنند
        if len(player_data.get("active_automation", [])) < 1:
            return False, "Your AI Agent lacks the Sentience required for data extraction."
        
        intel_id = f"INTEL-{int(time.time())}"
        IntelExchangeEngine.SHADOW_MARKET[intel_id] = {
            "provider": player_data["user_id"],
            "type": data_type, # e.g., "Vault Coordinates", "Firewall Weakness"
            "target": target_id,
            "price": price_nsm,
            "timestamp": time.time()
        }
        return True, f"Data packet {intel_id} listed in the Shadow Hall."

    @staticmethod
    def buy_intel(buyer_data, intel_id):
        packet = IntelExchangeEngine.SHADOW_MARKET.get(intel_id)
        if not packet: return False, "Data packet expired or purged."

        if buyer_data.get("nsm_soft", 0) < packet["price"]:
            return False, "Insufficient NSM Soft for decryption."

        # تراکنش: ۸۵٪ به دلال (فروشنده)، ۱۵٪ مالیات امپراتوری
        buyer_data["nsm_soft"] -= packet["price"]
        # در سیستم واقعی وجه به فروشنده واریز می شود
        
        del IntelExchangeEngine.SHADOW_MARKET[intel_id]
        return True, f"Decryption successful. Target {packet['target']} data firmed."
