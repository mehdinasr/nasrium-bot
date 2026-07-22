import os

print('[STEP 1] Upgrading GameEngine with Clash-style Max Rule...')
game_code = """class GameEngine:
    # هزینه ارتقای Nexus Core
    NEXUS_UPGRADE_COSTS = {
        1: {"gold": 1000, "nsm_soft": 10},
        2: {"gold": 5000, "nsm_soft": 50},
        3: {"gold": 25000, "nsm_soft": 250},
        4: {"gold": 100000, "nsm_soft": 1000},
        5: {"gold": 500000, "nsm_soft": 5000}
    }

    @staticmethod
    def attempt_nexus_upgrade(player_data: dict) -> dict:
        current_level = player_data.get("town_hall_level", 1)
        costs = GameEngine.NEXUS_UPGRADE_COSTS.get(current_level)

        if not costs:
            return {"success": False, "message": "Max level reached"}

        # قانون کلش: معادن باید در سطح فعلی تاون هال مکس باشند!
        buildings = player_data.get("buildings", {"gold_mine": 0, "gem_drill": 0})
        if buildings.get("gold_mine", 0) < current_level or buildings.get("gem_drill", 0) < current_level:
            return {"success": False, "message": "Upgrade Gold Mine & Gem Drill to current Nexus level first!"}

        player_gold = player_data.get("gold", 0)
        player_soft = player_data.get("nsm_soft", 0)

        if player_gold >= costs["gold"] and player_soft >= costs["nsm_soft"]:
            new_level = current_level + 1
            # بررسی آیا در سطح جدید ساختمانها همچنان مکس هستند (احتمالاً خیر)
            is_maxed = (buildings.get("gold_mine", 0) >= new_level and buildings.get("gem_drill", 0) >= new_level)
            
            return {
                "success": True,
                "new_gold": player_gold - costs["gold"],
                "new_nsm_soft": player_soft - costs["nsm_soft"],
                "new_level": new_level,
                "is_nexus_maxed": is_maxed
            }
        
        return {"success": False, "message": "Insufficient resources (Gold or NSM_Soft)"}
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/GameEngine.py', 'w', encoding='utf-8') as f: f.write(game_code)
print('[OK] GameEngine upgraded with Max Rule')

print('[STEP 2] Creating WarEngine.py (Syndicate Wars)...')
war_code = """class WarEngine:
    @staticmethod
    def declare_war(attacker_clan_id: str, defender_clan_id: str) -> dict:
        if not attacker_clan_id or not defender_clan_id:
            return {'success': False, 'message': 'Invalid Syndicate IDs'}
        if attacker_clan_id == defender_clan_id:
            return {'success': False, 'message': 'Cannot declare war on yourself'}
        return {'success': True, 'message': '⚔️ War declared! Prepare for battle!'}
"""
with open('Core/App/WarEngine.py', 'w', encoding='utf-8') as f: f.write(war_code)
print('[OK] WarEngine.py created')

print('[STEP 3] Patching mini_api.py with War & Upgraded Upgrade endpoints...')
api_file = 'mini_api.py'
if os.path.exists(api_file):
    with open(api_file, 'r', encoding='utf-8') as f: content = f.read()
    
    if 'from Core.App.WarEngine import WarEngine' not in content:
        content = 'from Core.App.WarEngine import WarEngine\n' + content

    # آپدیت کردن روت ارتقای Nexus برای اعمال وضعیت مکس بودن
    if "'is_nexus_maxed': result['is_nexus_maxed']" not in content:
        old_update = "players_collection.update_one(\n                {'user_id': uid},\n                {'$set': {\n                    'gold': result['new_gold'],\n                    'nsm_soft': result['new_nsm_soft'],\n                    'town_hall_level': result['new_level']\n                }}\n            )"
        new_update = "players_collection.update_one(\n                {'user_id': uid},\n                {'$set': {\n                    'gold': result['new_gold'],\n                    'nsm_soft': result['new_nsm_soft'],\n                    'town_hall_level': result['new_level'],\n                    'is_nexus_maxed': result['is_nexus_maxed']\n                }}\n            )"
        content = content.replace(old_update, new_update)

    if '/api/war/declare' not in content:
        war_api = '''
@app.route('/api/war/declare', methods=['POST'])
def declare_war():
    try:
        data = request.json; uid = data.get('user_id'); defender_clan = data.get('defender_clan_id')
        if not uid or not defender_clan: return jsonify({'error': 'Missing data'}), 400
        p = players_collection.find_one({'user_id': uid})
        if not p or not p.get('clan_id'): return jsonify({'error': 'You are not in a Syndicate'}), 400
        
        result = WarEngine.declare_war(p['clan_id'], defender_clan)
        if result['success']: return jsonify(result)
        else: return jsonify(result), 400
    except Exception as e: return jsonify({'error': str(e)}), 500
'''
        if 'app.run(host=' in content: content = content.replace('app.run(host=', war_api + '\napp.run(host=', 1)

    with open(api_file, 'w', encoding='utf-8') as f: f.write(content)
    print('[OK] API Patched')

print('[STEP 4] Rebuilding Mini App UI with Wallet Unlock status...')
html = """<!DOCTYPE html><html lang="fa" dir="rtl"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Nasrium</title><script src="https://telegram.org/js/telegram-web-app.js"></script><style>:root{--bg:#0f0f1a;--card:#1a1a2e;--accent:#e94560;--gold:#ffd700;--gem:#00ffff;--nsm:#9d4edd}body{margin:0;padding:20px;background:var(--bg);color:#fff;font-family:Tahoma,sans-serif;padding-bottom:80px}.header{text-align:center;margin-bottom:20px}.header h1{margin:0;color:var(--accent);font-size:1.8em}.stats-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:20px}.stat-card{background:var(--card);padding:15px;border-radius:12px;text-align:center}.stat-card .value{font-size:1.5em;font-weight:bold;display:block;margin-top:5px}.stat-card.gold .value{color:var(--gold)}.stat-card.gem .value{color:var(--gem)}.stat-card.nsm .value{color:var(--nsm)}.section{background:var(--card);padding:15px;border-radius:12px;margin-bottom:15px}.section-title{font-size:1.2em;margin-bottom:10px;border-bottom:1px solid #333;padding-bottom:5px;color:#ccc}.btn{background:var(--accent);color:white;border:none;padding:8px 16px;border-radius:8px;cursor:pointer;font-weight:bold;width:100%;margin-top:10px}.btn:active{transform:scale(0.95)}.btn-collect{background:#ffd700;color:#000}.btn-upgrade{background:#9d4edd;width:auto;margin-top:0}.btn-raid{background:var(--accent)}.btn-shield{background:#00ffff;color:#000}.btn-train{background:#ff9800;color:#000}.btn-clan{background:#4caf50}.btn-build{background:#607d8b;color:#fff;width:auto;margin-top:0;font-size:0.85em;padding:6px 12px}.btn-daily{background:linear-gradient(45deg,#ff9800,#ff5722);color:white;font-size:1.1em}.wallet-card{background:linear-gradient(135deg,#1a1a2e 0%,#16213e 100%);border:1px solid #9d4edd;padding:15px;border-radius:12px;margin-bottom:15px}.status-badge{padding:4px 10px;border-radius:20px;font-size:0.8em;font-weight:bold}.status-active{background:#00ffff22;color:#00ffff;border:1px solid #00ffff}.status-inactive{background:#e9456022;color:#e94560;border:1px solid #e94560}.revenue-share{color:#ffd700;font-size:1.2em;font-weight:bold}.chat-input{flex:1;padding:10px;border-radius:8px;border:none;background:#1a1a2e;color:white}.naxus-container{position:fixed;bottom:0;left:0;width:100%;background:#0a0a12;border-top:2px solid var(--nsm);padding:15px;box-sizing:border-box;z-index:100;display:none}.naxus-container.active{display:block}.chat-log{height:150px;overflow-y:auto;margin-bottom:10px;padding:10px;background:#000;border-radius:8px;font-size:0.9em}.chat-input-row{display:flex;gap:10px}.btn-naxus-toggle{position:fixed;bottom:20px;right:20px;background:var(--nsm);color:white;border:none;width:60px;height:60px;border-radius:50%;font-size:1.5em;cursor:pointer;z-index:101;box-shadow:0 4px 10px rgba(0,0,0,0.5)}.toast{visibility:hidden;min-width:250px;background-color:#333;color:#fff;text-align:center;border-radius:8px;padding:16px;position:fixed;z-index:200;left:50%;bottom:100px;transform:translateX(-50%);opacity:0;transition:opacity 0.3s}.toast.show{visibility:visible;opacity:1}.building-row{display:flex;justify-content:space-between;margin-bottom:10px;align-items:center;background:#000;padding:8px;border-radius:8px}.clan-chat-box{height:100px;overflow-y:auto;background:#000;padding:8px;border-radius:8px;margin-top:10px;font-size:0.8em;border:1px solid #333}.msg{margin-bottom:5px;border-bottom:1px solid #1a1a2e;padding-bottom:2px}</style></head><body><div class="header"><h1>🌌 NASRIUM</h1><div id="clan-badge" style="color:#4caf50;font-size:0.9em"></div></div><div class="stats-grid"><div class="stat-card gold"><div>💰 Gold</div><span class="value" id="gold-val">...</span></div><div class="stat-card gem"><div>💎 Gems</div><span class="value" id="gem-val">...</span></div><div class="stat-card nsm"><div>🪙 NSM</div><span class="value" id="nsm-val">...</span></div></div><div class="wallet-card"><div style="display:flex;justify-content:space-between;align-items:center"><span>🛡️ Wallet</span><span id="wallet-badge" class="status-badge status-inactive">OFFLINE</span></div><div style="display:flex;justify-content:space-between;align-items:center;margin-top:5px"><span>Revenue Share:</span><span class="revenue-share"><span id="withdraw-pct">0</span>%</span></div><div style="margin-top:10px;font-size:0.9em">🛡️ Shield: <span id="shield-status" style="color:#00ffff">OFF</span> | ⚔️ Troops: <span id="troop-count" style="color:#ff9800">0</span></div><div style="margin-top:5px;font-size:0.9em;color:#aaa">Nexus Status: <span id="nexus-max-status" style="color:#ff9800">NOT MAXED</span></div></div><button class="btn btn-daily" onclick="claimDaily()">🎁 Claim Daily Reward</button><button class="btn btn-collect" onclick="collectResources()" style="margin-top:10px">⚡ Collect Resources</button><div class="section" style="margin-top:15px"><div class="section-title">🏗️ Buildings</div><div class="building-row"><span>⛏️ Gold Mine (Lv <span id="gm-lvl">0</span>)</span><button class="btn btn-build" onclick="upgradeBuilding('gold_mine')">Upgrade</button></div><div class="building-row"><span>💎 Gem Drill (Lv <span id="gd-lvl">0</span>)</span><button class="btn btn-build" onclick="upgradeBuilding('gem_drill')">Upgrade</button></div></div><div class="section"><div class="section-title">⚔️ Cyber Raid (PvP)</div><button class="btn btn-train" onclick="trainTroops(5)">⚔️ Train 5 Troops (2500 Gold)</button><div style="display:flex;gap:10px;margin-top:10px"><input type="number" id="target-id" class="chat-input" placeholder="Target User ID" style="flex:1;margin-top:0"><button class="btn btn-raid" style="width:auto;margin-top:0" onclick="executeRaid()">⚔️ RAID</button></div><button class="btn btn-shield" onclick="activateShield()">🛡️ Shield (10 NSM_H)</button></div><div class="section"><div class="section-title">🏛️ Nexus Core (Level <span id="th-lvl">1</span>)</div><p style="font-size:0.8em;color:#aaa">Must max buildings first to unlock Wallet!</p><button class="btn btn-upgrade" onclick="upgradeNexus()">Upgrade</button></div><div class="section" id="clan-section" style="display:none"><div class="section-title">🏴 Syndicate Chat</div><div id="clan-chat-box" class="clan-chat-box">Loading messages...</div><div class="chat-input-row" style="margin-top:10px"><input type="text" id="clan-msg-input" class="chat-input" placeholder="Message..." style="margin-top:0"><button class="btn btn-clan" style="width:auto;margin-top:0" onclick="sendClanMsg()">Send</button></div></div><button class="btn-naxus-toggle" onclick="toggleNaxus()">🤖</button><div id="naxus-container" class="naxus-container"><div class="chat-log" id="chat-log"><div style="color:var(--nsm)">NAXUS: Online.</div></div><div class="chat-input-row"><input type="text" id="chat-input" class="chat-input" placeholder="Ask NAXUS..." onkeypress="if(event.key==='Enter')askNaxus()"><button class="btn" style="width:auto;margin-top:0" onclick="askNaxus()">Send</button></div></div><div id="toast" class="toast"></div><script>const tg=window.Telegram.WebApp;tg.ready();tg.expand();const uid=parseInt(new URLSearchParams(window.location.search).get('uid'));function showToast(m){const t=document.getElementById("toast");t.innerText=m;t.className="toast show";setTimeout(()=>t.className=t.className.replace("show",""),3e3)}async function loadProfile(){if(!uid)return;try{const r=await fetch('/api/profile/'+uid);const d=await r.json();if(d.is_banned){document.body.innerHTML='<h1 style="text-align:center;color:red;margin-top:40%">🛑 BANNED</h1>';return}document.getElementById('gold-val').innerText=(d.gold||0).toLocaleString();document.getElementById('gem-val').innerText=(d.gems||0).toLocaleString();document.getElementById('nsm-val').innerText=(d.nsm_soft||0).toFixed(2);const b=document.getElementById('wallet-badge');if(d.wallet_active){b.innerText="ONLINE";b.className="status-badge status-active"}else{b.innerText="OFFLINE";b.className="status-badge status-inactive"}document.getElementById('withdraw-pct').innerText=d.withdraw_percentage||0;document.getElementById('th-lvl').innerText=d.th_level||1;document.getElementById('troop-count').innerText=d.troops||0;document.getElementById('gm-lvl').innerText=(d.buildings&&d.buildings.gold_mine)||0;document.getElementById('gd-lvl').innerText=(d.buildings&&d.buildings.gem_drill)||0;const shieldTime=d.shield_active_until||0;if(Date.now()/1e3<shieldTime){document.getElementById('shield-status').innerText="ACTIVE";document.getElementById('shield-status').style.color="#00ffff"}else{document.getElementById('shield-status').innerText="OFF";document.getElementById('shield-status').style.color="#e94560"}if(d.is_nexus_maxed){document.getElementById('nexus-max-status').innerText="MAXED!";document.getElementById('nexus-max-status').style.color="#00ffff"}else{document.getElementById('nexus-max-status').innerText="NOT MAXED";document.getElementById('nexus-max-status').style.color="#ff9800"}if(d.clan_name){document.getElementById('clan-badge').innerText="🏴 "+d.clan_name;document.getElementById('clan-section').style.display='block';loadClanChat()}}catch(e){}}async function claimDaily(){if(!uid)return;const r=await fetch('/api/missions/daily',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.success){showToast("🎁 "+d.message);loadProfile()}else showToast("❌ "+d.message)}async function upgradeBuilding(bType){if(!uid)return;const r=await fetch('/api/upgrade/building',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid,building_type:bType})});const d=await r.json();if(d.success){showToast("🏗️ "+d.message);loadProfile()}else showToast("❌ "+d.message)}async function sendClanMsg(){if(!uid)return;const msg=document.getElementById('clan-msg-input').value;if(!msg)return;await fetch('/api/clan/chat/send',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid,message:msg})});document.getElementById('clan-msg-input').value='';loadClanChat()}async function loadClanChat(){if(!uid)return;try{const r=await fetch('/api/clan/chat/get',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();const box=document.getElementById('clan-chat-box');box.innerHTML='';if(d.messages){d.messages.forEach(m=>{box.innerHTML+='<div class="msg"><b>'+m.name+'</b>: '+m.message+'</div>'});box.scrollTop=box.scrollHeight}}catch(e){}}async function executeRaid(){if(!uid)return;const targetId=parseInt(document.getElementById('target-id').value);if(!targetId){showToast("Enter Target ID");return}const r=await fetch('/api/raid/attack',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({attacker_id:uid,defender_id:targetId})});const d=await r.json();showToast(d.result+": "+d.message);loadProfile()}async function activateShield(){if(!uid)return;const r=await fetch('/api/raid/shield',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.success){showToast("🛡️ "+d.message);loadProfile()}else showToast("❌ "+d.message)}async function trainTroops(amount){if(!uid)return;const r=await fetch('/api/troops/train',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid,amount:amount})});const d=await r.json();if(d.success){showToast("⚔️ "+d.message);loadProfile()}else showToast("❌ "+d.message)}async function upgradeNexus(){if(!uid)return;const r=await fetch('/api/upgrade/nexus',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.success){showToast("✅ Upgraded! "+(d.is_nexus_maxed?"Wallet Unlocked!":""));loadProfile()}else showToast("❌ "+d.message)}async function collectResources(){if(!uid)return;const r=await fetch('/api/collect',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.earned_gold!==undefined){showToast("💰 Collected!");loadProfile()}}function toggleNaxus(){document.getElementById('naxus-container').classList.toggle('active')}async function askNaxus(){const input=document.getElementById('chat-input');const query=input.value;if(!query)return;const log=document.getElementById('chat-log');log.innerHTML+='<div style="color:#fff;margin-top:5px">You: '+query+'</div>';input.value='';try{const r=await fetch('/api/nexus/ask',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid,query:query,lang:'en'})});const d=await r.json();log.innerHTML+='<div style="color:var(--nsm);margin-top:5px;white-space:pre-line">NAXUS: '+d.response+'</div>';log.scrollTop=log.scrollHeight}catch(e){}}loadProfile()</script></body></html>"""
os.makedirs('mini_app', exist_ok=True)
with open('mini_app/index.html', 'w', encoding='utf-8') as f: f.write(html)
print('[OK] UI Rebuilt')
