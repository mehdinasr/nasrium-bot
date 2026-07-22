class DexBridgeEngine:
    """ID_1049: مدیریت آماده سازی برای لیستینگ در DEX."""
    MIN_LISTING_AMOUNT = 100 # حداقل 100 NSM برای صادرات
    
    @staticmethod
    def verify_listing_eligibility(player_data):
        nsm_balance = player_data.get("nsm_tokens", 0)
        credit_score = player_data.get("credit_score", 0)
        
        if nsm_balance >= DexBridgeEngine.MIN_LISTING_AMOUNT and credit_score >= 500:
            return True, "Identity verified for DEX Listing."
        return False, "Insufficient NSM or low Credit Score for export."

    @staticmethod
    def generate_listing_signature(u_id, amount):
        import hashlib
        import time
        raw_sig = f"DEX-{u_id}-{amount}-{time.time()}"
        return hashlib.sha256(raw_sig.encode()).hexdigest().upper()
