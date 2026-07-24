
async function testPush() {
    await fetch('/api/empire/notify/test', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    alert("Test Signal sent to your Telegram Bot.");
}

// اجرای مکرر برای اطمینان از وجود دکمه در پروفایل
setInterval(injectNotifyToggle, 2000);
async function startDecipherGame() {
    const res = await fetch(`/api/minigame/decipher/start?user_id=${userId}`);
    const data = await res.json();
    const puzzle = data.puzzle;

    const gameOverlay = document.createElement('div');
    gameOverlay.id = 'decipher-ui';
    gameOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:10014; padding:20px; box-sizing:border-box; color:#0f0; font-family:monospace; text-align:center; display:flex; flex-direction:column; justify-content:center;";
    
    gameOverlay.innerHTML = `
        <h2 style="text-shadow:0 0 10px #0f0;">CORE DECIPHER</h2>
        <p style="font-size:0.7em;">MEMORIZE THE SEQUENCE:</p>
        <div id="sequence-display" style="font-size:2.5em; letter-spacing:10px; margin:20px 0; color:white;">${puzzle.sequence.join('')}</div>
        <p id="game-timer" style="color:red;">Time: ${puzzle.timer}s</p>
        <div id="input-zone" style="display:none; grid-template-columns: repeat(3, 1fr); gap:10px; max-width:200px; margin:auto;">
            ${[1,2,3,4,5,6,7,8,9].map(n => `<button onclick="handleDecipherInput(${n})" style="padding:15px; background:#111; border:1px solid #0f0; color:#0f0; cursor:pointer;">${n}</button>`).join('')}
        </div>
        <p id="user-input-view" style="margin-top:20px; font-size:1.5em; color:gold;"></p>
    `;
    document.body.appendChild(gameOverlay);

    // فاز نمایش توالی
    setTimeout(() => {
        document.getElementById('sequence-display').innerHTML = "****";
        document.getElementById('input-zone').style.display = 'grid';
    }, 2000);

    window.targetSeq = puzzle.sequence;
    window.userSeq = [];
}

async function handleDecipherInput(num) {
    window.userSeq.push(num);
    document.getElementById('user-input-view').innerHTML = window.userSeq.join('');
    
    if(window.userSeq.length === window.targetSeq.length) {
        const res = await fetch('/api/minigame/decipher/verify', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({ user_id: userId, sequence: window.userSeq, target: window.targetSeq, level: 1 })
        });
        const data = await res.json();
        alert(data.message);
        document.getElementById('decipher-ui').remove();
        if(typeof initGame === 'function') initGame();
    }
}

function injectDecipherButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('decipher-btn')) {
        const btn = document.createElement('button');
        btn.id = 'decipher-btn';
        btn.innerHTML = '🧩 CORE DECIPHER';
        btn.onclick = startDecipherGame;
        btn.style = "margin-top:10px; width:100%; background:#002200; color:#0f0; border:1px solid #0f0; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        zone.appendChild(btn);
    }
}
injectDecipherButton();
async function syncEmpireState() {
    const res = await fetch('/api/empire/sync', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    
    // نمایش پاداش آفلاین (CMD_920)
    if(data.offline_ixp > 0) {
        showEpicNotification("WELCOME BACK", `Your AI earned ${data.offline_ixp} IXP while you were away.`, "cyan");
    }
    
    // نمایش دستاوردهای جدید (CMD_921)
    (data.new_badges || []).forEach(badge => {
        showEpicNotification("ACHIEVEMENT UNLOCKED", `Rank Up: ${badge}`, "gold");
    });
}

// اجرای سینک در هر بار ورود
syncEmpireState();
setInterval(syncEmpireState, 60000); // سینک خودکار هر دقیقه

// اضافه کردن دکمه دعوت به پروفایل (CMD_919)
function injectReferralUI() {
    const dossier = document.getElementById('dossier-ui');
    if(dossier && !document.getElementById('ref-link-zone')) {
        const div = document.createElement('div');
        div.id = 'ref-link-zone';
        div.style = "margin-top:15px; background:rgba(255,255,255,0.05); padding:10px; border-radius:5px;";
        div.innerHTML = `
            <div style="font-size:0.5em; color:#aaa;">EMPIRE REFERRAL LINK</div>
            <div style="font-size:0.6em; color:cyan; word-break:break-all;">https://t.me/NasriumBot?start=${userId}</div>
            <button onclick="navigator.clipboard.writeText('https://t.me/NasriumBot?start=${userId}'); alert('Link Copied!')" style="margin-top:5px; width:100%; background:cyan; color:black; border:none; padding:5px; font-size:0.5em; cursor:pointer; font-weight:bold;">COPY LINK</button>
        `;
        dossier.querySelector('div').appendChild(div);
    }
}
setInterval(injectReferralUI, 2000);
async function openCommanderDashboard() {
    // این تابع فقط برای یوزر آیدی مهدی فراخوانی می‌شود
    const res = await fetch(`/api/admin/overview?user_id=COMMANDER_MEHDI`);
    const data = await res.json();
    
    if(!data.success) { alert(data.error); return; }
    
    const stats = data.stats;
    const adminOverlay = document.createElement('div');
    adminOverlay.id = 'admin-ui';
    adminOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:99999; padding:20px; box-sizing:border-box; color:red; font-family:monospace; border:5px solid red;";
    
    adminOverlay.innerHTML = `
        <h1 style="text-align:center; text-shadow:0 0 10px red;">SOVEREIGN COMMAND CENTER</h1>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px; margin-top:30px;">
            <div style="border:1px solid red; padding:15px;">
                <p>TOTAL CITIZENS</p>
                <h2 style="color:white;">${stats.total_citizens}</h2>
            </div>
            <div style="border:1px solid red; padding:15px;">
                <p>IXP IN CIRCULATION</p>
                <h2 style="color:white;">${stats.total_ixp_circulation.toLocaleString()}</h2>
            </div>
            <div style="border:1px solid red; padding:15px;">
                <p>ACTIVE MINERS</p>
                <h2 style="color:white;">${stats.active_miners}</h2>
            </div>
            <div style="border:1px solid red; padding:15px;">
                <p>SYSTEM LOAD</p>
                <h2 style="color:#0f0;">${stats.system_load}</h2>
            </div>
        </div>
        <div style="margin-top:30px; text-align:center;">
            <p>BROADCAST EMERGENCY SIGNAL</p>
            <input type="text" id="admin-msg" style="width:100%; background:#111; border:1px solid red; color:white; padding:10px;">
            <button onclick="sendGlobalAlert()" style="margin-top:10px; width:100%; padding:15px; background:red; color:white; font-weight:bold; cursor:pointer;">ACTIVATE BROADCAST</button>
        </div>
        <button onclick="document.getElementById('admin-ui').remove()" style="margin-top:40px; color:white; background:none; border:none; cursor:pointer; width:100%;">[CLOSE COMMAND CENTER]</button>
    `;
    document.body.appendChild(adminOverlay);
}

async function sendGlobalAlert() {
    const msg = document.getElementById('admin-msg').value;
    await fetch('/api/empire/broadcast/send', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: 'COMMANDER_MEHDI', content: msg, type: 'EMERGENCY' })
    });
    alert("Emergency signal broadcasted to all sectors.");
}
// --- CMD_925: Turbo Load Logic ---
function initTurboLoad() {
    console.log("🚀 TurboLoad: Optimizing Asset Pipelines...");
    const start = performance.now();
    // پیش‌بارگذاری دارایی‌های حیاتی
    window.addEventListener('load', () => {
        const end = performance.now();
        console.log(`✅ Empire Loaded in ${(end - start).toFixed(2)}ms`);
    });
}

// --- CMD_924: Theme Switcher ---
async function applyTheme(themeId) {
    const res = await fetch('/api/visual/themes');
    const data = await res.json();
    const theme = data.themes[themeId];
    
    document.body.style.backgroundColor = theme.bg;
    document.documentElement.style.setProperty('--accent-color', theme.accent);
    console.log(`🎨 Theme Switched to: ${theme.name}`);
}

// --- CMD_926: Interactive Tutorial ---
function startImperialTour() {
    if(localStorage.getItem('nasrium_tour_done')) return;

    const steps = [
        { el: 'mining-btn', text: 'This is your Lifeblood. Extract IXP here.' },
        { el: 'arena-btn', text: 'Test your AI might against others here.' },
        { el: 'profile-btn', text: 'Your Dossier contains your Imperial Identity.' }
    ];

    let currentStep = 0;

    function showStep() {
        if(currentStep >= steps.length) {
            document.getElementById('tour-overlay').remove();
            localStorage.setItem('nasrium_tour_done', 'true');
            return;
        }

        const step = steps[currentStep];
        const target = document.getElementById(step.el);
        if(!target) { currentStep++; showStep(); return; }

        const overlay = document.getElementById('tour-overlay') || document.createElement('div');
        overlay.id = 'tour-overlay';
        overlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.8); z-index:200001; color:white; pointer-events:none;";
        
        const rect = target.getBoundingClientRect();
        overlay.innerHTML = `
            <div style="position:absolute; top:${rect.bottom + 10}px; left:${rect.left}px; background:var(--accent-color, #00ff00); color:black; padding:10px; border-radius:5px; font-weight:bold; max-width:200px; pointer-events:auto;">
                ${step.text}
                <br><button onclick="nextTourStep()" style="margin-top:10px; border:none; background:black; color:white; padding:5px 10px; cursor:pointer;">NEXT</button>
            </div>
            <div style="position:absolute; top:${rect.top}px; left:${rect.left}px; width:${rect.width}px; height:${rect.height}px; border:2px solid white; box-shadow:0 0 0 9999px rgba(0,0,0,0.5);"></div>
        `;
        if(!document.getElementById('tour-overlay')) document.body.appendChild(overlay);
    }

    window.nextTourStep = () => { currentStep++; showStep(); };
    showStep();
}

// اجرای اولیه
initTurboLoad();
setTimeout(startImperialTour, 3000);
async function launchEmpire() {
    // CMD_930: غیرفعال کردن تمام برچسب‌های TEST و فعال‌سازی محیط LIVE
    document.body.classList.add('nasrium-live');
    
    const openingOverlay = document.createElement('div');
    openingOverlay.id = 'grand-opening';
    openingOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:300000; display:flex; flex-direction:column; align-items:center; justify-content:center; color:gold; text-align:center;";
    
    openingOverlay.innerHTML = `
        <video autoplay muted loop style="position:absolute; width:100%; height:100%; object-fit:cover; opacity:0.3;">
            <source src="static/assets/nebula.mp4" type="video/mp4">
        </video>
        <div style="position:relative; z-index:1;">
            <h1 style="font-size:4em; margin:0; text-shadow:0 0 30px gold;">نصریوم</h1>
            <h2 style="letter-spacing:10px; color:white;">THE EMPIRE IS BORN</h2>
            <p style="margin-top:20px; font-family:monospace; color:#aaa;">NASRIUM PROTOCOL v1.0.0 | SOVEREIGN LAUNCH</p>
            <button onclick="enterNasriumLive()" style="margin-top:50px; padding:20px 60px; background:gold; color:black; border:none; font-weight:bold; font-size:1.5em; cursor:pointer; box-shadow:0 0 50px gold;">CLAIM YOUR DESTINY</button>
        </div>
    `;
    document.body.appendChild(openingOverlay);
}

function enterNasriumLive() {
    document.getElementById('grand-opening').style.opacity = '0';
    setTimeout(() => {
        document.getElementById('grand-opening').remove();
        console.log("Welcome to Nasrium, Commander.");
    }, 2000);
}

// فرمان نهایی انتشار
if(window.location.hash === '#launch') {
    launchEmpire();
}
async function openWarRoom() {
    const res = await fetch('/api/empire/war/status');
    const data = await res.json();
    const war = data.war;

    const warOverlay = document.createElement('div');
    warOverlay.id = 'war-ui';
    warOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:linear-gradient(to bottom, #200, #000); z-index:10015; padding:20px; box-sizing:border-box; color:white; font-family:monospace; text-align:center;";
    
    warOverlay.innerHTML = `
        <h1 style="color:red; text-shadow:0 0 15px red;">IMPERIAL WAR ROOM</h1>
        <div style="border:1px solid red; padding:20px; background:rgba(255,0,0,0.1);">
            <h3>${war.name}</h3>
            <p style="font-size:0.6em; color:#aaa;">The first global conflict of the Pure Ecosystem.</p>
            <div style="margin:20px 0;">
                <div style="font-size:0.5em; color:red;">GRAND PRIZE POOL</div>
                <div style="font-size:1.8em; font-weight:bold; color:gold;">${war.prize_pool.toLocaleString()} IXP</div>
            </div>
            <p style="font-size:0.7em;">Registered Legions: ${war.participants.length}</p>
            <button onclick="registerForWar()" style="width:100%; padding:15px; background:red; color:white; font-weight:bold; border:none; cursor:pointer; box-shadow:0 0 10px red;">REGISTER LEGION</button>
        </div>
        <button onclick="document.getElementById('war-ui').remove()" style="margin-top:30px; background:none; border:none; color:#555; cursor:pointer;">RETURN TO PEACE</button>
    `;
    document.body.appendChild(warOverlay);
}

async function registerForWar() {
    // فرض بر این است که یوزر عضو لژیون است
    const res = await fetch('/api/empire/war/join', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, legion_name: 'Alpha_Legion' }) // تستی
    });
    const data = await res.json();
    alert(data.message);
}

function injectWarButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('war-btn')) {
        const btn = document.createElement('button');
        btn.id = 'war-btn';
        btn.innerHTML = '⚔️ WAR ROOM';
        btn.onclick = openWarRoom;
        btn.style = "margin-top:10px; width:100%; background:#400; color:white; border:1px solid red; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        zone.appendChild(btn);
    }
}
injectWarButton();
// --- CMD_933: AI Interaction ---
async function refreshAIInteraction() {
    const res = await fetch('/api/empire/ai/personality');
    const data = await res.json();
    const aiBox = document.getElementById('ai-chat-bubble');
    if(aiBox) aiBox.innerHTML = `🤖: "${data.message}"`;
}

// --- CMD_934: Sovereign Governance ---
async function openGovernance() {
    const govOverlay = document.createElement('div');
    govOverlay.id = 'gov-ui';
    govOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,10,20,0.98); z-index:10016; padding:20px; box-sizing:border-box; color:white; font-family:serif; text-align:center;";
    
    govOverlay.innerHTML = `
        <h1 style="color:#00d4ff; text-shadow:0 0 10px #00d4ff;">CLEAN GOVERNANCE</h1>
        <p style="font-size:0.7em; color:#aaa;">Sovereign Rank Only - Decision Matrix</p>
        <div style="margin-top:40px; border:1px solid #00d4ff; padding:20px; background:rgba(0,212,255,0.05);">
            <p>Proposal #1: Increase Global Mining Rate by 5%?</p>
            <div style="display:flex; gap:10px; margin-top:20px;">
                <button onclick="castVote(1, 'YES')" style="flex:1; padding:15px; background:#00ff00; color:black; font-weight:bold;">YES</button>
                <button onclick="castVote(1, 'NO')" style="flex:1; padding:15px; background:#ff0000; color:white; font-weight:bold;">NO</button>
            </div>
        </div>
        <button onclick="document.getElementById('gov-ui').remove()" style="margin-top:40px; background:none; border:none; color:#555; cursor:pointer;">EXIT HALL</button>
    `;
    document.body.appendChild(govOverlay);
}

async function castVote(propId, vote) {
    const res = await fetch('/api/empire/gov/vote', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, prop_id: propId, vote: vote })
    });
    const data = await res.json();
    alert(data.message);
}

function injectEvolutionButtons() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('gov-btn')) {
        const govBtn = document.createElement('button');
        govBtn.id = 'gov-btn';
        govBtn.innerHTML = '🏛️ GOVERNANCE';
        govBtn.onclick = openGovernance;
        govBtn.style = "margin-top:10px; width:100%; background:#001f3f; color:#00d4ff; border:1px solid #00d4ff; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        
        const aiBubble = document.createElement('div');
        aiBubble.id = 'ai-chat-bubble';
        aiBubble.style = "margin-top:10px; padding:10px; background:#111; border-radius:10px; font-size:0.6em; color:#aaa; font-style:italic;";
        
        zone.appendChild(govBtn);
        zone.appendChild(aiBubble);
        refreshAIInteraction();
    }
}
injectEvolutionButtons();
// --- CMD_935: World Event Banner ---
async function updateWorldEvent() {
    const res = await fetch('/api/world/status');
    const data = await res.json();
    const event = data.current_event;
    if(!event) return;

    let banner = document.getElementById('world-event-banner');
    if(!banner) {
        banner = document.createElement('div');
        banner.id = 'world-event-banner';
        banner.style = "position:fixed; top:0; left:0; width:100%; background:linear-gradient(to right, #6a11cb, #2575fc); color:white; font-size:0.6em; text-align:center; padding:5px; z-index:200002; font-weight:bold; letter-spacing:1px;";
        document.body.appendChild(banner);
    }
    banner.innerHTML = `🌍 WORLD EVENT: ${event.name} (${event.effect})`;
}

// --- CMD_937: Artifact Discovery ---
async function scanForArtifacts() {
    const res = await fetch('/api/player/find_artifact', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    if(data.success) {
        showEpicNotification("ARTIFACT FOUND!", `You discovered a ${data.artifact.name}: ${data.artifact.buff}`, "magenta");
    }
}

// اجرای دوره‌ای
setInterval(updateWorldEvent, 60000);
updateWorldEvent();

// اضافه کردن اسکنر به بخش استخراج
function injectScanner() {
    const mineZone = document.getElementById('mining-ui');
    if(mineZone && !document.getElementById('scan-btn')) {
        const btn = document.createElement('button');
        btn.id = 'scan-btn';
        btn.innerHTML = '🔍 SCAN FOR ARTIFACTS';
        btn.onclick = scanForArtifacts;
        btn.style = "margin-top:10px; width:100%; background:transparent; border:1px solid magenta; color:magenta; padding:10px; font-size:0.7em; cursor:pointer;";
        mineZone.appendChild(btn);
    }
}
setInterval(injectScanner, 2000);
// --- CMD_940: Nasrium Radio Widget ---
async function initNasriumRadio() {
    const res = await fetch('/api/media/radio');
    const data = await res.json();
    
    const radioDiv = document.createElement('div');
    radioDiv.id = 'nasrium-radio';
    radioDiv.style = "position:fixed; bottom:10px; left:10px; background:rgba(0,0,0,0.8); border:1px solid #444; padding:5px 15px; border-radius:20px; color:#aaa; font-size:0.5em; z-index:10017; display:flex; align-items:center; gap:10px;";
    radioDiv.innerHTML = `
        <span id="radio-icon" style="color:red; animation: blink 1s infinite;">● RADIO</span>
        <span id="radio-news">NEWS: ${data.current_news}</span>
    `;
    document.body.appendChild(radioDiv);
}