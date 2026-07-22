class BioEngine:
    # وضعیت لایه ژنتیکی ارتش بازیکنان {player_id: {mutation_level, total_bio_troops, toxic_res}}
    BIO_ARMY_REGISTRY = {}

    @staticmethod
    def mutate_infantry(player_id, biomass_allocated):
        if player_id not in BioEngine.BIO_ARMY_REGISTRY:
            BioEngine.BIO_ARMY_REGISTRY[player_id] = {
                "mutation_level": 1,
                "total_bio_troops": 0,
                "toxic_resistance": 15 # درصد مقاومت اولیه
            }
        
        army = BioEngine.BIO_ARMY_REGISTRY[player_id]
        
        # هر ۱۰۰۰ واحد بایومس، یک سطح جهش یا افزایش نیرو ایجاد می‌کند
        gained_troops = int(biomass_allocated / 100)
        army["total_bio_troops"] += gained_troops
        
        if gained_troops > 5:
            army["mutation_level"] += 1
            army["toxic_resistance"] = min(99, army["toxic_resistance"] + 5)

        return True, army

    @staticmethod
    def get_lab_status(player_id):
        return BioEngine.BIO_ARMY_REGISTRY.get(player_id, {"mutation_level": 0, "total_bio_troops": 0, "toxic_resistance": 0})
