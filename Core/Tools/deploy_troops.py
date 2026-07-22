import os, time

print('[STEP 1] Creating TroopEngine.py...')
troop_code = """import time

class TroopEngine:
    # هزینه و زمان آموزش هر واحد نیرو
    TROOP_COST_GOLD = 500
    TROOP_TRAINING_TIME = 5  # ثانیه (در بازی واقعی بیشتر است)

    @staticmethod
    def train_troops(amount: int, player_data: dict) -> dict:
        if amount <= 0:
            return {'success': False, 'message': 'Invalid amount'}

        total_cost = amount * TroopEngine.TROOP_COST_GOLD
        player_gold = player_data.get('gold', 0)

        if player_gold < total_cost:
            return {'success': False, 'message': f'Insufficient Gold. {total_cost} required.'}

        return {
            'success': True,
            'troops_added': amount,
            'new_gold': player_gold - total_cost,
            'message': f'⚔️ {amount} Cyber Operatives trained successfully!'
        }
"""
os.makedirs('Core/App', exist_ok=True)
with open('Core/App/TroopEngine.py', 'w', encoding='utf-8') as f: f.write(troop_code)
print('[OK] TroopEngine.py created')

print('[STEP 2] Patching mini_api.py with Train & Secure Register endpoints...')
api_file = 'mini_api.py'
if os.path.exists(api_file):
    with open(api_file, 'r', encoding='utf-8') as f: content = f.read()
    
    if 'from Core.App.TroopEngine import TroopEngine' not in content:
        content = 'from Core.App.TroopEngine import TroopEngine\n' + content

    if '/api/troops/train' not in content:
        train_api = '''
@app.route('/api/troops/train', methods=['POST'])
def train_troops():
    try:
        data = request.json; uid = data.get('user_id'); amount = data.get('amount', 0)
        if not uid: return jsonify({'error': 'Missing ID'}), 400
        p = players_collection.find_one({'user_id': uid})
        if not p: return jsonify({'error': 'Player not found'}), 404
        
        result = TroopEngine.train_troops(amount, p)
        if result['success']:
            players_collection.update_one({'user_id': uid}, {'$set': {'gold': result['new_gold']}, '$inc': {'troops': result['troops_added']}})
            return jsonify(result)
        else: return jsonify(result), 400
    except Exception as e: return jsonify({'error': str(e)}), 500
'''
        if 'app.run(host=' in content: content = content.replace('app.run(host=', train_api + '\napp.run(host=', 1)

    # آپدیت روت ثبت نام برای ایجاد فیلدهای پیشفرض جدید
    if 'default_data = {' in content:
        old_default = """default_data = {
                "user_id": uid,
                "upline_id": upline_id if upline_id else None,
                "gold": 1000, "gems": 10, "nsm_soft": 5, "nsm_hard": 0,
                "town_hall_level": 1, "is_nexus_maxed": False, "is_banned": False,
                "buildings": {"gold_mine": 1, "gem_drill": 0}
            }"""
        new_default = """default_data = {
                "user_id": uid,
                "upline_id": upline_id if upline_id else None,
                "gold": 1000, "gems": 10, "nsm_soft": 5, "nsm_hard": 0,
                "town_hall_level": 1, "is_nexus_maxed": False, "is_banned": False,
                "troops": 5, "shield_active_until": 0, "subscription_tier": "Free",
                "buildings": {"gold_mine": 1, "gem_drill": 0}
            }"""
        content = content.replace(old_default, new_default)

    with open(api_file, 'w', encoding='utf-8') as f: f.write(content)
    print('[OK] API Patched')

print('[STEP 3] Rebuilding Mini App UI with Train Troops section...')
html = """<!DOCTYPE html><html lang="fa" dir="rtl"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Nasrium</title><script src="https://telegram.org/js/telegram-web-app.js"></script><style>:root{--bg:#0f0f1a;--card:#1a1a2e;--accent:#e94560;--gold:#ffd700;--gem:#00ffff;--nsm:#9d4edd}body{margin:0;padding:20px;background:var(--bg);color:#fff;font-family:Tahoma,sans-serif;padding-bottom:80px}.header{text-align:center;margin-bottom:20px}.header h1{margin:0;color:var(--accent);font-size:1.8em}.stats-grid{display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:20px}.stat-card{background:var(--card);padding:15px;border-radius:12px;text-align:center}.stat-card .value{font-size:1.5em;font-weight:bold;display:block;margin-top:5px}.stat-card.gold .value{color:var(--gold)}.stat-card.gem .value{color:var(--gem)}.stat-card.nsm .value{color:var(--nsm)}.section{background:var(--card);padding:15px;border-radius:12px;margin-bottom:15px}.section-title{font-size:1.2em;margin-bottom:10px;border-bottom:1px solid #333;padding-bottom:5px;color:#ccc}.btn{background:var(--accent);color:white;border:none;padding:8px 16px;border-radius:8px;cursor:pointer;font-weight:bold;width:100%;margin-top:10px}.btn:active{transform:scale(0.95)}.btn-collect{background:#ffd700;color:#000}.btn-upgrade{background:#9d4edd;width:auto;margin-top:0}.btn-raid{background:var(--accent)}.btn-shield{background:#00ffff;color:#000}.btn-train{background:#ff9800;color:#000}.wallet-card{background:linear-gradient(135deg,#1a1a2e 0%,#16213e 100%);border:1px solid #9d4edd;padding:15px;border-radius:12px;margin-bottom:15px}.status-badge{padding:4px 10px;border-radius:20px;font-size:0.8em;font-weight:bold}.status-active{background:#00ffff22;color:#00ffff;border:1px solid #00ffff}.status-inactive{background:#e9456022;color:#e94560;border:1px solid #e94560}.revenue-share{color:#ffd700;font-size:1.2em;font-weight:bold}.chat-input{flex:1;padding:10px;border-radius:8px;border:none;background:#1a1a2e;color:white}.naxus-container{position:fixed;bottom:0;left:0;width:100%;background:#0a0a12;border-top:2px solid var(--nsm);padding:15px;box-sizing:border-box;z-index:100;display:none}.naxus-container.active{display:block}.chat-log{height:150px;overflow-y:auto;margin-bottom:10px;padding:10px;background:#000;border-radius:8px;font-size:0.9em}.chat-input-row{display:flex;gap:10px}.btn-naxus-toggle{position:fixed;bottom:20px;right:20px;background:var(--nsm);color:white;border:none;width:60px;height:60px;border-radius:50%;font-size:1.5em;cursor:pointer;z-index:101;box-shadow:0 4px 10px rgba(0,0,0,0.5)}.toast{visibility:hidden;min-width:250px;background-color:#333;color:#fff;text-align:center;border-radius:8px;padding:16px;position:fixed;z-index:200;left:50%;bottom:100px;transform:translateX(-50%);opacity:0;transition:opacity 0.3s}.toast.show{visibility:visible;opacity:1}</style></head><body><div class="header"><h1>🌌 NASRIUM</h1></div><div class="stats-grid"><div class="stat-card gold"><div>💰 Gold</div><span class="value" id="gold-val">...</span></div><div class="stat-card gem"><div>💎 Gems</div><span class="value" id="gem-val">...</span></div><div class="stat-card nsm"><div>🪙 NSM</div><span class="value" id="nsm-val">...</span></div></div><div class="wallet-card"><div style="display:flex;justify-content:space-between;align-items:center"><span>🛡️ Wallet</span><span id="wallet-badge" class="status-badge status-inactive">OFFLINE</span></div><div style="display:flex;justify-content:space-between;align-items:center;margin-top:5px"><span>Revenue Share:</span><span class="revenue-share"><span id="withdraw-pct">0</span>%</span></div><div style="margin-top:10px;font-size:0.9em">🛡️ Shield: <span id="shield-status" style="color:#00ffff">OFF</span> | ⚔️ Troops: <span id="troop-count" style="color:#ff9800">0</span></div></div><button class="btn btn-collect" onclick="collectResources()">⚡ Collect Resources</button><div class="section" style="margin-top:15px"><div class="section-title">⚔️ Cyber Raid (PvP)</div><p style="font-size:0.9em;color:#aaa">Train troops and raid others to loot 20% of their resources.</p><button class="btn btn-train" onclick="trainTroops(5)">⚔️ Train 5 Troops (2500 Gold)</button><div style="display:flex;gap:10px;margin-top:10px"><input type="number" id="target-id" class="chat-input" placeholder="Target User ID" style="flex:1;margin-top:0"><button class="btn btn-raid" style="width:auto;margin-top:0" onclick="executeRaid()">⚔️ RAID</button></div><button class="btn btn-shield" onclick="activateShield()">🛡️ Activate Shield (10 NSM_H)</button></div><div class="section"><div class="section-title">🏛️ Nexus Core (Level <span id="th-lvl">1</span>)</div><button class="btn btn-upgrade" onclick="upgradeNexus()">Upgrade</button></div><button class="btn-naxus-toggle" onclick="toggleNaxus()">🤖</button><div id="naxus-container" class="naxus-container"><div class="chat-log" id="chat-log"><div style="color:var(--nsm)">NAXUS: Online.</div></div><div class="chat-input-row"><input type="text" id="chat-input" class="chat-input" placeholder="Ask NAXUS..." onkeypress="if(event.key==='Enter')askNaxus()"><button class="btn" style="width:auto;margin-top:0" onclick="askNaxus()">Send</button></div></div><div id="toast" class="toast"></div><script>const tg=window.Telegram.WebApp;tg.ready();tg.expand();const uid=parseInt(new URLSearchParams(window.location.search).get('uid'));function showToast(m){const t=document.getElementById("toast");t.innerText=m;t.className="toast show";setTimeout(()=>t.className=t.className.replace("show",""),3e3)}async function loadProfile(){if(!uid)return;try{const r=await fetch('/api/profile/'+uid);const d=await r.json();if(d.is_banned){document.body.innerHTML='<h1 style="text-align:center;color:red;margin-top:40%">🛑 BANNED</h1>';return}document.getElementById('gold-val').innerText=(d.gold||0).toLocaleString();document.getElementById('gem-val').innerText=(d.gems||0).toLocaleString();document.getElementById('nsm-val').innerText=(d.nsm_soft||0).toFixed(2);const b=document.getElementById('wallet-badge');if(d.wallet_active){b.innerText="ONLINE";b.className="status-badge status-active"}else{b.innerText="OFFLINE";b.className="status-badge status-inactive"}document.getElementById('withdraw-pct').innerText=d.withdraw_percentage||0;document.getElementById('th-lvl').innerText=d.th_level||1;document.getElementById('troop-count').innerText=d.troops||0;const shieldTime=d.shield_active_until||0;if(Date.now()/1e3<shieldTime){document.getElementById('shield-status').innerText="ACTIVE";document.getElementById('shield-status').style.color="#00ffff"}else{document.getElementById('shield-status').innerText="OFF";document.getElementById('shield-status').style.color="#e94560"}}catch(e){}}async function executeRaid(){if(!uid)return;const targetId=parseInt(document.getElementById('target-id').value);if(!targetId){showToast("Enter Target ID");return}const r=await fetch('/api/raid/attack',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({attacker_id:uid,defender_id:targetId})});const d=await r.json();showToast(d.result+": "+d.message);loadProfile()}async function activateShield(){if(!uid)return;const r=await fetch('/api/raid/shield',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.success){showToast("🛡️ "+d.message);loadProfile()}else showToast("❌ "+d.message)}async function trainTroops(amount){if(!uid)return;const r=await fetch('/api/troops/train',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid,amount:amount})});const d=await r.json();if(d.success){showToast("⚔️ "+d.message);loadProfile()}else showToast("❌ "+d.message)}async function upgradeNexus(){if(!uid)return;const r=await fetch('/api/upgrade/nexus',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.success){showToast("✅ Upgraded");loadProfile()}else showToast("❌ "+d.message)}async function collectResources(){if(!uid)return;const r=await fetch('/api/collect',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid})});const d=await r.json();if(d.earned_gold!==undefined){showToast("💰 Collected!");loadProfile()}}function toggleNaxus(){document.getElementById('naxus-container').classList.toggle('active')}async function askNaxus(){const input=document.getElementById('chat-input');const query=input.value;if(!query)return;const log=document.getElementById('chat-log');log.innerHTML+='<div style="color:#fff;margin-top:5px">You: '+query+'</div>';input.value='';try{const r=await fetch('/api/nexus/ask',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({user_id:uid,query:query,lang:'en'})});const d=await r.json();log.innerHTML+='<div style="color:var(--nsm);margin-top:5px;white-space:pre-line">NAXUS: '+d.response+'</div>';log.scrollTop=log.scrollHeight}catch(e){}}loadProfile()</script></body></html>"""
os.makedirs('mini_app', exist_ok=True)
with open('mini_app/index.html', 'w', encoding='utf-8') as f: f.write(html)
print('[OK] UI Rebuilt')
