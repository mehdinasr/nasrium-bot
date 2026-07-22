import os, time

print('[STEP 1] Creating RaidEngine.py...')
raid_code = """import time
import random

class RaidEngine:
    SHIELD_DURATION_HOURS = 12
    LOOT_PERCENTAGE = 0.20

    @staticmethod
    def initiate_raid(attacker_data: dict, defender_data: dict) -> dict:
        shield_expiry = defender_data.get('shield_active_until', 0)
        if time.time() < shield_expiry:
            return {'success': False, 'result': 'Defended', 'message': 'Target Firewall (Shield) is ACTIVE. Raid blocked.'}

        attacker_troops = attacker_data.get('troops', 0)
        if attacker_troops <= 0:
            return {'success': False, 'result': 'Failed', 'message': 'No troops available to initiate raid.'}

        attacker_power = attacker_troops * random.uniform(1.5, 2.5)
        defender_power = defender_data.get('town_hall_level', 1) * 10 * random.uniform(1.0, 2.0)

        if attacker_power > defender_power:
            loot_gold = int(defender_data.get('gold', 0) * RaidEngine.LOOT_PERCENTAGE)
            loot_gems = int(defender_data.get('gems', 0) * RaidEngine.LOOT_PERCENTAGE)
            return {'success': True, 'result': 'Victory', 'loot_gold': loot_gold, 'loot_gems': loot_gems, 'troops_lost': random.randint(1, max(1, int(attacker_troops * 0.2))), 'message': f'Raid Successful! Looted {loot_gold} Gold and {loot_gems} Gems.'}
        else:
            return {'success': True, 'result': 'Defeat', 'loot_gold': 0, 'loot_gems': 0, 'troops_lost': random.randint(1, max(1, int(attacker_troops * 0.5))), 'message': 'Raid Failed. Target defenses were too strong.'}

    @staticmethod
    def activate_shield(player_data: dict) -> dict:
        cost = 10
        if player_data.get('nsm_hard', 0) < cost:
            return {'success': False, 'message': 'Insufficient NSM_Hard (10 required)'}
        expiry_time = time.time() + (RaidEngine.SHIELD_DURATION_HOURS * 3600)
        return {'success': True, 'new_nsm_hard': player_data.get('nsm_hard', 0) - cost, 'shield_expiry': expiry_time, 'message': f'🛡️ Firewall activated for {RaidEngine.SHIELD_DURATION_HOURS} hours!'}
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/RaidEngine.py', 'w', encoding='utf-8') as f: f.write(raid_code)
print('[OK] RaidEngine.py created')

print('[STEP 2] Patching mini_api.py...')
api_file = 'mini_api.py'
if os.path.exists(api_file):
    with open(api_file, 'r', encoding='utf-8') as f: content = f.read()
    if 'from Core.App.RaidEngine import RaidEngine' not in content:
        content = 'from Core.App.RaidEngine import RaidEngine\nimport time\n' + content
    if '/api/raid/attack' not in content:
        raid_api = '''
@app.route('/api/raid/attack', methods=['POST'])
def execute_raid():
    try:
        data = request.json
        attacker_uid = data.get('attacker_id'); defender_uid = data.get('defender_id')
        if not attacker_uid or not defender_uid: return jsonify({'error': 'Missing IDs'}), 400
        if attacker_uid == defender_uid: return jsonify({'error': 'Cannot raid yourself'}), 400
        attacker = players_collection.find_one({'user_id': attacker_uid})
        defender = players_collection.find_one({'user_id': defender_uid})
        if not attacker or not defender: return jsonify({'error': 'Player not found'}), 404
        result = RaidEngine.initiate_raid(attacker, defender)
        if result['success']:
            players_collection.update_one({'user_id': attacker_uid}, {'$inc': {'gold': result.get('loot_gold', 0), 'gems': result.get('loot_gems', 0), 'troops': -result.get('troops_lost', 0)}})
            if result['result'] == 'Victory':
                players_collection.update_one({'user_id': defender_uid}, {'$inc': {'gold': -result.get('loot_gold', 0), 'gems': -result.get('loot_gems', 0)}, '$set': {'shield_active_until': time.time() + (12 * 3600)}})
        return jsonify(result)
    except Exception as e: return jsonify({'error': str(e)}), 500

@app.route('/api/raid/shield', methods=['POST'])
def buy_shield():
    try:
        data = request.json; uid = data.get('user_id')
        if not uid: return jsonify({'error': 'Missing ID'}), 400
        p = players_collection.find_one({'user_id': uid})
        if not p: return jsonify({'error': 'Player not found'}), 404
        result = RaidEngine.activate_shield(p)
        if result['success']:
            players_collection.update_one({'user_id': uid}, {'$set': {'nsm_hard': result['new_nsm_hard'], 'shield_active_until': result['shield_expiry']}})
            return jsonify(result)
        else: return jsonify(result), 400
    except Exception as e: return jsonify({'error': str(e)}), 500
'''
        if 'app.run(host=' in content: content = content.replace('app.run(host=', raid_api + '\napp.run(host=', 1)
    with open(api_file, 'w', encoding='utf-8') as f: f.write(content)
    print('[OK] API Patched')

print('[STEP 3] Rebuilding Mini App UI...')
html = """<!DOCTYPE html><html lang="fa" dir="rtl"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Nasrium</title><script src="https://telegram.org/js/telegram-web-app.js"></script><style>:root{--bg:#0f0f1a;--card:#1a1a2e;--accent:#e94560;--gold:#ffd700;--gem:#00ffff;--nsm:#9d4edd}body{margin:0;padding:20px;background:var(--bg);color:#fff;font-family:Tahoma,sans-serif;padding-bottom:80px}.header{text-align:center;margin-bottom:20px}.header h1{margin:0;color:var(--accent);font-size:1.8em}.stats-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:20px}.stat-card{background:var(--card);padding:15px;border-radius:12px;text-align:center}.stat-card .value{font-size:1.5em;font-weight:bold;display:block;margin-top:5px}.stat-card.gold .value{color:var(--gold)}.stat-card.gem .value{color:var(--gem)}.stat-card.nsm .value{color:var(--nsm)}.section{background:var(--card);padding:15px;border-radius:12px;margin-bottom:15px}.section-title{font-size:1.2em;margin-bottom:10px;border-bottom:1px solid #333;padding-bottom:5px;color:#ccc}.btn{background:var(--accent);color:white;border:none;padding:8px 16px;border-radius:8px;cursor:pointer;font-weight:bold;width:100%;margin-top:10px}.btn:active{transform:scale(0.95)}.btn-collect{background:#ffd700;color:#000}.btn-upgrade{background:#9d4edd;width:auto;margin-top:0}.btn-raid{background:var(--accent)}.btn-shield{background:#00ffff;color:#000}.wallet-card{background:linear-gradient(135deg,#1a1a2e 0%,#16213e 100%);border:1px solid #9d4edd;padding:15px;border-radius:12px;margin-bottom:15px}.status-badge{padding:4px 10px;border-radius:20px;font-size:0.8em;font-weight:bold}.status-active{background:#00ffff22;color:#00ffff;border:1px solid #00ffff}.status-inactive{background:#e9456022;color:#e94560;border:1px solid #e94560}.revenue-share{color:#ffd700;font-size:1.2em;font-weight:bold}.chat-input{flex:1;padding:10px;border-radius:8px;border:none;background:#1a1a2e;color:white}.naxus-container{position:fixed;bottom:0;left:0;width:100%;background:#0a0a12;border-top:2px solid var(--nsm);padding:15px;box-sizing:border-box;z-index:100;display:none}.naxus-container.active{display:block}.chat-log{height:150px;overflow-y:auto;margin-bottom:10px;padding:10px;background:#000;border-radius:8px;font-size:0.9em}.chat-input-row{display:flex;gap:10px}.btn-naxus-toggle{position:fixed;bottom:20px;right:20px;background:var(--nsm);color:white;border:none;width:60px;height:60px;border-radius:50%;font-size:1.5em;cursor:pointer;z-index:101;box-shadow:0 4px 10px rgba(0,0,0,0.5)}.toast{visibility:hidden;min-width:250px;background-color:#333;color:#fff;text-align:center;border-radius:8px;padding:16px;position:fixed;z-index:200;left:50%;bottom:100px;transform:translateX(-50%);opacity:0;transition:opacity 0.3s}.toast.show{visibility:visible;opacity:1}</style></head><body><div class="header"><h1>🌌 NASRIUM</h1></div><div class="stats-grid"><div class="stat-card gold"><div>💰 Gold</div><span class="value" id="gold-val">...</span></div><div class="stat-card gem"><div>💎 Gems</div><span class="value" id="gem-val">...</span></div><div class="stat-card nsm"><div>🪙 NSM</div><span class="value" id="nsm-val">...</span></div></div><div class="wallet-card"><div style="display:flex;justify-content:space-between;align-items:center"><span>🛡️ Wallet</span><span id="wallet-badge" class="status-badge status-inactive">OFFLINE</span></div><div style="display:flex;justify-content:space-between;align-items:center;margin-top:5px"><span>Revenue Share:</span><span class="revenue-share"><span id="withdraw-pct">0</span>%</span></div><div style="margin-top:10px;font-size:0.9em">🛡️ Shield Status: <span id="shield-status" style="color:#00ffff">INACTIVE</span></div></div><button class="btn btn-collect" onclick="collectResources()">⚡ Collect Resources</button><div class="section" style="margin-top:15px"><div class="section-title">⚔️ Cyber Raid (PvP)</div><p style="font-size:0.9em;color:#aaa">Raid others to loot 20% of resources.</p><div style="display:flex;gap:10px"><input type="number" id="target-id" class="chat-input" placeholder="Target User ID" style="flex:1;margin-top:0"><button class="btn btn-raid" style="width:auto;margin-top:0" onclick="executeRaid()">⚔️ RAID</button></div><button class="btn btn-shield" onclick="activateShield()">🛡️ Activate Shield (10 NSM_H)</button></div><div class="section"><div class="section-title">🏛️ Nexus Core (Level <span id="th-lvl">1</span>)</div><button class="btn btn-upgrade" onclick="upgradeNexus()">Upgrade</button></div><button class="btn-naxus-toggle" onclick="toggleNaxus()">🤖</button><div id="naxus-container" class="naxus-container"><div class="chat-log" id="chat-log"><div style="color:var(--nsm)">NAXUS: Online.</div></div><div class="chat-input-row"><input type="text" id="chat-input" class="chat-input" placeholder="Ask NAXUS..." onkeypress="if(event.key==='Enter')askNaxus()"><button class="btn" style="width:auto;margin-top:0" onclick="askNaxus()">Send</button></div></div><div id="toast" class="toast"></div><script>const tg=window.Telegram.WebApp;tg.ready();tg.expand();const uid=parseInt(new URLSearchParams(window.location.search).get('uid'));function showToast(m){const t=document.getElementById("toast");t.innerText=m;t.className="toast show";setTimeout(()=>t.className=t.className.replace("show",""),3e3)}async function loadProfile(){if(!uid)return;try{const r=await fetch('/api/profile/'+uid);const d=await r.json();if(d.is_banned){document.body.innerHTML='<h1 style="text-align:center;color:red;margin-top:40%">🛑 BANNED</h1>';return}document.getElementById('gold-val').innerText=(d.gold||0).toLocaleString();document.getElementById('gem-val').innerText=(d.gems||0).toLocaleString();document.getElementById('nsm-val').innerText=(d.nsm_soft||0).toFixed(2);const b=document.getElementById('wallet-badge');if(d.wallet_active){b.innerText="ONLINE";b.className="status-badge status-active"}else{b.innerText="OFFLINE";b.className="status-badge status-inactive"}document.getElementById('withdraw-pct').innerText=d.withdraw_percentage||0;document.getElementById('th-lvl').innerText=d.th_level||1;const shieldTime=d.shield_active_until||0;if(Date.now()/1e3<shieldTime){document.getElementById('shield-status').innerText="ACTIVE";document.getElementById('shield-status').style.color="#00ffff"}else{document.getElementById('shield-status').innerText="INACTIVE";document.getElementById('shield-status').style.color="#e94560"}}catch(e){}}async function executeRaid(){if(!uid)return;const targetId=parseInt(document.getElementById('target-id').value);if(!targetId){showToast("Enter Target ID");return}const r=await fetch('/api/raid/attack',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({attacker_id:uid,defender_id:targetId})});const d=await r.json();showToast(d.result+": "+d.message);loadProfile()}async function activateShield(){if(!uid)return;const r=await fetch('/api/raid/shield',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.success){showToast("🛡️ "+d.message);loadProfile()}else showToast("❌ "+d.message)}async function upgradeNexus(){if(!uid)return;const r=await fetch('/api/upgrade/nexus',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.success){showToast("✅ Upgraded");loadProfile()}else showToast("❌ "+d.message)}async function collectResources(){if(!uid)return;const r=await fetch('/api/collect',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.earned_gold!==undefined){showToast("💰 Collected!");loadProfile()}}function toggleNaxus(){document.getElementById('naxus-container').classList.toggle('active')}async function askNaxus(){const input=document.getElementById('chat-input');const query=input.value;if(!query)return;const log=document.getElementById('chat-log');log.innerHTML+='<div style="color:#fff;margin-top:5px">You: '+query+'</div>';input.value='';try{const r=await fetch('/api/nexus/ask',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid,query:query,lang:'en'})});const d=await r.json();log.innerHTML+='<div style="color:var(--nsm);margin-top:5px;white-space:pre-line">NAXUS: '+d.response+'</div>';log.scrollTop=log.scrollHeight}catch(e){}}loadProfile()</script></body></html>"""
os.makedirs('mini_app', exist_ok=True)
with open('mini_app/index.html', 'w', encoding='utf-8') as f: f.write(html)
print('[OK] UI Rebuilt')
