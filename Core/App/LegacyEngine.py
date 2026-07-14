import time

class LegacyEngine:
    @staticmethod
    def add_to_archive(player_data, event_name, description):
        entry = {
            "timestamp": time.time(),
            "event": event_name,
            "desc": description
        }
        archive = player_data.get("legacy_ledger", [])
        archive.append(entry)
        player_data["legacy_ledger"] = archive
        
        # افزایش امتیاز میراث
        player_data["legacy_score"] = player_data.get("legacy_score", 0) + 100
        return True
    
    @staticmethod
    def get_ledger(player_data):
        return player_data.get("legacy_ledger", [])
