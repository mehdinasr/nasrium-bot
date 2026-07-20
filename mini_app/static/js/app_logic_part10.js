setInterval(injectDeepButtons, 2000);
// --- ID_1022: Cosmic Gambling Hall ---
async function openGamblingHall() {
    const amt = prompt("Bet NSM amount (Win 1.9x):");
    if(!amt) return;
    const res = await fetch('/api/empire/gamble/bet', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, amount: parseFloat(amt) })
    });
    const data = await res.json();
    showEpicNotification(data.win ? "WINNER" : "DEFEATED", data.message, data.win ? "gold" : "red");
}

// --- ID_1023: Legion Ranks UI ---
async function showLegionRanks() {
    const res = await fetch('/api/legion/rankings');
    const data = await res.json();
    let list = data.ranks.map(r => `<div>${r.name}: ${r.power}</div>`).join('');
    showEpicNotification("LEGION POWER RANKS", list, "cyan");
}

// اضافه کردن دکمه‌ها
function injectPhase2Buttons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('gamble-btn')) {
        const gBtn = document.createElement('button');
        gBtn.id = 'gamble-btn';
        gBtn.innerHTML = '🎰 GAMBLING HALL';
        gBtn.onclick = openGamblingHall;
        gBtn.style = "margin-top:10px; width:100%; background:#300; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const rBtn = document.createElement('button');
        rBtn.id = 'rank-btn';
        rBtn.innerHTML = '📊 LEGION RANKS';
        rBtn.onclick = showLegionRanks;
        rBtn.style = "margin-top:10px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(gBtn);
        zone.appendChild(rBtn);
    }
}
setInterval(injectPhase2Buttons, 2000);
// --- ID_1026: Lunar Colony UI ---
async function openLunarMap() {
    const res = await fetch('/api/lunar/plots');
    const data = await res.json();
    let plots = data.plots.map(p => `<button onclick="alert('Annexing ${p}...')">${p}</button>`).join('');
    showEpicNotification("LUNAR COLONIZATION", `Available Plots: ${plots}`, "cyan");
}

// --- ID_1025: Legion Bonds UI ---
async function openBondMarket() {
    showEpicNotification("BOND MARKET", "Invest in Legion Growth to earn dividends.", "gold");
}

function injectPhase3Buttons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('lunar-btn')) {
        const lBtn = document.createElement('button');
        lBtn.id = 'lunar-btn';
        lBtn.innerHTML = '🌙 LUNAR COLONY';
        lBtn.onclick = openLunarMap;
        lBtn.style = "margin-top:10px; width:100%; background:#111; color:white; border:1px solid white; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const bBtn = document.createElement('button');
        bBtn.id = 'bond-btn';
        bBtn.innerHTML = '📈 BOND MARKET';
        bBtn.onclick = openBondMarket;
        bBtn.style = "margin-top:10px; width:100%; background:#001a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(lBtn);
        zone.appendChild(bBtn);
    }
}
setInterval(injectPhase3Buttons, 2000);
// --- ID_1026: Lunar Colony UI ---
async function openLunarMap() {
    const res = await fetch('/api/lunar/plots');
    const data = await res.json();
    let plots = data.plots.map(p => `<button onclick="alert('Annexing ${p}...')">${p}</button>`).join('');
    showEpicNotification("LUNAR COLONIZATION", `Available Plots: ${plots}`, "cyan");
}

// --- ID_1025: Legion Bonds UI ---
async function openBondMarket() {
    showEpicNotification("BOND MARKET", "Invest in Legion Growth to earn dividends.", "gold");
}

function injectPhase3Buttons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('lunar-btn')) {
        const lBtn = document.createElement('button');
        lBtn.id = 'lunar-btn';
        lBtn.innerHTML = '🌙 LUNAR COLONY';
        lBtn.onclick = openLunarMap;
        lBtn.style = "margin-top:10px; width:100%; background:#111; color:white; border:1px solid white; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const bBtn = document.createElement('button');
        bBtn.id = 'bond-btn';
        bBtn.innerHTML = '📈 BOND MARKET';
        bBtn.onclick = openBondMarket;
        bBtn.style = "margin-top:10px; width:100%; background:#001a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(lBtn);
        zone.appendChild(bBtn);
    }
}
setInterval(injectPhase3Buttons, 2000);
// --- ID_1022: Cosmic Gambling Hall ---
async function openGamblingHall() {
    const amt = prompt("Bet NSM amount (Win 1.9x):");
    if(!amt) return;
    const res = await fetch('/api/empire/gamble/bet', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, amount: parseFloat(amt) })
    });
    const data = await res.json();
    showEpicNotification(data.win ? "WINNER" : "DEFEATED", data.message, data.win ? "gold" : "red");
}

// --- ID_1023: Legion Ranks UI ---
async function showLegionRanks() {
    const res = await fetch('/api/legion/rankings');
    const data = await res.json();
    let list = data.ranks.map(r => `<div>${r.name}: ${r.power}</div>`).join('');
    showEpicNotification("LEGION POWER RANKS", list, "cyan");
}

// اضافه کردن دکمه‌ها
function injectPhase2Buttons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('gamble-btn')) {
        const gBtn = document.createElement('button');
        gBtn.id = 'gamble-btn';
        gBtn.innerHTML = '🎰 GAMBLING HALL';
        gBtn.onclick = openGamblingHall;
        gBtn.style = "margin-top:10px; width:100%; background:#300; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const rBtn = document.createElement('button');
        rBtn.id = 'rank-btn';
        rBtn.innerHTML = '📊 LEGION RANKS';
        rBtn.onclick = showLegionRanks;
        rBtn.style = "margin-top:10px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(gBtn);
        zone.appendChild(rBtn);
    }
}
setInterval(injectPhase2Buttons, 2000);
async function openBondMarket() {
    const res = await fetch('/api/empire/bonds/market');
    const data = await res.json();
    
    let marketHtml = '';
    for (const [name, info] of Object.entries(data.market)) {
        marketHtml += `
            <div style="border:1px solid gold; margin-bottom:10px; padding:10px; background:rgba(0,0,0,0.5);">
                <div style="color:gold; font-weight:bold;">${name}</div>
                <div style="font-size:0.7em;">Price: ${info.price} IXP | Dividend: ${info.dividend * 100}%</div>
                <div style="font-size:0.7em;">Available: ${info.available}</div>
                <button onclick="purchaseBonds('${name}')" style="margin-top:5px; background:gold; color:black; border:none; padding:5px; cursor:pointer; font-weight:bold; width:100%;">PURCHASE BONDS</button>
            </div>
        `;
    }

    const overlay = document.createElement('div');
    overlay.id = 'bond-market-ui';
    overlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:10035; padding:20px; box-sizing:border-box; color:white; font-family:monospace; text-align:center; overflow-y:auto;";
    overlay.innerHTML = `
        <h2 style="border-bottom:1px solid gold; padding-bottom:10px;">LEGION BOND MARKET</h2>
        <div style="margin-top:20px;">${marketHtml}</div>
        <button onclick="document.getElementById('bond-market-ui').remove()" style="margin-top:30px; background:none; border:1px solid #555; color:#555; cursor:pointer;">EXIT MARKET</button>
    `;
    document.body.appendChild(overlay);
}

async function purchaseBonds(legionName) {
    const count = prompt(`How many bonds of ${legionName} do you wish to acquire?`);
    if(!count) return;
    const res = await fetch('/api/empire/bonds/purchase', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, legion_name: legionName, count: parseInt(count) })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) {
        document.getElementById('bond-market-ui').remove();
        openBondMarket();
    }
}
// --- ID_1026: Lunar Colony UI ---
async function openLunarMap() {
    const res = await fetch('/api/lunar/plots');
    const data = await res.json();
    let plots = data.plots.map(p => `<button onclick="alert('Annexing ${p}...')">${p}</button>`).join('');
    showEpicNotification("LUNAR COLONIZATION", `Available Plots: ${plots}`, "cyan");
}

// --- ID_1025: Legion Bonds UI ---
async function openBondMarket() {
    showEpicNotification("BOND MARKET", "Invest in Legion Growth to earn dividends.", "gold");
}

function injectPhase3Buttons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('lunar-btn')) {
        const lBtn = document.createElement('button');
        lBtn.id = 'lunar-btn';
        lBtn.innerHTML = '🌙 LUNAR COLONY';
        lBtn.onclick = openLunarMap;
        lBtn.style = "margin-top:10px; width:100%; background:#111; color:white; border:1px solid white; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const bBtn = document.createElement('button');
        bBtn.id = 'bond-btn';
        bBtn.innerHTML = '📈 BOND MARKET';
        bBtn.onclick = openBondMarket;
        bBtn.style = "margin-top:10px; width:100%; background:#001a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(lBtn);
        zone.appendChild(bBtn);
    }
}
setInterval(injectPhase3Buttons, 2000);
async function triggerConquestEvent() {
    const conquestBtn = document.createElement('button');
    conquestBtn.id = 'conquest-event-btn';
    conquestBtn.innerHTML = 'FORCE SURRENDER';
    conquestBtn.onclick = async () => {
        const res = await fetch('/api/empire/conquest/claim', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ user_id: userId })
        });
        const data = await res.json();
        alert(data.message);
        if(typeof initGame === 'function') initGame();
    };
    conquestBtn.style = "position:fixed; top:80px; width:90%; left:5%; background:linear-gradient(to right, #000, #400); color:red; border:1px solid red; padding:10px; font-weight:bold; z-index:10040;";
    document.body.appendChild(conquestBtn);
}
setTimeout(triggerConquestEvent, 3000);
async function openGalacticMap() {
    const res = await fetch('/api/galaxy/map');
    const data = await res.json();
    let list = Object.keys(data.planets).join(', ');
    showEpicNotification("STAR-MAP ONLINE", `Targets Detected: ${list}`, "cyan");
}

function injectGalacticUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('star-map-btn')) {
        const smBtn = document.createElement('button');
        smBtn.id = 'star-map-btn';
        smBtn.innerHTML = 'STAR-MAP';
        smBtn.onclick = openGalacticMap;
        smBtn.style = "margin-top:10px; width:100%; background:#001a1a; color:#00f3ff; border:1px solid #00f3ff; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const exBtn = document.createElement('button');
        exBtn.id = 'p2p-ex-btn';
        exBtn.innerHTML = 'P2P EXCHANGE';
        exBtn.onclick = () => showEpicNotification("EXCHANGE", "Accessing NSM P2P Market...", "gold");
        exBtn.style = "margin-top:5px; width:100%; background:#1a1a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(smBtn);
        zone.appendChild(exBtn);
    }
}
setInterval(injectGalacticUI, 2000);
async function showFleetStatus() {
    const res = await fetch('/api/galaxy/fleet/dreadnoughts');
    const data = await res.json();
    let fleetHtml = Object.entries(data.fleet).map(([id, info]) => `<div>${id}: Power ${info.power}</div>`).join('');
    showEpicNotification("DREADNOUGHT FLEET", fleetHtml, "red");
}

function injectWarfareUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('fleet-btn')) {
        const fBtn = document.createElement('button');
        fBtn.id = 'fleet-btn';
        fBtn.innerHTML = 'WAR FLEET';
        fBtn.onclick = showFleetStatus;
        fBtn.style = "margin-top:10px; width:100%; background:#300; color:white; border:1px solid red; padding:10px; font-size:0.7em; cursor:pointer; font-weight:bold;";
        
        const fedBtn = document.createElement('button');
        fedBtn.id = 'fed-btn';
        fedBtn.innerHTML = 'FEDERATIONS';
        fedBtn.onclick = () => showEpicNotification("FEDERATION COUNCIL", "Accessing Universal Federation Database...", "cyan");
        fedBtn.style = "margin-top:5px; width:100%; background:#001f3f; color:#00d4ff; border:1px solid #00d4ff; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(fBtn);
        zone.appendChild(fedBtn);
    }
}
setInterval(injectWarfareUI, 2000);
async function openBountyBoard() {
    const res = await fetch('/api/guild/bounty/list');
    const data = await res.json();
    let list = data.contracts.length > 0 
        ? data.contracts.map(c => `Target: ${c.target_id} | Reward: ${c.reward_nsm} NSM`).join('<br>')
        : "No active contracts.";
    showEpicNotification("BOUNTY GUILD", list, "red");
}

function injectHighTechUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('bounty-guild-btn')) {
        const bBtn = document.createElement('button');
        bBtn.id = 'bounty-guild-btn';
        bBtn.innerHTML = 'BOUNTY GUILD';
        bBtn.onclick = openBountyBoard;
        bBtn.style = "margin-top:10px; width:100%; background:#1a0000; color:red; border:1px solid red; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const dBtn = document.createElement('button');
        dBtn.id = 'defense-gen-btn';
        dBtn.innerHTML = 'DEFENSE STATUS';
        dBtn.onclick = () => showEpicNotification("DEFENSE CORE", "Black Hole Generator: ACTIVE", "magenta");
        dBtn.style = "margin-top:5px; width:100%; background:#1a001a; color:magenta; border:1px solid magenta; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(bBtn);
        zone.appendChild(dBtn);
    }
}
setInterval(injectHighTechUI, 2000);
function injectMassiveUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('constitution-btn')) {
        const cBtn = document.createElement('button');
        cBtn.id = 'constitution-btn';
        cBtn.innerHTML = 'IMPERIAL CONSTITUTION';
        cBtn.onclick = () => showEpicNotification("CONSTITUTION", "Opening Eternal Laws...", "gold");
        cBtn.style = "margin-top:10px; width:100%; background:#000; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const iBtn = document.createElement('button');
        iBtn.id = 'index-btn';
        iBtn.innerHTML = 'NSM INDEX';
        iBtn.onclick = async () => {
            const res = await fetch('/api/economy/index');
            const data = await res.json();
            showEpicNotification("MARKET INDEX", `NSM Price: ${data.price.toFixed(4)} TON`, "cyan");
        };
        iBtn.style = "margin-top:5px; width:100%; background:#111; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(cBtn);
        zone.appendChild(iBtn);
    }
}
setInterval(injectMassiveUI, 2000);
// Integration of Phase 1040-1048 UI Components
async function showImperialStatus() {
    const res = await fetch('/api/economy/index');
    const data = await res.json();
    console.log("NSM INDEX: " + data.price);
    showEpicNotification("MARKET DATA", "NSM Index established at " + data.price.toFixed(4), "gold");
}

function injectMassiveControl() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('massive-ctrl-btn')) {
        const btn = document.createElement('button');
        btn.id = 'massive-ctrl-btn';
        btn.innerHTML = 'IMPERIAL INDEX';
        btn.onclick = showImperialStatus;
        btn.style = "margin-top:10px; width:100%; background:#000; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
    }
}
setInterval(injectMassiveControl, 2000);
// --- ID_1044: Planetary Real Estate UI ---
async function openPlanetaryMarket() {
    const res = await fetch('/api/galaxy/realestate/list');
    const data = await res.json();
    console.log("Planetary Catalog Loaded");
    showEpicNotification("PLANETARY LAND", "Centauri A1 available for 5000 NSM", "cyan");
}

function injectPlanetaryButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('planetary-btn')) {
        const btn = document.createElement('button');
        btn.id = 'planetary-btn';
        btn.innerHTML = 'PLANETARY MARKET';
        btn.onclick = openPlanetaryMarket;
        btn.style = "margin-top:10px; width:100%; background:#000; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
    }
}
setInterval(injectPlanetaryButtons, 2000);
// --- ID_1046: Financial Index UI ---
async function showNsmIndex() {
    const res = await fetch('/api/economy/index');
    const data = await res.json();
    showEpicNotification("MARKET INDEX", `NSM PRICE: ${data.price.toFixed(4)} TON`, "gold");
}

// --- ID_1048: Credit Profile UI ---
async function showCreditProfile() {
    const res = await fetch(`/api/player/credit?user_id=${userId}`);
    const data = await res.json();
    showEpicNotification("CREDIT SCORE", `Your Purity Credit: ${data.credit_score}/1000`, "cyan");
}

function injectFinanceButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('index-btn')) {
        const iBtn = document.createElement('button');
        iBtn.id = 'index-btn';
        iBtn.innerHTML = 'MARKET INDEX';
        iBtn.onclick = showNsmIndex;
        iBtn.style = "margin-top:10px; width:100%; background:#1a1a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const cBtn = document.createElement('button');
        cBtn.id = 'credit-btn';
        cBtn.innerHTML = 'CREDIT PROFILE';
        cBtn.onclick = showCreditProfile;
        cBtn.style = "margin-top:5px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(iBtn);
        zone.appendChild(cBtn);
    }
}
setInterval(injectFinanceButtons, 2000);
// --- ID_1049: DEX Connectivity UI ---
async function openDexBridge() {
    const res = await fetch(`/api/economy/listing/status?user_id=${userId}`);
    const data = await res.json();
    
    const statusColor = data.success ? "green" : "red";
    showEpicNotification("DEX CONNECTIVITY", `Status: ${data.message} (Min: ${data.min_req} NSM)`, statusColor);
}

function injectDexButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('dex-btn')) {
        const dBtn = document.createElement('button');
        dBtn.id = 'dex-btn';
        dBtn.innerHTML = 'DEX BRIDGE';
        dBtn.onclick = openDexBridge;
        dBtn.style = "margin-top:10px; width:100%; background:#000; color:#0088cc; border:1px solid #0088cc; padding:10px; font-size:0.7em; cursor:pointer; font-weight:bold;";
        zone.appendChild(dBtn);
    }
}