class SyndicateSpecEngine:
    # تعریف انواع دکترین‌های سندیکا
    DOCTRINES = {
        "iron_legion": {"name": "Iron Legion", "desc": "Combat focus: +15% Unit Power", "bonus_type": "military"},
        "megacorp": {"name": "Mega-Corporation", "desc": "Industrial focus: +15% Gold Rate", "bonus_type": "economy"},
        "techno_covenant": {"name": "Techno-Covenant", "desc": "Research focus: +20% IXP Gain", "bonus_type": "intelligence"}
    }

    @staticmethod
    def set_doctrine(syn_data, doctrine_id):
        if doctrine_id not in SyndicateSpecEngine.DOCTRINES:
            return False, "Invalid Doctrine identifier."
        
        # بررسی لول سندیکا (نیاز به لول ۳)
        if syn_data.get("level", 1) < 3:
            return False, "Syndicate Level 3 required to establish a Doctrine."

        # هزینه: 50,000 توکن از خزانه
        if syn_data.get("war_chest_nsm", 0) < 50000:
            return False, "Insufficient NSM Soft in War Chest."

        syn_data["war_chest_nsm"] -= 50000
        syn_data["active_doctrine"] = doctrine_id
        return True, f"Doctrine Established: Your alliance is now a {SyndicateSpecEngine.DOCTRINES[doctrine_id]['name']}."
