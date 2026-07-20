setInterval(injectDexButton, 2000);
// --- ID_1050: Final Awakening UI Logic ---
async function initiateAwakeningSequence() {
    const res = await fetch('/api/system/awakening/status');
    const data = await res.json();
    
    if(data.success) {
        console.log("SYSTEM ERA: " + data.data.era);
        document.title = "NASRIUM " + data.data.version + " | " + data.data.era;
        
        // اگر کاربر هنوز بیدار نشده، نوتیفیکیشن بیداری را نشان بده
        if(!localStorage.getItem('nasrium_awakened_v2')) {
            showEpicNotification("THE SECOND AWAKENING", "Welcome to Nasrium v1.1.0. Your core has been upgraded.", "gold");
            localStorage.setItem('nasrium_awakened_v2', 'true');
        }
    }
}
setTimeout(initiateAwakeningSequence, 1000);
// --- ID_1051: Fleet Command UI ---
async function deployFleet(planetName) {
    const res = await fetch('/api/galaxy/fleet/deploy', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, planet: planetName })
    });
    const data = await res.json();
    showEpicNotification("FLEET COMMAND", data.message, "cyan");
}

// --- ID_1053: Space Market UI ---
async function openSpaceMarket() {
    const res = await fetch('/api/galaxy/market/items');
    const data = await res.json();
    console.log("Space Market Data Loaded");
    showEpicNotification("SPACE MARKET", "Warp Cores and Dark Matter detected in sector.", "magenta");
}

function injectConquestButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('fleet-deploy-btn')) {
        const fBtn = document.createElement('button');
        fBtn.id = 'fleet-deploy-btn';
        fBtn.innerHTML = 'FLEET COMMAND';
        fBtn.onclick = () => deployFleet('CENTAURI_PRIME');
        fBtn.style = "margin-top:10px; width:100%; background:#001a1a; color:#00f3ff; border:1px solid #00f3ff; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const sBtn = document.createElement('button');
        sBtn.id = 'space-market-btn';
        sBtn.innerHTML = 'SPACE MARKET';
        sBtn.onclick = openSpaceMarket;
        sBtn.style = "margin-top:5px; width:100%; background:#1a001a; color:magenta; border:1px solid magenta; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(fBtn);
        zone.appendChild(sBtn);
    }
}
setInterval(injectConquestButtons, 2000);
// --- ID_1054: Survival HUD ---
async function updateSurvivalHUD() {
    const res = await fetch(`/api/survival/status?user_id=${userId}`);
    const data = await res.json();
    
    let oxBar = document.getElementById('oxygen-bar');
    if(!oxBar) {
        const hud = document.createElement('div');
        hud.id = 'survival-hud';
        hud.style = "position:fixed; top:120px; left:10px; font-family:monospace; font-size:0.6em; color:#0f0; z-index:1000;";
        hud.innerHTML = `OXYGEN: <span id="oxygen-val">100</span>% <div id="oxygen-bar" style="width:100px; height:5px; background:#222; border:1px solid #0f0;"><div id="oxygen-fill" style="width:100%; height:100%; background:#0f0;"></div></div>`;
        document.body.appendChild(hud);
        oxBar = document.getElementById('oxygen-fill');
    }
    document.getElementById('oxygen-val').innerText = data.oxygen;
    document.getElementById('oxygen-fill').style.width = data.oxygen + "%";
    if(data.oxygen < 20) document.getElementById('oxygen-fill').style.background = "red";
}

// --- ID_1055: High Command Console ---
function openHighCommand() {
    showEpicNotification("HIGH COMMAND", "Awaiting Federation Directives. Priority: ALPHA.", "cyan");
}

function injectStrategyButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('high-command-btn')) {
        const cBtn = document.createElement('button');
        cBtn.id = 'high-command-btn';
        cBtn.innerHTML = 'HIGH COMMAND';
        cBtn.onclick = openHighCommand;
        cBtn.style = "margin-top:10px; width:100%; background:#000; color:#00d4ff; border:1px solid #00d4ff; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(cBtn);
    }
}

setInterval(updateSurvivalHUD, 30000);
updateSurvivalHUD();
setInterval(injectStrategyButtons, 2000);
// --- ID_1057: Orbital Station Management ---
async function buildStation(planetName) {
    const res = await fetch('/api/galaxy/station/build', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ planet: planetName })
    });
    const data = await res.json();
    showEpicNotification("ORBITAL CONSTRUCTION", data.message, "cyan");
}

// --- ID_1058: Wormhole Navigation ---
async function initWormholeJump() {
    showEpicNotification("WORMHOLE TECH", "Calibrating Singularity for Instant Travel...", "magenta");
}

function injectSpaceButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('station-build-btn')) {
        const sBtn = document.createElement('button');
        sBtn.id = 'station-build-btn';
        sBtn.innerHTML = 'BUILD STATION';
        sBtn.onclick = () => buildStation('CENTAURI_PRIME');
        sBtn.style = "margin-top:10px; width:100%; background:#001a1a; color:#00f3ff; border:1px solid #00f3ff; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const wBtn = document.createElement('button');
        wBtn.id = 'wormhole-btn';
        wBtn.innerHTML = 'WORMHOLE JUMP';
        wBtn.onclick = initWormholeJump;
        wBtn.style = "margin-top:5px; width:100%; background:#1a001a; color:magenta; border:1px solid magenta; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(sBtn);
        zone.appendChild(wBtn);
    }
}
setInterval(injectSpaceButtons, 2000);
// Integration of Phase 1060-1068 UI
async function openWorldRaidV2() {
    console.log("Accessing World Boss Level 2...");
    showEpicNotification("WORLD RAID II", "Singularity Virus detected. HP: 5B", "red");
}

function injectZetaButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('raid-v2-btn')) {
        const btn = document.createElement('button');
        btn.id = 'raid-v2-btn';
        btn.innerHTML = 'WORLD RAID II';
        btn.onclick = openWorldRaidV2;
        btn.style = "margin-top:10px; width:100%; background:#400; color:white; border:1px solid red; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
    }
}
setInterval(injectZetaButtons, 2000);
// Integration of Phase 1069-1077 UI
async function checkAwakeningV3() {
    const res = await fetch('/api/system/awakening/v3');
    const data = await res.json();
    if(data.success) {
        console.log("SYSTEM UPDATE: " + data.data.era);
        if(!localStorage.getItem('nasrium_awakened_v3')) {
            showEpicNotification("THE THIRD AWAKENING", "Version 1.2.0 is LIVE. Interstellar connectivity achieved.", "gold");
            localStorage.setItem('nasrium_awakened_v3', 'true');
        }
    }
}

function injectSentinelStatus() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('sentinel-status')) {
        const div = document.createElement('div');
        div.id = 'sentinel-status';
        div.style = "margin-top:10px; font-size:0.5em; color:cyan; text-align:center; border:1px solid cyan; padding:5px;";
        div.innerText = "SOVEREIGN SENTINEL: MONITORING MARKET PURITY";
        zone.appendChild(div);
    }
}
checkAwakeningV3();
setInterval(injectSentinelStatus, 2000);
// Integration of Phase 1078-1086 UI
async function showEthicsPortal() {
    showEpicNotification("ETHICS COURT", "Accessing Purity Audit Logs...", "cyan");
}

function injectSovereignUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('ethics-btn')) {
        const btn = document.createElement('button');
        btn.id = 'ethics-btn';
        btn.innerHTML = 'ETHICS COURT';
        btn.onclick = showEthicsPortal;
        btn.style = "margin-top:10px; width:100%; background:#1a0000; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
        
        const sBtn = document.createElement('div');
        sBtn.id = 'sovereign-status';
        sBtn.style = "margin-top:5px; font-size:0.5em; color:gold; text-align:center;";
        sBtn.innerText = "SYSTEM_INTEGRITY: QUANTUM_ENCRYPTED";
        zone.appendChild(sBtn);
    }
}
setInterval(injectSovereignUI, 2000);
// Integration of Phase 1087-1095 UI
async function showGalaxyHubs() {
    showEpicNotification("GALACTIC HUBS", "Active trade routes detected in Sector 4.", "cyan");
}

function injectExpansionUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('research-btn')) {
        const btn = document.createElement('button');
        btn.id = 'research-btn';
        btn.innerHTML = 'RESEARCH LAB';
        btn.onclick = () => showEpicNotification("QUANTUM LAB", "Scientific progress: OPTIMAL", "magenta");
        btn.style = "margin-top:10px; width:100%; background:#000; color:magenta; border:1px solid magenta; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
        
        const hBtn = document.createElement('button');
        hBtn.id = 'hubs-btn';
        hBtn.innerHTML = 'GALACTIC HUBS';
        hBtn.onclick = showGalaxyHubs;
        hBtn.style = "margin-top:5px; width:100%; background:#111; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(hBtn);
    }
}
setInterval(injectExpansionUI, 2000);
// Integration of Phase 1096-1104 UI
async function checkAwakeningV4() {
    const res = await fetch('/api/system/awakening/v4');
    const data = await res.json();
    if(data.success) {
        console.log("ERA: " + data.data.era);
        if(!localStorage.getItem('nasrium_awakened_v4')) {
            showEpicNotification("THE FOURTH AWAKENING", "Version 1.3.0 is LIVE. Sovereign expansion achieved.", "gold");
            localStorage.setItem('nasrium_awakened_v4', 'true');
        }
    }
}

function injectAwakeningUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('guild-btn')) {
        const btn = document.createElement('button');
        btn.id = 'guild-btn';
        btn.innerHTML = 'GALACTIC GUILDS';
        btn.onclick = () => showEpicNotification("GUILDS", "Connecting to Interstellar Guild Networks...", "cyan");
        btn.style = "margin-top:10px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
    }
}
checkAwakeningV4();
setInterval(injectAwakeningUI, 2000);
// Integration of Phase 1105-1113 UI
async function showMarketSentiment() {
    const res = await fetch('/api/intel/market/sentiment');
    const data = await res.json();
    showEpicNotification("MARKET ORACLE", "Current Sentiment: " + data.sentiment, "cyan");
}

function injectDiplomacyUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('sentiment-btn')) {
        const btn = document.createElement('button');
        btn.id = 'sentiment-btn';
        btn.innerHTML = 'MARKET SENTIMENT';
        btn.onclick = showMarketSentiment;
        btn.style = "margin-top:10px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
    }
}
setInterval(injectDiplomacyUI, 2000);
// Integration of Phase 1114-1122 UI
async function showVeteranBadge() {
    console.log("Veteran Status Check...");
    showEpicNotification("VETERAN STATUS", "Your loyalty to the Pure Ecosystem is recognized.", "gold");
}

function injectAdvancedUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('asteroid-btn')) {
        const btn = document.createElement('button');
        btn.id = 'asteroid-btn';
        btn.innerHTML = 'ASTEROID MINING';
        btn.onclick = () => showEpicNotification("MINING", "Scanning belt for IXP-Rich asteroids...", "cyan");
        btn.style = "margin-top:10px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
        
        const vBtn = document.createElement('button');
        vBtn.id = 'vet-btn';
        vBtn.innerHTML = 'VETERAN BADGE';
        vBtn.onclick = showVeteranBadge;
        vBtn.style = "margin-top:5px; width:100%; background:#1a1a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(vBtn);
    }
}
setInterval(injectAdvancedUI, 2000);
// Integration of Phase 1123-1131 UI
async function openColonialHall() {
    showEpicNotification("COLONIAL HALL", "Accessing Planetary Governor Database...", "cyan");
}

function injectFinalColonialUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('colonial-btn')) {
        const btn = document.createElement('button');
        btn.id = 'colonial-btn';
        btn.innerHTML = 'COLONIAL HALL';
        btn.onclick = openColonialHall;
        btn.style = "margin-top:10px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
        
        const bBtn = document.createElement('button');
        bBtn.id = 'bio-lab-btn';
        bBtn.innerHTML = 'GENETIC LAB';
        bBtn.onclick = () => showEpicNotification("GENETIC LAB", "Calibrating Bio-Digital AI DNA...", "magenta");
        bBtn.style = "margin-top:5px; width:100%; background:#1a001a; color:magenta; border:1px solid magenta; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(bBtn);
    }
}
setInterval(injectFinalColonialUI, 2000);
// Integration of Phase 1132-1140 UI
async function openNasriumPay() {
    showEpicNotification("NASRIUM PAY", "Internal Sovereign Gateway: SECURE", "gold");
}

function injectSynthesisUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('nasrium-pay-btn')) {
        const btn = document.createElement('button');
        btn.id = 'nasrium-pay-btn';
        btn.innerHTML = 'NASRIUM PAY';
        btn.onclick = openNasriumPay;
        btn.style = "margin-top:10px; width:100%; background:#000; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
        
        const dBtn = document.createElement('button');
        dBtn.id = 'ion-defense-btn';
        dBtn.innerHTML = 'ION DEFENSE';
        dBtn.onclick = () => showEpicNotification("PLANETARY DEFENSE", "Ion Cannons Status: OPTIMAL", "cyan");
        dBtn.style = "margin-top:5px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(dBtn);
    }
}
setInterval(injectSynthesisUI, 2000);
// Final Pre-Awakening UI Effects
function triggerEventHorizon() {
    console.log("EVENT HORIZON ACTIVE: Preparing for Fifth Awakening...");
    const horizonStatus = document.createElement('div');
    horizonStatus.id = 'horizon-status';
    horizonStatus.style = "position:fixed; top:5px; left:50%; transform:translateX(-50%); font-size:0.4em; color:gold; letter-spacing:2px;";
    horizonStatus.innerText = "THRESHOLD_REACHED: STANDING BY FOR 1.5.0";
    document.body.appendChild(horizonStatus);
}

function injectFinalControlUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('purity-scan-btn')) {
        const btn = document.createElement('button');
        btn.id = 'purity-scan-btn';
        btn.innerHTML = 'PURITY SCAN';
        btn.onclick = () => showEpicNotification("SYSTEM AUDIT", "Zero-Error Protocol: ACTIVE", "cyan");
        btn.style = "margin-top:10px; width:100%; background:#000; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
    }
}
triggerEventHorizon();
setInterval(injectFinalControlUI, 2000);
// ID_1150: Final Awakening UI Orchestration
async function initiateFinalAwakening() {
    const res = await fetch('/api/system/awakening/v5/status');
    const data = await res.json();
    
    if(data.success) {
        console.log("UNIVERSAL ERA: " + data.data.era);
        // افکت صوتی و بصری بیداری نهایی
        if(!localStorage.getItem('nasrium_awakened_v5')) {
            showEpicNotification("THE FIFTH AWAKENING", "Universal Singularity achieved. Welcome to Nasrium 1.5.0.", "gold");
            localStorage.setItem('nasrium_awakened_v5', 'true');
            // تغییر تم بصری به تم حاکمیت مطلق
            document.body.style.boxShadow = "inset 0 0 100px rgba(255,215,0,0.2)";
        }
    }
}
setTimeout(initiateFinalAwakening, 1500);
// Integration of Phase 1151-1165 UI Components
async function showGrowthDashboard() {
    showEpicNotification("GROWTH HUB", "Viral engine is operating at maximum capacity.", "cyan");
}

function injectLaunchUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('growth-btn')) {
        const btn = document.createElement('button');
        btn.id = 'growth-btn';
        btn.innerHTML = 'GROWTH CENTER';
        btn.onclick = showGrowthDashboard;
        btn.style = "margin-top:10px; width:100%; background:#000; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
        
        const mBtn = document.createElement('button');
        mBtn.id = 'merchant-btn';
        mBtn.innerHTML = 'MERCHANT HUB';
        mBtn.onclick = () => showEpicNotification("COMMERCE", "Accessing P2P Marketplace...", "gold");
        mBtn.style = "margin-top:5px; width:100%; background:#1a1a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(mBtn);
    }
}
setInterval(injectLaunchUI, 2000);
// Integration of Phase 1166-1180 UI
async function showSecurityStatus() {
    showEpicNotification("SYSTEM INTEGRITY", "Purity monitor: 100 PERCENT SAFE. Anti-Sybil Shield active.", "cyan");
}

function injectFinalLaunchButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('security-btn')) {
        const btn = document.createElement('button');
        btn.id = 'security-btn';
        btn.innerHTML = 'INTEGRITY MONITOR';
        btn.onclick = showSecurityStatus;
        btn.style = "margin-top:10px; width:100%; background:#001a1a; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(btn);
        
        const lBtn = document.createElement('button');
        lBtn.id = 'launch-lock-btn';
        lBtn.innerHTML = 'PRE-LAUNCH STATUS';
        lBtn.onclick = () => showEpicNotification("LOCKDOWN", "Final pre-launch synchronization in progress...", "gold");
        lBtn.style = "margin-top:5px; width:100%; background:#1a1a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        zone.appendChild(lBtn);
    }
}
setInterval(injectFinalLaunchButtons, 2000);
// Integration of Phase 1181-1195 UI
async function checkLaunchCountdown() {
    const res = await fetch('/api/launch/countdown');
    const data = await res.json();
    if(data.success && data.seconds_remaining > 0) {
        console.log("TIME_TO_GENESIS: " + data.seconds_remaining);
    }
}

function injectLaunchVisuals() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('countdown-display')) {
        const div = document.createElement('div');
        div.id = 'countdown-display';
        div.style = "margin-top:10px; font-size:0.5em; color:gold; text-align:center; border:1px dashed gold; padding:5px;";
        div.innerText = "STATUS: AWAITING GRAND GENESIS";
        zone.appendChild(div);
    }
}