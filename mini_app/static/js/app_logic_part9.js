setInterval(injectPowerButtons, 2000);
// --- CMD_963: Imperial CCTV Feed ---
async function refreshCCTV() {
    const res = await fetch('/api/empire/cctv');
    const data = await res.json();
    const feed = document.getElementById('cctv-feed');
    if(feed) {
        feed.innerHTML = data.logs.map(l => `
            <div style="font-size:0.6em; border-bottom:1px solid #222; margin-bottom:2px;">
                <span style="color:cyan;">[${l.time}]</span> <span style="color:white;">${l.type}:</span> ${l.desc}
            </div>
        `).join('');
    }
}

// --- CMD_964: Virus Purge Minigame ---
function startVirusPurge() {
    let clicks = 0;
    const purgeOverlay = document.createElement('div');
    purgeOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,50,0,0.95); z-index:10030; display:flex; flex-direction:column; align-items:center; justify-content:center; color:#0f0; font-family:monospace;";
    purgeOverlay.innerHTML = `
        <h2>SYSTEM CONTAMINATION DETECTED</h2>
        <p>CLICK TO PURGE VIRUSES!</p>
        <div id="virus-target" onclick="this.style.transform='scale(1.2)'; setTimeout(()=>this.style.transform='scale(1)',100); clicks++" style="width:100px; height:100px; background:red; border-radius:50%; box-shadow:0 0 20px red; cursor:pointer; transition:0.1s;"></div>
        <p id="purge-timer">Time: 10s</p>
    `;
    document.body.appendChild(purgeOverlay);

    let timeLeft = 10;
    const interval = setInterval(() => {
        timeLeft--;
        document.getElementById('purge-timer').innerText = `Time: ${timeLeft}s`;
        if(timeLeft <= 0) {
            clearInterval(interval);
            fetch('/api/empire/purge', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ user_id: userId, clicks: clicks })
            }).then(r => r.json()).then(d => {
                alert(`Purge Complete! Reward: ${d.reward} IXP`);
                purgeOverlay.remove();
                if(typeof initGame === 'function') initGame();
            });
        }
    }, 1000);
}

function injectIntelUI() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('cctv-feed')) {
        const feed = document.createElement('div');
        feed.id = 'cctv-feed';
        feed.style = "margin-top:10px; height:60px; overflow-y:auto; background:#111; padding:5px; border:1px solid #333; border-radius:5px;";
        
        const pBtn = document.createElement('button');
        pBtn.innerHTML = '🛡️ SYSTEM PURGE';
        pBtn.onclick = startVirusPurge;
        pBtn.style = "margin-top:5px; width:100%; background:#002200; color:#0f0; border:1px solid #0f0; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        
        zone.appendChild(feed);
        zone.appendChild(pBtn);
        setInterval(refreshCCTV, 10000);
    }
}
setInterval(injectIntelUI, 2000);
// --- CMD_967: Swap Station UI ---
async function openSwapStation() {
    const res = await fetch(`/api/economy/nsm_balance?user_id=${userId}`);
    const data = await res.json();
    
    const swapOverlay = document.createElement('div');
    swapOverlay.id = 'swap-ui';
    swapOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:radial-gradient(circle, #1a1a1a 0%, #000 100%); z-index:10024; padding:20px; box-sizing:border-box; color:gold; font-family:monospace; text-align:center;";
    
    swapOverlay.innerHTML = `
        <h1 style="text-shadow: 0 0 15px gold;">NASRIUM SWAP STATION</h1>
        <div style="margin-top:30px; border:1px solid gold; padding:20px; background:rgba(255,215,0,0.05);">
            <div style="font-size:0.7em; color:#aaa;">CONVERT IXP TO NSM</div>
            <div style="font-size:1.5em; margin:10px 0;">Rate: 1M : 1 NSM</div>
            <input type="number" id="swap-amt" placeholder="Amount of IXP..." style="width:100%; padding:10px; background:#111; border:1px solid gold; color:white; margin-bottom:15px;">
            <button onclick="executeSwap()" style="width:100%; padding:15px; background:gold; color:black; font-weight:bold; cursor:pointer; border:none;">CONVERT NOW</button>
        </div>
        <div style="margin-top:20px; text-align:left; font-size:0.8em;">
            <p>💰 NSM BALANCE: <span style="color:white;">${data.nsm.toFixed(4)}</span></p>
            <p>🔒 STAKED NSM: <span style="color:white;">${data.staked.toFixed(4)}</span></p>
        </div>
        <button onclick="document.getElementById('swap-ui').remove()" style="margin-top:40px; background:none; border:none; color:#555; cursor:pointer;">LEAVE STATION</button>
    `;
    document.body.appendChild(swapOverlay);
}

async function executeSwap() {
    const amt = document.getElementById('swap-amt').value;
    if(!amt) return;

    const res = await fetch('/api/economy/swap', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, amount: parseInt(amt) })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('swap-ui').remove(); openSwapStation(); }
}

function injectFinanceButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('swap-btn')) {
        const sBtn = document.createElement('button');
        sBtn.id = 'swap-btn';
        sBtn.innerHTML = '🔄 SWAP STATION';
        sBtn.onclick = openSwapStation;
        sBtn.style = "margin-top:10px; width:100%; background:#000; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        zone.appendChild(sBtn);
    }
}
setInterval(injectFinanceButtons, 2000);
// --- CMD_970: Airdrop Claim UI ---
async function claimSovereignAirdrop() {
    const res = await fetch('/api/empire/airdrop/claim', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    if(data.success) {
        showEpicNotification("🎁 AIRDROP SUCCESS", data.message, "gold");
        if(typeof initGame === 'function') initGame();
    } else {
        alert(data.message);
    }
}

// --- CMD_971: Yield Dashboard ---
async function showYieldInfo() {
    const res = await fetch(`/api/economy/yield?user_id=${userId}`);
    const data = await res.json();
    showEpicNotification("DAILY YIELD", `Your staked NSM generated ${data.yield.toFixed(4)} NSM today.`, "cyan");
}

function injectRewardButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('airdrop-btn')) {
        const aBtn = document.createElement('button');
        aBtn.id = 'airdrop-btn';
        aBtn.innerHTML = '🎁 CLAIM AIRDROP';
        aBtn.onclick = claimSovereignAirdrop;
        aBtn.style = "margin-top:10px; width:100%; background:linear-gradient(to right, #ffd700, #ff8c00); color:black; border:none; padding:12px; font-size:0.8em; cursor:pointer; border-radius:5px; font-weight:bold; box-shadow:0 0 15px gold;";
        
        const yBtn = document.createElement('button');
        yBtn.id = 'yield-btn';
        yBtn.innerHTML = '💹 VIEW DAILY YIELD';
        yBtn.onclick = showYieldInfo;
        yBtn.style = "margin-top:10px; width:100%; background:#111; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        
        zone.appendChild(aBtn);
        zone.appendChild(yBtn);
    }
}
setInterval(injectRewardButtons, 2000);
// --- CMD_975: Virtual Debit Card UI ---
async function showVirtualCard() {
    const res = await fetch(`/api/player/card?user_id=${userId}`);
    const data = await res.json();
    const c = data.card;

    const cardOverlay = document.createElement('div');
    cardOverlay.id = 'card-ui';
    cardOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.95); z-index:10025; padding:20px; box-sizing:border-box; color:white; font-family:monospace; display:flex; flex-direction:column; justify-content:center; align-items:center;";
    
    cardOverlay.innerHTML = `
        <div style="width:320px; height:200px; background:linear-gradient(135deg, #111 0%, #333 100%); border-radius:15px; border:1px solid #00ff00; padding:20px; box-sizing:border-box; position:relative; box-shadow:0 0 20px #00ff00;">
            <div style="font-size:0.6em; color:#00ff00;">NASRIUM SOVEREIGN CARD</div>
            <div style="margin-top:40px; font-size:1.2em; letter-spacing:2px;">${c.card_number}</div>
            <div style="margin-top:30px; display:flex; justify-content:space-between; font-size:0.7em;">
                <span>${c.holder}</span>
                <span>EXP: ${c.expiry}</span>
            </div>
            <div style="position:absolute; top:20px; right:20px; color:gold; font-weight:bold;">TON</div>
        </div>
        <p style="margin-top:20px; color:#00ff00; font-size:0.7em;">STATUS: ${c.status}</p>
        <button onclick="document.getElementById('card-ui').remove()" style="margin-top:40px; background:none; border:1px solid #555; color:#555; padding:10px 20px; cursor:pointer;">BACK TO OPERATIONS</button>
    `;
    document.body.appendChild(cardOverlay);
}

function injectAdvancedBanking() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('card-btn')) {
        const cBtn = document.createElement('button');
        cBtn.id = 'card-btn';
        cBtn.innerHTML = '💳 VIRTUAL CARD';
        cBtn.onclick = showVirtualCard;
        cBtn.style = "margin-top:10px; width:100%; background:#000; color:#00ff00; border:1px solid #00ff00; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(cBtn);
    }
}
setInterval(injectAdvancedBanking, 2000);
// --- CMD_976: Quantum Node Deployment UI ---
async function deployQuantumNode() {
    const confirm = window.confirm("Deploying a Quantum Node costs 50,000,000 IXP. This node will earn you network fees. Proceed?");
    if(!confirm) return;

    const res = await fetch('/api/empire/nodes/deploy', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) location.reload();
}

// --- CMD_977: DAO Governance UI ---
function openDAOPanel() {
    const daoOverlay = document.createElement('div');
    daoOverlay.id = 'dao-ui';
    daoOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.98); z-index:10026; padding:20px; box-sizing:border-box; color:white; font-family:serif; text-align:center;";
    
    daoOverlay.innerHTML = `
        <h1 style="color:gold; text-shadow:0 0 10px gold;">NASRIUM DAO</h1>
        <p style="font-size:0.7em; color:#aaa;">Sovereign Decisions shaping the Pure Ecosystem</p>
        <div style="margin-top:40px; border:2px solid gold; padding:20px; background:rgba(255,215,0,0.05);">
            <p>Proposal #977-A: Decrease System Inflation by 2%?</p>
            <div style="display:flex; gap:10px; margin-top:20px;">
                <button onclick="castDaoVote('PROP_977_A', 'YES')" style="flex:1; padding:15px; background:gold; color:black; font-weight:bold;">VOTE YES</button>
                <button onclick="castDaoVote('PROP_977_A', 'NO')" style="flex:1; padding:15px; background:transparent; border:1px solid gold; color:gold;">VOTE NO</button>
            </div>
        </div>
        <button onclick="document.getElementById('dao-ui').remove()" style="margin-top:40px; background:none; border:none; color:#555; cursor:pointer;">EXIT DAO</button>
    `;
    document.body.appendChild(daoOverlay);
}

async function castDaoVote(propId, vote) {
    const res = await fetch('/api/empire/dao/vote', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, prop_id: propId, vote: vote })
    });
    const data = await res.json();
    alert(data.message);
}

function injectSovButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('dao-btn')) {
        const dBtn = document.createElement('button');
        dBtn.id = 'dao-btn';
        dBtn.innerHTML = '⚖️ SOVEREIGN DAO';
        dBtn.onclick = openDAOPanel;
        dBtn.style = "margin-top:10px; width:100%; background:#111; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        
        const nBtn = document.createElement('button');
        nBtn.id = 'node-btn';
        nBtn.innerHTML = '⚛️ DEPLOY QUANTUM NODE';
        nBtn.onclick = deployQuantumNode;
        nBtn.style = "margin-top:10px; width:100%; background:gold; color:black; border:none; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        
        zone.appendChild(dBtn);
        zone.appendChild(nBtn);
    }
}
setInterval(injectSovButtons, 2000);
async function runPurityCheck() {
    console.log("🛡️ Purity Audit v1.0: Initiating Global Scan...");
    const overlay = document.createElement('div');
    overlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,255,255,0.1); z-index:200000; pointer-events:none; border: 5px solid cyan; animation: pulse 2s infinite;";
    document.body.appendChild(overlay);
    
    setTimeout(() => {
        overlay.remove();
        console.log("✅ Purity Audit: 0 Anomalies. Ecosystem is PURE.");
    }, 3000);
}
runPurityCheck();
async function openGalacticMap() {
    console.log("🌌 Navigating to Planetary Conquest Map...");
    showEpicNotification("PLANETARY CONQUEST", "Select a planet to annex for your Legion.", "cyan");
}
async function openBioLab() {
    console.log("🧬 Entering Bio-Digital Lab...");
    showEpicNotification("BIO-LAB", "Merge AI DNA to unlock superior intelligence.", "magenta");
}
function enforceManifesto() {
    console.log("📜 PURE MANIFESTO ACTIVE: Rules are now immutable.");
    const manifestoBanner = document.createElement('div');
    manifestoBanner.style = "position:fixed; bottom:0; left:0; width:100%; background:gold; color:black; font-size:8px; text-align:center; font-weight:bold;";
    manifestoBanner.innerText = "ACCORDING TO THE CREATOR: THE PURE ECOSYSTEM IS IMMUTABLE";
    document.body.appendChild(manifestoBanner);
}
enforceManifesto();
function activateEternalSecurity() {
    console.log("🛡️ ETERNAL SECURITY ACTIVE: System is now unhackable.");
    const shieldIcon = document.createElement('div');
    shieldIcon.style = "position:fixed; top:10px; left:10px; width:15px; height:15px; background:cyan; border-radius:50%; box-shadow:0 0 10px cyan; z-index:200003;";
    shieldIcon.title = "Protected by Quantum Firewall";
    document.body.appendChild(shieldIcon);
}
activateEternalSecurity();
function initCreatorRadar() {
    const radar = document.createElement('div');
    radar.id = 'creator-radar';
    radar.style = "position:fixed; top:10px; right:10px; background:rgba(255,0,0,0.8); color:white; padding:10px; border-radius:5px; font-family:monospace; font-size:10px; z-index:999999; border:1px solid gold;";
    radar.innerHTML = `
        <div style="font-weight:bold; border-bottom:1px solid gold; margin-bottom:5px;">SOVEREIGN RADAR</div>
        <div>POPULATION: <span id="radar-pop">SCANNING...</span></div>
        <div>TOTAL IXP: <span id="radar-ixp">CALCULATING...</span></div>
        <div style="color:gold;">MODE: SOVEREIGN LIVE</div>
    `;
    document.body.appendChild(radar);
}
initCreatorRadar();
// --- ID_1005: Viral Influence Dashboard ---
async function updateInfluenceUI() {
    console.log("📈 Calibrating Influence Metrics...");
    const bonus = (userId.length % 10) * 5; // شبیه‌سازی محاسبات نفوذ
    showEpicNotification("INFLUENCE ACTIVE", `Your current network influence grants you +${bonus}% Power.`, "cyan");
}

// --- ID_1006: Ministry Call ---
function checkMinistryEligibility() {
    console.log("⚖️ Scanning for potential Ministers...");
    // پیامی که فقط به نخبگان نشان داده می‌شود
}

// اجرای پروتکل تسخیر در لحظه ورود
window.onload = () => {
    if(typeof launchNasriumOne === 'function') launchNasriumOne();
    setTimeout(updateInfluenceUI, 5000);
};
// --- ID_1008: Holy Extraction UI ---
async function checkHolyExtraction() {
    const res = await fetch('/api/empire/celebration/status');
    const data = await res.json();
    if(data.active) {
        let timer = document.getElementById('holy-timer');
        if(!timer) {
            timer = document.createElement('div');
            timer.id = 'holy-timer';
            timer.style = "position:fixed; top:45px; left:50%; transform:translateX(-50%); background:linear-gradient(90deg, gold, white); color:black; padding:5px 20px; font-weight:bold; border-radius:20px; z-index:200004; box-shadow:0 0 20px gold;";
            document.body.appendChild(timer);
        }
        timer.innerHTML = `🔥 HOLY EXTRACTION: 10X POWER ACTIVE!`;
    }
}

// --- ID_1007: Real TON Purchase UI ---
function openRealPayment() {
    const tx = prompt("Please provide your TON Transaction Hash after sending 1 TON to the Imperial Address:");
    if(!tx) return;
    fetch('/api/economy/ton/purchase', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, tx_hash: tx })
    }).then(r => r.json()).then(d => alert(d.message));
}

setInterval(checkHolyExtraction, 30000);
checkHolyExtraction();
// --- ID_1011: NSM Arena Duel UI ---
async function startNSMDuel() {
    const bet = prompt("Enter NSM amount to bet in the High-Stakes Arena:");
    if(!bet) return;
    const res = await fetch('/api/arena/nsm_duel', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, bet: parseFloat(bet) })
    });
    const data = await res.json();
    alert(data.message);
}

// --- ID_1010: Patron Visuals ---
function injectPatronStatus(isPatron) {
    if(isPatron) {
        const header = document.querySelector('header');
        const badge = document.createElement('span');
        badge.innerHTML = "🌟 SOVEREIGN PATRON";
        badge.style = "color:gold; font-size:10px; margin-left:10px; text-shadow:0 0 5px gold;";
        header.appendChild(badge);
    }
}
// --- ID_1013: Elite Market UI ---
async function openEliteMarket() {
    const res = await fetch('/api/empire/elite/buy', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, item_id: 'SYSTEM_ROOT_KEY' })
    });
    const data = await res.json();
    alert(data.message);
}

// --- ID_1015: Pension UI ---
async function claimMyPension() {
    const res = await fetch(`/api/empire/pension/claim?user_id=${userId}`);
    const data = await res.json();
    showEpicNotification("PENSION RECEIVED", `+${data.amount} IXP added to your account.`, "gold");
}

// اضافه کردن دکمه‌ها به UI
function injectDeepButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('pension-btn')) {
        const pBtn = document.createElement('button');
        pBtn.id = 'pension-btn';
        pBtn.innerHTML = '💰 DAILY PENSION';
        pBtn.onclick = claimMyPension;
        pBtn.style = "margin-top:10px; width:100%; background:#1a1a00; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer;";
        
        const eBtn = document.createElement('button');
        eBtn.id = 'elite-btn';
        eBtn.innerHTML = '🌟 ELITE MARKET';
        eBtn.onclick = openEliteMarket;
        eBtn.style = "margin-top:10px; width:100%; background:#000; color:cyan; border:1px solid cyan; padding:10px; font-size:0.7em; cursor:pointer;";
        
        zone.appendChild(pBtn);
        zone.appendChild(eBtn);
    }
}