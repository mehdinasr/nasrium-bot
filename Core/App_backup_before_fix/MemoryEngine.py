import time

class MemoryEngine:
    @staticmethod
    def record_event(player_data, event_type, description):
        memory_entry = {"timestamp": time.time(), "type": event_type, "desc": description}
        ledger = player_data.get("neural_memory", [])
        ledger.append(memory_entry)
        player_data["neural_memory"] = ledger[-50:] # حفظ ۵۰ رکورد آخر
        return player_data

    @staticmethod
    def get_ai_persona_msg(player_data):
        ledger = player_data.get("neural_memory", [])
        if not ledger: return "Commander, Neural Link established. I am ready to record our legacy."
        wins = player_data.get("raid_wins", 0)
        if wins > 10: return "Commander, the archives glow with your victories. Our legacy is expanding."
        return "Awaiting your next directive. The Empire is steady under your watch."
