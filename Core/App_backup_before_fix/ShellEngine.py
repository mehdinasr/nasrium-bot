class ShellEngine:
    @staticmethod
    def execute_command(player_data, cmd_text):
        cmd = cmd_text.upper().strip()
        
        if cmd == "UPGRADE_ALL_MINES":
            # منطق ارتقای دسته‌ای (ساده سازی شده)
            return True, "Batch upgrade initiated for all production nodes."
            
        elif cmd == "MASS_RECRUIT":
            gold = player_data.get("gold", 0)
            recruited = int(gold / 100) # هر سرباز ۱۰۰ طلا
            if recruited > 0:
                player_data["gold"] -= (recruited * 100)
                player_data["troops"] += recruited
                return True, f"Mass recruitment successful: {recruited} units added to frontline."
            return False, "Insufficient Gold for mass recruitment."
            
        elif cmd == "SCAN_WEAKEST":
            return True, "Satellite arrays searching for low-integrity targets..."
            
        return False, f"Command '{cmd}' not recognized by Sovereign Shell."
