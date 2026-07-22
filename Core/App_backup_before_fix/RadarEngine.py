import random
import time

class RadarEngine:
    @staticmethod
    def get_threat_level(player_data):
        # سطح رادار بر قدرت تشخیص اثر می گذارد
        buildings = player_data.get("buildings", {})
        radar_lvl = buildings.get("satellite_radar", 0)
        
        if radar_lvl == 0:
            return "Unknown", "Build a Satellite Radar to scan for threats."

        # شبیه‌سازی تحلیل تهدید بر اساس لول رادار
        # لول بالاتر = دقت بیشتر در تشخیص
        seed = int(time.time() / 3600) # تغییر وضعیت هر ساعت
        random.seed(seed)
        
        risk_score = random.randint(1, 100)
        
        if risk_score > 80:
            return "CRITICAL", "Large fleet movements detected in your sector!"
        elif risk_score > 40:
            return "ELEVATED", "Minor scout activity identified nearby."
        else:
            return "LOW", "No immediate threats detected by Satellite."

# بروزرسانی لیست ساختمان های MetropolisEngine
path_met = 'Core/App/MetropolisEngine.py'
with open(path_met, 'r', encoding='utf-8') as f: content = f.read()
if 'satellite_radar' not in content:
    new_building = '        "satellite_radar": {"label": "Satellite Radar", "desc": "Early Warning System", "base_cost": 4000}'
    content = content.replace('"cyber_wall": {"label": "Cyber Wall", "desc": "Protects Gold", "base_cost": 3000},',
                               '"cyber_wall": {"label": "Cyber Wall", "desc": "Protects Gold", "base_cost": 3000},\n' + new_building)
    with open(path_met, 'w', encoding='utf-8') as f: f.write(content)

