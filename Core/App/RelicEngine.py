class RelicEngine:
    # تعریف اشیاء باستانی و پاداش‌های آن‌ها
    RELICS = {
        "obsidian_shard": {"name": "Obsidian Shard", "buff": "Plasma DMG +3%", "source": "Obsidian Golem"},
        "void_scale": {"name": "Void Scale", "buff": "Mining Energy -5%", "source": "Void Serpent"},
        "neural_circuit": {"name": "Ancient Circuit", "buff": "AI IXP Speed +5%", "source": "Deep Mining"}
    }

    @staticmethod
    def exhibit_relic(player_data, relic_id):
        # بررسی وجود شیء در اینونتوری (بخش اشیاء خاص)
        special_inv = player_data.get("special_items", [])
        if relic_id not in special_inv:
            return False, "This relic is not in your possession."

        # بررسی ظرفیت موزه
        museum = player_data.get("museum_exhibits", [])
        capacity = player_data.get("museum_capacity", 3)
        
        if len(museum) >= capacity:
            return False, "Museum capacity reached. Upgrade your hall."

        if relic_id in museum:
            return False, "Relic is already on display."

        museum.append(relic_id)
        player_data["museum_exhibits"] = museum
        return True, f"Relic {RelicEngine.RELICS[relic_id]['name']} is now on display. Buff active."
