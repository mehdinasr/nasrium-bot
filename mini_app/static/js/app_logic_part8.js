
// --- CMD_938: Rebirth Function ---
async function initiateRebirth() {
    const confirm = window.confirm("By initiating REBIRTH, you will reset your Level and IXP to 1, but gain permanent 1.5x efficiency for the NEXT GENERATION. Proceed?");
    if(!confirm) return;

    const res = await fetch('/api/player/rebirth', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) location.reload();
}

function injectLegacyButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('rebirth-btn')) {
        const btn = document.createElement('button');
        btn.id = 'rebirth-btn';
        btn.innerHTML = '♾️ REBIRTH ALTAR';
        btn.onclick = initiateRebirth;
        btn.style = "margin-top:10px; width:100%; background:linear-gradient(to right, #400, #900); color:white; border:none; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        zone.appendChild(btn);
    }
}

initNasriumRadio();
setInterval(injectLegacyButtons, 2000);
// --- CMD_941: Tactical Orbital Map ---
async function openOrbitalMap() {
    const res = await fetch('/api/empire/orbital/status');
    const data = await res.json();
    
    const mapOverlay = document.createElement('div');
    mapOverlay.id = 'orbital-ui';
    mapOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:url('static/assets/starfield.gif') black; z-index:10018; padding:20px; box-sizing:border-box; color:white; font-family:monospace; text-align:center;";
    
    let satHtml = '';
    for (const [id, info] of Object.entries(data.satellites)) {
        satHtml += `
            <div style="border:1px solid #00f3ff; margin-bottom:20px; padding:15px; background:rgba(0,0,0,0.7);">
                <div style="color:#00f3ff; font-weight:bold;">${id}</div>
                <div style="font-size:0.6em;">Current Owner: <span style="color:gold;">${info.owner}</span></div>
                <div style="font-size:0.6em;">Mining Boost: +${info.boost*100}%</div>
                <div style="font-size:0.8em; margin:10px 0;">Min Bid: ${info.min_bid.toLocaleString()} IXP</div>
                <button onclick="bidForSatellite('${id}')" style="background:#00f3ff; color:black; border:none; padding:5px 15px; font-weight:bold; cursor:pointer;">STRIKE & CAPTURE</button>
            </div>
        `;
    }

    mapOverlay.innerHTML = `
        <h2 style="color:#00f3ff; text-shadow:0 0 10px #00f3ff;">ORBITAL TACTICAL MAP</h2>
        <div style="margin-top:30px;">${satHtml}</div>
        <button onclick="document.getElementById('orbital-ui').remove()" style="margin-top:30px; background:none; border:none; color:#555; cursor:pointer;">DESCEND TO SURFACE</button>
    `;
    document.body.appendChild(mapOverlay);
}

// --- CMD_942: Minting NSM Tokens ---
async function openMintingAltar() {
    const amt = prompt("Amount of IXP to burn for NSM Token Minting (1M IXP = 1 NSM):");
    if(!amt) return;

    const res = await fetch('/api/economy/mint', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, amount: parseInt(amt) })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) if(typeof initGame === 'function') initGame();
}

function injectGalacticButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('orbital-btn')) {
        const oBtn = document.createElement('button');
        oBtn.id = 'orbital-btn';
        oBtn.innerHTML = '🚀 ORBITAL MAP';
        oBtn.onclick = openOrbitalMap;
        oBtn.style = "margin-top:10px; width:100%; background:#001a1a; color:#00f3ff; border:1px solid #00f3ff; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        
        const mBtn = document.createElement('button');
        mBtn.id = 'mint-btn';
        mBtn.innerHTML = '💎 MINT NSM TOKENS';
        mBtn.onclick = openMintingAltar;
        mBtn.style = "margin-top:10px; width:100%; background:#000; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        
        zone.appendChild(oBtn);
        zone.appendChild(mBtn);
    }
}
setInterval(injectGalacticButtons, 2000);
// --- CMD_944: Imperial Bank UI ---
async function openImperialBank() {
    const amt = prompt("Amount of IXP to stake for 5% daily return:");
    if(!amt) return;

    const res = await fetch('/api/bank/stake', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, amount: parseInt(amt) })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) if(typeof initGame === 'function') initGame();
}

// --- CMD_946: High Court UI ---
async function openHighCourt() {
    const targetId = prompt("Enter Target Citizen ID to report:");
    const reason = prompt("Describe the violation of the Pure Ecosystem:");
    if(!targetId || !reason) return;

    const res = await fetch('/api/court/report', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, target_id: targetId, reason: reason })
    });
    const data = await res.json();
    alert(data.message);
}

function injectStabilityButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('bank-btn')) {
        const bBtn = document.createElement('button');
        bBtn.id = 'bank-btn';
        bBtn.innerHTML = '🏦 IMPERIAL BANK';
        bBtn.onclick = openImperialBank;
        bBtn.style = "margin-top:10px; width:100%; background:#1a3300; color:#00ff00; border:1px solid #00ff00; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        
        const cBtn = document.createElement('button');
        cBtn.id = 'court-btn';
        cBtn.innerHTML = '⚖️ HIGH COURT';
        cBtn.onclick = openHighCourt;
        cBtn.style = "margin-top:10px; width:100%; background:#330000; color:#ff4444; border:1px solid #ff4444; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        
        zone.appendChild(bBtn);
        zone.appendChild(cBtn);
    }
}
setInterval(injectStabilityButtons, 2000);
// --- CMD_947: Quantum Energy Visuals ---
async function updateEnergyUI() {
    const res = await fetch(`/api/player/energy?user_id=${userId}`);
    const data = await res.json();
    
    let energyBar = document.getElementById('energy-bar-fill');
    if(!energyBar) {
        const container = document.createElement('div');
        container.id = 'energy-container';
        container.style = "position:fixed; bottom:70px; left:50%; transform:translateX(-50%); width:200px; height:15px; background:#222; border:1px solid #e056fd; border-radius:10px; overflow:hidden; z-index:1000;";
        container.innerHTML = `<div id="energy-bar-fill" style="width:0%; height:100%; background:linear-gradient(90deg, #e056fd, #9b59b6); transition: width 0.5s;"></div>
                               <span id="energy-text" style="position:absolute; width:100%; text-align:center; font-size:10px; color:white; top:0;">0/100</span>`;
        document.body.appendChild(container);
        energyBar = document.getElementById('energy-bar-fill');
    }
    
    energyBar.style.width = `${data.energy}%`;
    document.getElementById('energy-text').innerText = `${data.energy}/100`;
}

// --- CMD_949: AI Personality Display ---
async function showAIEvolution() {
    const res = await fetch(`/api/ai/evolution?user_id=${userId}`);
    const data = await res.json();
    showEpicNotification("AI STATUS: " + data.personality, "Your assistant has evolved based on your actions.", "magenta");
}

setInterval(updateEnergyUI, 30000);
updateEnergyUI();
// --- CMD_951: Big Bang Ticker ---
async function startBigBangTicker() {
    const res = await fetch('/api/empire/event/bigbang');
    const data = await res.json();
    const event = data.event;

    if(event.is_active) {
        let ticker = document.getElementById('big-bang-ticker');
        if(!ticker) {
            ticker = document.createElement('div');
            ticker.id = 'big-bang-ticker';
            ticker.style = "position:fixed; top:30px; right:10px; background:red; color:white; padding:5px 10px; font-size:10px; font-weight:bold; z-index:200003; border-radius:5px; animation: pulse 1s infinite;";
            document.body.appendChild(ticker);
        }
        ticker.innerHTML = `⚠️ BIG BANG IN: ${Math.floor(event.seconds_left / 3600)}h ${Math.floor((event.seconds_left % 3600) / 60)}m`;
    }
}

// --- CMD_952: Virtual Command Post (Cockpit) ---
async function openCommandPost() {
    const res = await fetch(`/api/player/cockpit?user_id=${userId}`);
    const data = await res.json();
    const v = data.view;

    const cockpitOverlay = document.createElement('div');
    cockpitOverlay.id = 'cockpit-ui';
    cockpitOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.9); z-index:10019; padding:20px; box-sizing:border-box; color:#00ff00; font-family:monospace; border: 2px solid #333;";
    
    cockpitOverlay.innerHTML = `
        <div style="border-bottom:1px solid #00ff00; padding-bottom:10px; margin-bottom:20px; display:flex; justify-content:space-between;">
            <span>VIRTUAL COMMAND POST v1.0</span>
            <span style="color:red;">SYNC: ${v.ai_sync}</span>
        </div>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
            <div style="background:#111; padding:15px; border-radius:5px;">SYSTEM INTEGRITY: ${v.integrity}</div>
            <div style="background:#111; padding:15px; border-radius:5px;">SHIELD: ${v.shield_level}%</div>
            <div style="background:#111; padding:15px; border-radius:5px;">STATUS: ${v.system_status}</div>
            <div style="background:#111; padding:15px; border-radius:5px;">HEIR STATUS: NOMINATED</div>
        </div>
        <button onclick="document.getElementById('cockpit-ui').remove()" style="width:100%; margin-top:40px; padding:15px; background:#00ff00; color:black; border:none; font-weight:bold; cursor:pointer;">EXIT COCKPIT</button>
    `;
    document.body.appendChild(cockpitOverlay);
}

function injectLegacyButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('cockpit-btn')) {
        const cBtn = document.createElement('button');
        cBtn.id = 'cockpit-btn';
        cBtn.innerHTML = '🎛️ COMMAND POST';
        cBtn.onclick = openCommandPost;
        cBtn.style = "margin-top:10px; width:100%; background:#111; color:#00ff00; border:1px solid #00ff00; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(cBtn);
    }
}

setInterval(startBigBangTicker, 60000);
startBigBangTicker();
setInterval(injectLegacyButtons, 2000);
// --- CMD_956: World Boss Raid UI ---
async function openWorldRaid() {
    const res = await fetch('/api/empire/boss/status');
    const data = await res.json();
    const boss = data.boss;

    const raidOverlay = document.createElement('div');
    raidOverlay.id = 'raid-ui';
    raidOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(20,0,0,0.9); z-index:10020; padding:20px; box-sizing:border-box; color:white; font-family:monospace; text-align:center;";
    
    raidOverlay.innerHTML = `
        <h1 style="color:red; text-shadow:0 0 20px red; font-size:2em;">🚨 GLOBAL THREAT DETECTED</h1>
        <div style="margin:20px 0; border:2px solid red; padding:20px; background:black;">
            <h2 style="color:red;">${boss.name}</h2>
            <div style="width:100%; height:30px; background:#333; border:1px solid red; margin:10px 0; position:relative;">
                <div id="boss-hp-bar" style="width:${(boss.hp / 1000000000) * 100}%; height:100%; background:red; box-shadow:0 0 10px red;"></div>
                <span style="position:absolute; width:100%; left:0; top:5px; font-size:0.8em;">HP: ${boss.hp.toLocaleString()}</span>
            </div>
            <button onclick="attackWorldBoss()" style="width:100%; padding:20px; background:red; color:white; font-weight:bold; border:none; cursor:pointer; font-size:1.2em;">ALL SECTORS: FIRE!</button>
        </div>
        <p style="font-size:0.7em; color:#aaa;">REWARD POOL: ${boss.reward_pool.toLocaleString()} IXP</p>
        <button onclick="document.getElementById('raid-ui').remove()" style="margin-top:40px; background:none; border:none; color:#555; cursor:pointer;">RETREAT</button>
    `;
    document.body.appendChild(raidOverlay);
}

async function attackWorldBoss() {
    const res = await fetch('/api/empire/boss/attack', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.defeated) document.getElementById('raid-ui').remove();
    else openWorldRaid(); // Refresh status
}

function injectDomButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('raid-btn')) {
        const rBtn = document.createElement('button');
        rBtn.id = 'raid-btn';
        rBtn.innerHTML = '⚔️ WORLD RAID';
        rBtn.onclick = openWorldRaid;
        rBtn.style = "margin-top:10px; width:100%; background:#600; color:white; border:1px solid red; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        zone.appendChild(rBtn);
    }
}
setInterval(injectDomButtons, 2000);
// --- CMD_958: Oracle Vision Console ---
async function openOracleTerminal() {
    const res = await fetch('/api/empire/oracle/vision');
    const data = await res.json();
    
    const oracleOverlay = document.createElement('div');
    oracleOverlay.id = 'oracle-ui';
    oracleOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,10,0.95); z-index:10021; padding:20px; box-sizing:border-box; color:#00d4ff; font-family:monospace; text-align:center; display:flex; flex-direction:column; justify-content:center;";
    
    oracleOverlay.innerHTML = `
        <h1 style="text-shadow:0 0 15px #00d4ff;">THE ORACLE TERMINAL</h1>
        <div style="border:1px solid #00d4ff; padding:30px; background:rgba(0,212,255,0.05);">
            <p style="font-size:0.8em; color:#aaa;">DECRYPTING FUTURE DATA...</p>
            <h2 id="vision-text" style="color:#fff;">"${data.vision}"</h2>
        </div>
        <button onclick="document.getElementById('oracle-ui').remove()" style="margin-top:40px; background:none; border:none; color:#555; cursor:pointer;">DISCONNECT</button>
    `;
    document.body.appendChild(oracleOverlay);
}

// --- CMD_957: Hall of Souls (SBTs) ---
async function openHallOfSouls() {
    const res = await fetch(`/api/player/sbt?user_id=${userId}`);
    const data = await res.json();
    
    const sbtOverlay = document.createElement('div');
    sbtOverlay.id = 'sbt-ui';
    sbtOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:black; z-index:10022; padding:20px; box-sizing:border-box; color:gold; font-family:serif; text-align:center;";
    
    const tokens = data.tokens.map(t => `<div style="border:1px solid gold; padding:10px; margin:5px; display:inline-block; font-size:0.7em;">✨ ${t}</div>`).join('');

    sbtOverlay.innerHTML = `
        <h1>THE HALL OF SOULS</h1>
        <p style="color:#aaa; font-size:0.8em;">Your Eternal Accomplishments</p>
        <div style="margin-top:30px;">${tokens || 'Your soul is still unwritten.'}</div>
        <button onclick="document.getElementById('sbt-ui').remove()" style="margin-top:40px; background:gold; color:black; border:none; padding:10px 20px; font-weight:bold; cursor:pointer;">BACK</button>
    `;
    document.body.appendChild(sbtOverlay);
}

function injectSovereignButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('oracle-btn')) {
        const oBtn = document.createElement('button');
        oBtn.id = 'oracle-btn';
        oBtn.innerHTML = '🔮 THE ORACLE';
        oBtn.onclick = openOracleTerminal;
        oBtn.style = "margin-top:10px; width:100%; background:#000; color:#00d4ff; border:1px solid #00d4ff; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        
        const sBtn = document.createElement('button');
        sBtn.id = 'sbt-btn';
        sBtn.innerHTML = '✨ HALL OF SOULS';
        sBtn.onclick = openHallOfSouls;
        sBtn.style = "margin-top:10px; width:100%; background:#111; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        
        zone.appendChild(oBtn);
        zone.appendChild(sBtn);
    }
}
setInterval(injectSovereignButtons, 2000);
// --- CMD_960: Council Registration ---
async function registerForCouncil() {
    const res = await fetch('/api/empire/council/register', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
}

// --- CMD_962: Zenith Market UI ---
async function openZenithMarket() {
    const res = await fetch('/api/empire/market/zenith');
    const data = await res.json();
    
    const zenithOverlay = document.createElement('div');
    zenithOverlay.id = 'zenith-ui';
    zenithOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:radial-gradient(circle, #1a1a1a 0%, #000 100%); z-index:10023; padding:20px; box-sizing:border-box; color:gold; font-family:serif; text-align:center; border: 2px solid gold;";
    
    let itemsHtml = '';
    for (const [id, item] of Object.entries(data.items)) {
        itemsHtml += `
            <div style="border:1px solid gold; margin-bottom:15px; padding:15px; background:rgba(255,215,0,0.05);">
                <div style="font-size:1.2em; font-weight:bold;">${item.name}</div>
                <div style="font-size:0.7em; color:#aaa;">${item.desc}</div>
                <div style="margin-top:10px; color:gold;">${item.price.toLocaleString()} IXP</div>
                <button onclick="buyZenith('${id}')" style="margin-top:10px; background:gold; color:black; border:none; padding:5px 15px; font-weight:bold; cursor:pointer;">ACQUIRE CODE</button>
            </div>
        `;
    }

    zenithOverlay.innerHTML = `
        <h1 style="text-shadow: 0 0 20px gold;">THE ZENITH MARKET</h1>
        <p style="font-size:0.8em; color:#aaa;">Hyper-Rare System Access Codes</p>
        <div style="margin-top:30px;">${itemsHtml}</div>
        <button onclick="document.getElementById('zenith-ui').remove()" style="margin-top:30px; background:none; border:none; color:#555; cursor:pointer;">EXIT ZENITH</button>
    `;
    document.body.appendChild(zenithOverlay);
}

function injectPowerButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('zenith-btn')) {
        const zBtn = document.createElement('button');
        zBtn.id = 'zenith-btn';
        zBtn.innerHTML = '👑 ZENITH MARKET';
        zBtn.onclick = openZenithMarket;
        zBtn.style = "margin-top:10px; width:100%; background:linear-gradient(to right, #000, #444); color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        
        const cBtn = document.createElement('button');
        cBtn.id = 'council-btn';
        cBtn.innerHTML = '🗳️ COUNCIL REGISTER';
        cBtn.onclick = registerForCouncil;
        cBtn.style = "margin-top:10px; width:100%; background:#111; color:#fff; border:1px solid #fff; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        
        zone.appendChild(zBtn);
        zone.appendChild(cBtn);
    }
}