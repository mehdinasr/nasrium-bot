class NFTGalleryEngine:
    # لیست آثار هنری ضرب شده {nft_id: {name, creator, rarity, url}}
    ROYAL_COLLECTION = [
        {"id": "NFT_001", "name": "Neural Sunrise", "creator": "Mehdi", "rarity": "LEGENDARY"},
        {"id": "NFT_002", "name": "Titan Wreckage", "creator": "Sovereign_X", "rarity": "RARE"}
    ]

    @staticmethod
    def mint_neural_art(player_data, art_name):
        # بررسی سطح هوش مصنوعی
        if player_data.get("ai_autonomy_lvl", 0) < 2:
            return False, "AI Consciousness too low for artistic creation. Need Tier 2."

        # هزینه ضرب: 50 بلور اولیه (Primal Crystals)
        cost = 50
        if player_data.get("primal_crystals", 0) < cost:
            return False, f"Insufficient Primal Crystals. Need {cost} 💎"

        player_data["primal_crystals"] -= cost
        
        # تولید NFT (ساده‌سازی شده)
        import random
        rarity = random.choice(["COMMON", "UNCOMMON", "RARE", "EPIC"])
        nft_id = f"NFT-{random.randint(1000, 9999)}"
        
        new_art = {"id": nft_id, "name": art_name, "creator": player_data.get("username"), "rarity": rarity}
        NFTGalleryEngine.ROYAL_COLLECTION.append(new_art)
        
        return True, f"Art Minted: '{art_name}' added to the Royal Collection. Rarity: {rarity}."

    @staticmethod
    def get_gallery():
        return NFTGalleryEngine.ROYAL_COLLECTION
