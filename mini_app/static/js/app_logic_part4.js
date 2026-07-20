
function updatePreview() {
    const sym = document.getElementById('emb-symbol').value;
    const clr = document.getElementById('emb-color').value;
    const preview = document.getElementById('emblem-preview');
    preview.style.borderColor = clr;
    preview.style.boxShadow = `0 0 10px ${clr}`;
}

async function saveEmblem() {
    const sym = document.getElementById('emb-symbol').value;
    const clr = document.getElementById('emb-color').value;
    const res = await fetch('/api/identity/emblem/save', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, symbol: sym, border: 'Cyber', color: clr })
    });
    const data = await res.json();
    alert(data.message);
}

// توسعه اینیت
const oldInit527 = initGame;
initGame = async () => {
    await oldInit527();
    loadHeraldry();
};
async function loadGamesHub() {
    const container = document.getElementById('app-container');
    const gamesHtml = `
        <div id="games-zone" class="zone-card" style="border: 2px solid #f1c40f; background: rgba(241, 196, 15, 0.05); margin-top:10px; text-align:center;">
            <div class="zone-title" style="color: #f1c40f;">🏆 IMPERIAL GAMES</div>
            <div style="padding:15px;">
                <p style="font-size:0.55em; color:#aaa;">Test your reflexes and earn NSM Soft rewards.</p>
                <div id="game-preview" style="height:80px; background:#000; border:1px dashed #f1c40f; border-radius:10px; margin:10px 0; display:flex; justify-content:center; align-items:center; cursor:pointer;" onclick="playReflexGame()">
                    <span style="font-size:0.8em; color:#f1c40f;">TAP TO START: GRID REFLEX</span>
                </div>
                <div id="game-status" style="font-size:0.45em; color:#888;">Daily Quota: 3/3 Runs Available</div>
            </div>
        </div>
    `;
    
    if(!document.getElementById('games-zone')) {
        const div = document.createElement('div');
        div.id = 'games-anchor';
        div.innerHTML = gamesHtml;
        container.appendChild(div);
    }
}

async function playReflexGame() {
    // شبیه‌سازی یک مینی‌گیم سریع
    const score = Math.floor(Math.random() * 100) + 1;
    const res = await fetch('/api/games/submit', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, game_id: 'grid_reflex', score: score })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit528 = initGame;
initGame = async () => {
    await oldInit528();
    loadGamesHub();
};
async function loadHallOfFame() {
    try {
        const res = await fetch('/api/sovereignty/fame/list');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('app-container');
            const legendsHtml = data.legends.map(l => `
                <div style="background:rgba(255,255,255,0.05); padding:10px; border:1px solid #e5e4e2; border-radius:10px; margin-bottom:8px; text-align:center;">
                    <div style="font-size:1.2em; color:#e5e4e2;">⭐</div>
                    <b style="color:#fff; font-size:0.7em;">${l.username}</b><br>
                    <small style="color:#e5e4e2; font-size:0.45em;">${l.achievement}</small><br>
                    <span style="color:#888; font-size:0.4em;">RANK: ${l.rank}</span>
                </div>
            `).join('');

            const hallHtml = `
                <div id="hall-fame-zone" class="zone-card" style="border: 2px solid #e5e4e2; background: linear-gradient(180deg, #000, #1a1a1a); margin-top:10px;">
                    <div class="zone-title" style="color: #e5e4e2; text-shadow: 0 0 10px #fff;">🏛️ ETERNAL HALL OF FAME</div>
                    <div style="padding:15px;">
                        <div id="legends-list">${legendsHtml}</div>
                    </div>
                </div>
            `;
            
            if(!document.getElementById('hall-fame-zone')) {
                const div = document.createElement('div');
                div.id = 'hall-anchor';
                div.innerHTML = hallHtml;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

// توسعه اینیت
const oldInit529 = initGame;
initGame = async () => {
    await oldInit529();
    loadHallOfFame();
};
async function loadChronosTime() {
    try {
        const res = await fetch('/api/system/chronos/now');
        const data = await res.json();
        if(data.success) {
            const header = document.querySelector('.flex.justify-between.items-center');
            if(!header) return;

            const timeHtml = `
                <div id="chronos-widget" style="background:#000; border:1px solid #f1c40f; padding:2px 8px; border-radius:5px; text-align:right; line-height:1;">
                    <div style="font-size:0.4em; color:#888;">IMPERIAL YEAR</div>
                    <div style="font-size:0.7em; color:#f1c40f; font-weight:bold;">IY ${data.date.year}</div>
                    <div style="font-size:0.35em; color:#fff; text-transform:uppercase;">${data.date.era}</div>
                </div>
            `;
            
            if(!document.getElementById('chronos-widget')) {
                const div = document.createElement('div');
                div.id = 'chronos-anchor';
                div.innerHTML = timeHtml;
                header.insertBefore(div, header.firstChild);
            }
        }
    } catch(e) {}
}

// توسعه اینیت
const oldInit530 = initGame;
initGame = async () => {
    await oldInit530();
    loadChronosTime();
};
async function loadSingularityCore() {
    try {
        const res = await fetch('/api/ai/singularity/status');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('neural-hub-zone');
            if(!container) return;

            const progress = (data.core.current_ixp / data.core.target_ixp) * 100;
            const coreHtml = `
                <div id="singularity-subzone" style="margin-top:20px; border:2px solid #e056fd; background: radial-gradient(circle, #2c003e 0%, #000 100%); border-radius:15px; padding:15px; text-align:center; position:relative; overflow:hidden;">
                    <div style="font-size:0.7em; color:#e056fd; font-weight:bold; letter-spacing:2px;">SINGULARITY CORE</div>
                    <div id="vortex-core" style="width:40px; height:40px; border:3px dotted #e056fd; border-radius:50%; margin:10px auto; animation: spin-vortex 1s infinite linear;"></div>
                    <div style="width:100%; height:4px; background:#222; margin:10px 0; border-radius:2px;">
                        <div style="width:${progress}%; height:100%; background:#e056fd; box-shadow:0 0 10px #e056fd;"></div>
                    </div>
                    <div style="font-size:0.5em; color:#aaa;">Global Consciousness: ${progress.toFixed(1)}%</div>
                    <button onclick="contributeIXP()" style="margin-top:10px; background:#e056fd; color:#fff; border:none; padding:5px 15px; font-weight:bold; font-size:0.6em; border-radius:3px; cursor:pointer;">INJECT IXP</button>
                </div>
            `;
            
            if(!document.getElementById('singularity-subzone')) {
                const div = document.createElement('div');
                div.id = 'singularity-anchor';
                div.innerHTML = coreHtml;
                container.parentNode.appendChild(div);
            }
        }
    } catch(e) {}
}

async function contributeIXP() {
    const amt = prompt("Amount of IXP to merge with the Collective Mind:");
    if(!amt) return;
    const res = await fetch('/api/ai/singularity/contribute', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, amount: amt })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { initGame(); loadSingularityCore(); }
}

// توسعه اینیت
const oldInit532 = initGame;
initGame = async () => {
    await oldInit532();
    loadSingularityCore();
};
async function showEternalVault() {
    const res = await fetch(`/api/vault/status/${userId}`);
    const data = await res.json();
    
    if(data.success) {
        const vaultOverlay = document.createElement('div');
        vaultOverlay.id = 'eternal-vault-ui';
        vaultOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.9); z-index:9999; display:flex; flex-direction:column; align-items:center; justify-content:center; color:gold; font-family:monospace; border: 2px solid gold; margin: 5px; box-sizing: border-box;";
        
        vaultOverlay.innerHTML = `
            <h2 style="text-shadow: 0 0 15px gold;">CHRONOS-VAULT: ETERNAL RECORDS</h2>
            <div style="border:1px solid gold; padding:20px; text-align:center; background: #111;">
                <p>CITIZEN ID: ${userId}</p>
                <p>STATUS: <span style="color:#0f0;">IMMORTAL</span></p>
                <p>LAST SYNC: ${data.status.last_sync}</p>
                <div style="font-size:0.6em; color:gray; max-width:250px; word-wrap: break-word;">VAULT_HASH: ${Math.random().toString(36).substring(2, 15)}</div>
            </div>
            <button onclick="document.getElementById('eternal-vault-ui').remove()" style="margin-top:20px; background:gold; color:black; border:none; padding:10px 20px; font-weight:bold; cursor:pointer;">CLOSE ARCHIVE</button>
        `;
        document.body.appendChild(vaultOverlay);
    }
}

// اضافه کردن دکمه به منوی اصلی
function injectVaultButton() {
    const menu = document.getElementById('main-menu-nav'); // فرض بر وجود این آیدی
    if(menu && !document.getElementById('vault-btn')) {
        const btn = document.createElement('button');
        btn.id = 'vault-btn';
        btn.innerHTML = '🏛️ VAULT';
        btn.onclick = showEternalVault;
        btn.style = "background:none; border:1px solid gold; color:gold; font-size:0.6em; margin-left:5px; cursor:pointer;";
        menu.appendChild(btn);
    }
}
injectVaultButton();
async function openGlobalEmbassy() {
    const res = await fetch(`/api/embassy/passport?user_id=${userId}`);
    const res2 = await fetch(`/api/embassy/alliances`);
    const data = await res.json();
    const alliances = await res2.json();

    const embassyDiv = document.createElement('div');
    embassyDiv.id = 'embassy-ui';
    embassyDiv.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:linear-gradient(135deg, #001f3f 0%, #000 100%); z-index:10000; color:#00d4ff; padding:20px; font-family:sans-serif; overflow-y:auto;";
    
    let allianceList = alliances.alliances.map(a => `<li style="list-style:none; color:#aaa; margin:5px 0;">💠 ${a}</li>`).join('');

    embassyDiv.innerHTML = `
        <div style="text-align:center; border-bottom:1px solid #00d4ff; padding-bottom:15px;">
            <h1 style="letter-spacing:3px;">GLOBAL EMBASSY</h1>
            <p style="font-size:0.8em;">INTERNATIONAL DIPLOMACY GATEWAY</p>
        </div>
        <div style="margin-top:20px; background:rgba(255,255,255,0.05); padding:15px; border-radius:10px;">
            <h3>DIPLOMATIC PASSPORT</h3>
            <p style="font-size:1.2em; font-weight:bold; color:#fff;">CODE: ${data.passport}</p>
            <button onclick="navigator.clipboard.writeText('${data.passport}'); alert('Passport Copied!')" style="background:#00d4ff; border:none; padding:5px 10px; border-radius:3px; cursor:pointer; font-weight:bold;">COPY CODE</button>
        </div>
        <div style="margin-top:20px;">
            <h3>ACTIVE ALLIANCES</h3>
            <ul>${allianceList}</ul>
        </div>
        <button onclick="document.getElementById('embassy-ui').remove()" style="width:100%; margin-top:30px; padding:15px; background:transparent; border:1px solid #00d4ff; color:#00d4ff; font-weight:bold; cursor:pointer;">EXIT EMBASSY</button>
    `;
    document.body.appendChild(embassyDiv);
}

// اضافه کردن دکمه سفارت به هاب اصلی
function injectEmbassyLink() {
    const hub = document.getElementById('neural-hub-zone');
    if(hub && !document.getElementById('embassy-btn')) {
        const btn = document.createElement('button');
        btn.id = 'embassy-btn';
        btn.innerHTML = '🌐 GLOBAL EMBASSY';
        btn.onclick = openGlobalEmbassy;
        btn.style = "margin-top:10px; width:100%; background:#001f3f; color:#00d4ff; border:1px solid #00d4ff; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        hub.appendChild(btn);
    }
}
injectEmbassyLink();
async function peekIntoFuture() {
    const res = await fetch('/api/ai/observatory/vision');
    const data = await res.json();
    
    if(data.success) {
        const vision = data.vision;
        const container = document.getElementById('neural-hub-zone');
        
        const visionHtml = `
            <div id="quantum-radar" style="margin-top:20px; border:1px solid #00f3ff; background:rgba(0, 243, 255, 0.05); border-radius:10px; padding:15px; position:relative; overflow:hidden;">
                <div style="position:absolute; top:0; left:0; width:100%; height:2px; background:#00f3ff; animation: scan-line 2s infinite linear;"></div>
                <h4 style="color:#00f3ff; margin:0; font-size:0.8em;">🔭 QUANTUM VISION: ${vision.vision_title}</h4>
                <p style="font-size:0.65em; color:#fff; margin:10px 0;">${vision.description}</p>
                <div style="display:flex; justify-content:space-between; font-size:0.55em; color:#00f3ff; font-weight:bold;">
                    <span>PROBABILITY: ${vision.probability}</span>
                    <span>ETA: ${vision.estimated_time}</span>
                </div>
            </div>
            <style>
                @keyframes scan-line { 0% { top: 0; } 100% { top: 100%; } }
            </style>
        `;
        
        const oldRadar = document.getElementById('quantum-radar');
        if(oldRadar) oldRadar.remove();
        
        const div = document.createElement('div');
        div.innerHTML = visionHtml;
        container.appendChild(div);
    }
}

// اجرای دوره‌ای رصدخانه
setInterval(peekIntoFuture, 600000); // هر ۱۰ دقیقه آپدیت شود
peekIntoFuture();
async function triggerSovereignLaunch() {
    const res = await fetch('/api/system/status');
    const data = await res.json();
    
    if(data.success) {
        const seal = data.seal;
        const overlay = document.createElement('div');
        overlay.id = 'launch-overlay';
        overlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:100000; display:flex; flex-direction:column; align-items:center; justify-content:center; color:gold; text-align:center; transition: opacity 2s;";
        
        overlay.innerHTML = `
            <div style="border: 5px double gold; padding: 40px; background: radial-gradient(circle, #222 0%, #000 100%);">
                <h1 style="font-size:3em; margin:0; text-shadow: 0 0 20px gold;">NASRIUM</h1>
                <h2 style="letter-spacing:5px;">EMPIRE ACTIVE</h2>
                <hr style="border:1px solid gold;">
                <p style="font-family:monospace; font-size:0.8em;">SEAL ID: ${seal.seal_id}</p>
                <p style="font-size:1.2em; margin-top:20px;">COMMANDER: ${seal.authority}</p>
                <div style="margin-top:30px; font-style:italic; color:#fff;">"The Future belongs to the Architects of Logic."</div>
                <button onclick="document.getElementById('launch-overlay').style.opacity='0'; setTimeout(()=>document.getElementById('launch-overlay').remove(), 2000)" 
                        style="margin-top:40px; background:gold; color:black; border:none; padding:15px 40px; font-weight:bold; cursor:pointer; box-shadow: 0 0 15px gold;">ENTER EMPIRE</button>
            </div>
        `;
        document.body.appendChild(overlay);
        
        // پخش صدای نمادین (در صورت وجود فایل صوتی)
        console.log("SYSTEM LIVE: Sovereign Seal Applied.");
    }
}
// اجرای خودکار لانچ در اولین ورود
setTimeout(triggerSovereignLaunch, 1000);
async function updateEconomyUI() {
    const res = await fetch('/api/economy/vault');
    const data = await res.json();
    
    const vaultDiv = document.getElementById('imperial-vault-status');
    if(vaultDiv) {
        vaultDiv.innerHTML = `🏦 TREASURY: ${Math.floor(data.balance)} IXP`;
    }
}

async function requestWelfare() {
    const res = await fetch('/api/economy/welfare', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// اضافه کردن ویجت خزانه به هدر
function injectTreasuryWidget() {
    if(!document.getElementById('imperial-vault-status')) {
        const header = document.querySelector('header') || document.body;
        const widget = document.createElement('div');
        widget.id = 'imperial-vault-status';
        widget.style = "position:fixed; top:5px; right:5px; background:rgba(255,215,0,0.2); color:gold; border:1px solid gold; padding:2px 10px; font-size:0.5em; border-radius:10px; z-index:1000;";
        header.appendChild(widget);
    }
}
injectTreasuryWidget();
updateEconomyUI();
setInterval(updateEconomyUI, 30000);
async function checkPublicStatus() {
    const res = await fetch('/api/launch/info');
    const status = await res.json();
    
    if(status.success && status.data.status === "GLOBAL_LIVE") {
        console.log("NASRIUM IS PUBLICLY LIVE.");
        // اگر کاربر جدید است، بیدارش کن
        if(!localStorage.getItem('nasrium_joined')) {
            const awakenRes = await fetch('/api/launch/awaken', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({ user_id: userId })
            });
            const data = await awakenRes.json();
            if(data.success) {
                alert("👑 NASRIUM: " + data.message);
                localStorage.setItem('nasrium_joined', 'true');
                if(typeof initGame === 'function') initGame();
            }
        }
    }
}
checkPublicStatus();
async function enterArena() {
    const bet = prompt("Enter IXP bet amount for AI Duel:");
    if(!bet || isNaN(bet)) return;

    const res = await fetch('/api/arena/duel', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, bet: parseInt(bet) })
    });
    const data = await res.json();

    if(data.success) {
        const result = data.result;
        alert(result.battle_log);
        if(typeof initGame === 'function') initGame(); // رفرش استات‌ها
    } else {
        alert("Duel Failed: " + data.message);
    }
}

// اضافه کردن دکمه آرنا به منوی اصلی
function injectArenaButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('arena-btn')) {
        const btn = document.createElement('button');
        btn.id = 'arena-btn';
        btn.innerHTML = '⚔️ BATTLE ARENA';
        btn.onclick = enterArena;
        btn.style = "margin-top:10px; width:100%; background:linear-gradient(to right, #800, #300); color:white; border:1px solid red; padding:12px; font-weight:bold; cursor:pointer; text-shadow: 0 0 5px red;";
        zone.appendChild(btn);
    }
}
injectArenaButton();
async function showLeaderboard() {
    const res = await fetch('/api/empire/leaderboard');
    const data = await res.json();

    if(data.success) {
        const list = data.leaderboard.map(p => `
            <div style="display:flex; justify-content:space-between; padding:8px; border-bottom:1px solid #333; font-size:0.7em; color:${p.rank <= 3 ? 'gold' : '#ccc'}">
                <span>#${p.rank} ${p.user_id.substring(0,8)}...</span>
                <span style="font-weight:bold;">${p.ixp.toLocaleString()} IXP</span>
            </div>
        `).join('');

        const rankOverlay = document.createElement('div');
        rankOverlay.id = 'rank-ui';
        rankOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.95); z-index:10001; padding:20px; box-sizing:border-box; color:gold; font-family:monospace;";
        rankOverlay.innerHTML = `
            <h2 style="text-align:center; border-bottom:2px solid gold; padding-bottom:10px;">SOVEREIGN 10</h2>
            <div style="margin-top:20px; max-height:70vh; overflow-y:auto;">${list}</div>
            <button onclick="document.getElementById('rank-ui').remove()" style="width:100%; margin-top:30px; padding:15px; background:gold; color:black; border:none; font-weight:bold; cursor:pointer;">CLOSE HALL</button>
        `;
        document.body.appendChild(rankOverlay);
    }
}