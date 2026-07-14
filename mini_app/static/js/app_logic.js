// Nasrium CORE LOGIC - v1.1.0
const userId = "COMMANDER_MEHDI_ID"; // Temporary holder

async function initGame() {
    console.log("Nasrium Sovereign Core Resynced.");
    loadWeather();
    loadEmpirePulse();
    loadWarp();
}

async function loadWeather() { /* Logic from CMD_463 */ }
async function loadWarp() { /* Logic from CMD_477 */ }
async function igniteWormhole() { /* Logic from CMD_492 */ }

window.onload = () => {
    initGame();
    // Ignition Animation
    setTimeout(() => { document.getElementById('ignition-overlay').style.opacity = '0'; }, 2000);
};
async function loadVault() {
    try {
        const res = await fetch(`/api/security/vault/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            document.getElementById('vault-zone').innerHTML = `
                <div class="zone-card" style="border: 2px solid #00f3ff; background: rgba(0,243,255,0.05); margin-top:10px;">
                    <div class="zone-title" style="color: #00f3ff;">🔐 QUANTUM VAULT (Lv.${data.level})</div>
                    <div style="padding:10px; text-align:center;">
                        <p style="font-size:0.5em; color:#aaa;">Encrypted Assets (Un-raidable):</p>
                        <b style="color:#f1c40f; font-size:0.9em;">${data.protected_gold.toLocaleString()} Gold</b>
                        <button onclick="upgradeVault()" style="margin-top:10px; width:100%; background:#00f3ff; color:#000; border:none; padding:5px; font-weight:bold; font-size:0.6em;">UPGRADE ENCRYPTION</button>
                    </div>
                </div>
            `;
        }
    } catch(e) {}
}

async function upgradeVault() {
    const res = await fetch('/api/security/vault/upgrade', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { initGame(); loadVault(); }
}

// انتهای فایل JS قبلی
const originalInit = initGame;
initGame = async () => {
    await originalInit();
    loadVault();
};
async function loadVault() {
    try {
        const res = await fetch(`/api/security/vault/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            document.getElementById('vault-zone').innerHTML = `
                <div class="zone-card" style="border: 2px solid #00f3ff; background: rgba(0,243,255,0.05); margin-top:10px;">
                    <div class="zone-title" style="color: #00f3ff;">🔐 QUANTUM VAULT (Lv.${data.level})</div>
                    <div style="padding:10px; text-align:center;">
                        <p style="font-size:0.5em; color:#aaa;">Encrypted Assets (Un-raidable):</p>
                        <b style="color:#f1c40f; font-size:0.9em;">${data.protected_gold.toLocaleString()} Gold</b>
                        <button onclick="upgradeVault()" style="margin-top:10px; width:100%; background:#00f3ff; color:#000; border:none; padding:5px; font-weight:bold; font-size:0.6em;">UPGRADE ENCRYPTION</button>
                    </div>
                </div>
            `;
        }
    } catch(e) {}
}

async function upgradeVault() {
    const res = await fetch('/api/security/vault/upgrade', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { initGame(); loadVault(); }
}

// انتهای فایل JS قبلی
const originalInit = initGame;
initGame = async () => {
    await originalInit();
    loadVault();
};
async function loadStealthOps() {
    try {
        const res = await fetch(`/api/military/stealth/build`, { // در سیستم واقعی گت استتوس
            method: 'POST', body: JSON.stringify({ user_id: userId, check_only: true }) 
        }); // ساده سازی شده برای لود تعداد
        document.getElementById('stealth-zone').innerHTML = `
            <div class="zone-card" style="border: 2px solid #555; background: rgba(0,0,0,0.8); margin-top:10px;">
                <div class="zone-title" style="color: #aaa;">🕶️ STEALTH OPS</div>
                <div style="padding:10px; text-align:center;">
                    <div style="font-size:0.5em; color:#888;">Active Stealth Drones: <b id="drone-count" style="color:#fff">0</b></div>
                    <input id="recon-target" type="text" placeholder="TARGET_ID" style="width:100%; background:#000; color:#fff; border:1px solid #444; font-size:0.6em; padding:5px; margin:5px 0;">
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:5px;">
                        <button onclick="buildDrone()" style="background:#333; color:#fff; border:none; padding:5px; font-size:0.55em;">BUILD (30k💰)</button>
                        <button onclick="sendRecon()" style="background:#aaa; color:#000; border:none; padding:5px; font-weight:bold; font-size:0.55em;">DISPATCH</button>
                    </div>
                </div>
            </div>
        `;
    } catch(e) {}
}

async function buildDrone() {
    const res = await fetch('/api/military/stealth/build', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { 
        document.getElementById('drone-count').innerText = data.drones;
        initGame(); 
    }
}

async function sendRecon() {
    const tid = document.getElementById('recon-target').value;
    const res = await fetch('/api/military/stealth/recon', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, target_id: tid })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// بروزرسانی اینیت
const oldInit494 = initGame;
initGame = async () => {
    await oldInit494();
    loadStealthOps();
};
async function checkHolidays() {
    try {
        const res = await fetch('/api/system/holiday/status');
        const data = await res.json();
        if(data.success && data.data.event) {
            document.getElementById('holiday-banner').style.display = 'block';
            document.getElementById('holiday-name').innerText = data.data.event.toUpperCase();
            // تغییر استایل دکمه‌ها به طلایی در زمان جشن
            document.body.classList.add('holiday-mode');
        }
    } catch(e) {}
}

const oldInit495 = initGame;
initGame = async () => {
    await oldInit495();
    checkHolidays();
};
async function updateProsperity() {
    try {
        const res = await fetch('/api/system/prosperity/status');
        const data = await res.json();
        if(data.success) {
            document.getElementById('prosperity-fill').style.width = data.data.prosperity_score + "%";
            if(data.data.is_active) {
                document.body.style.boxShadow = "inset 0 0 50px rgba(241, 196, 15, 0.1)";
                console.log("GOLDEN AGE ACTIVE");
            }
        }
    } catch(e) {}
}

const oldInit496 = initGame;
initGame = async () => {
    await oldInit496();
    updateProsperity();
};
async function loadGridAlerts() {
    try {
        const res = await fetch('/api/military/rebellion/alerts');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('rebellion-zone');
            const alerts = Object.keys(data.alerts).map(id => {
                const a = data.alerts[id];
                const pct = (a.hp / a.max_hp) * 100;
                return `
                    <div class="zone-card" style="border: 2px solid #ff4d4d; background: rgba(255,0,0,0.1); margin-top:10px; animation: blink-red 2s infinite;">
                        <div class="zone-title" style="color: #ff4d4d;">⚠️ GRID ALERT: ${a.name}</div>
                        <div style="padding:10px; text-align:center;">
                            <p style="font-size:0.5em; color:#fff;">Targeting ${id}. Threat Level: ${a.threat_lvl}</p>
                            <div style="width:100%; height:5px; background:#222; border-radius:3px; margin:5px 0;">
                                <div style="width:${pct}%; height:100%; background:#ff4d4d;"></div>
                            </div>
                            <button onclick="fightRebel('${id}')" style="width:100%; background:#ff4d4d; color:#fff; border:none; padding:5px; font-weight:bold; font-size:0.6em; border-radius:3px;">SUPPRESS INCURSION</button>
                        </div>
                    </div>
                `;
            }).join('');
            container.innerHTML = alerts || "";
        }
    } catch(e) {}
}

async function fightRebel(sid) {
    const res = await fetch('/api/military/rebellion/suppress', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, sector_id: sid })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { initGame(); loadGridAlerts(); }
}

const oldInit497 = initGame;
initGame = async () => {
    await oldInit497();
    loadGridAlerts();
};
async function loadSanctum() {
    document.getElementById('sanctum-zone').innerHTML = `
        <div class="zone-card" style="border: 2px solid #f1c40f; background: linear-gradient(180deg, #1a1a1a, #000); margin-top:10px;">
            <div class="zone-title" style="color: #f1c40f;">🛡️ ROYAL SANCTUM</div>
            <div style="padding:15px; text-align:center;">
                <p style="font-size:0.55em; color:#aaa;">Elite protection for the Supreme Commander.</p>
                <div style="display:grid; grid-template-columns: 1fr; gap:5px; margin-top:10px;">
                    <button onclick="recruitGuard('praetorian')" style="background:#222; border:1px solid #f1c40f; color:#fff; font-size:0.6em; padding:8px;">RECRUIT PRAETORIAN (100 💎)</button>
                </div>
            </div>
        </div>
    `;
}

async function recruitGuard(type) {
    const res = await fetch('/api/military/guard/recruit', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, guard_type: type })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

const oldInit498 = initGame;
initGame = async () => {
    await oldInit498();
    loadSanctum();
};
async function loadLegacy() {
    try {
        const res = await fetch(`/api/history/legacy/ledger?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            const list = data.ledger.map(entry => `
                <div style="border-left: 2px solid #e67e22; padding-left:10px; margin-bottom:10px;">
                    <small style="color:#888;">${new Date(entry.timestamp * 1000).toLocaleDateString()}</small><br>
                    <b style="color:#fff; font-size:0.7em;">${entry.event}</b><br>
                    <small style="color:#aaa;">${entry.desc}</small>
                </div>
            `).join('') || "No records in the Imperial Archive.";

            document.getElementById('legacy-zone').innerHTML = `
                <div class="zone-card" style="border: 1px solid #e67e22; background: rgba(230, 126, 34, 0.05); margin-top:10px;">
                    <div class="zone-title" style="color: #e67e22;">📜 IMPERIAL CHRONICLES</div>
                    <div style="padding:15px; max-height:200px; overflow-y:auto;">
                        <div style="font-size:0.5em; color:#fff; margin-bottom:10px;">Legacy Score: <b style="color:#f1c40f">${data.score}</b></div>
                        ${list}
                    </div>
                </div>
            `;
        }
    } catch(e) {}
}

const oldInit499 = initGame;
initGame = async () => {
    await oldInit499();
    loadLegacy();
};
async function triggerMilestoneCelebration() {
    console.log("CELEBRATING MILESTONE 500");
    const container = document.getElementById('app-container');
    container.style.transition = "filter 0.5s";
    container.style.filter = "brightness(1.5) contrast(1.2)";
    
    setTimeout(() => {
        container.style.filter = "none";
        alert("🎉 CONGRATULATIONS COMMANDER! THE 500TH MILESTONE IS REACHED.");
    }, 1000);
}

// بروزرسانی اینیت نهایی برای فاز ۵۰۰
const finalInit500 = initGame;
initGame = async () => {
    await finalInit500();
    // نمایش اتوماتیک در اولین ورود به فاز ۵۰۰
    if(!localStorage.getItem('m500_seen')) {
        triggerMilestoneCelebration();
        localStorage.setItem('m500_seen', 'true');
    }
};
async function triggerMilestoneCelebration() {
    console.log("CELEBRATING MILESTONE 500");
    const container = document.getElementById('app-container');
    container.style.transition = "filter 0.5s";
    container.style.filter = "brightness(1.5) contrast(1.2)";
    
    setTimeout(() => {
        container.style.filter = "none";
        alert("🎉 CONGRATULATIONS COMMANDER! THE 500TH MILESTONE IS REACHED.");
    }, 1000);
}

// بروزرسانی اینیت نهایی برای فاز ۵۰۰
const finalInit500 = initGame;
initGame = async () => {
    await finalInit500();
    // نمایش اتوماتیک در اولین ورود به فاز ۵۰۰
    if(!localStorage.getItem('m500_seen')) {
        triggerMilestoneCelebration();
        localStorage.setItem('m500_seen', 'true');
    }
};
async function loadBridge() {
    try {
        const res = await fetch('/api/economy/bridge/status');
        const data = await res.json();
        if(data.success) {
            document.getElementById('bridge-zone').innerHTML = `
                <div class="zone-card" style="border: 2px solid #a8e6cf; background: linear-gradient(135deg, #1a1a1a, #000); margin-top:10px;">
                    <div class="zone-title" style="color: #a8e6cf;">🌌 MULTIVERSE BRIDGE</div>
                    <div style="padding:15px;">
                        <p style="font-size:0.5em; color:#aaa; text-align:center;">Transfer NSM to parallel blockchains.</p>
                        <select id="bridge-net" style="width:100%; background:#000; color:#a8e6cf; border:1px solid #a8e6cf; font-size:0.6em; padding:5px; margin-bottom:5px;">
                            ${Object.keys(data.networks).map(n => `<option value="${n}">${data.networks[n].name}</option>`).join('')}
                        </select>
                        <input id="bridge-addr" type="text" placeholder="Recipient Address" style="width:100%; background:#000; color:#fff; border:1px solid #444; font-size:0.6em; padding:5px; margin-bottom:5px;">
                        <input id="bridge-amt" type="number" placeholder="Amount NSM Hard" style="width:100%; background:#000; color:#fff; border:1px solid #444; font-size:0.6em; padding:5px; margin-bottom:10px;">
                        <button onclick="executeBridge()" style="width:100%; background:#a8e6cf; color:#000; border:none; padding:8px; font-weight:bold; font-size:0.6em; border-radius:3px;">ENGAGE WARP JUMP</button>
                    </div>
                </div>
            `;
        }
    } catch(e) {}
}

async function executeBridge() {
    const net = document.getElementById('bridge-net').value;
    const addr = document.getElementById('bridge-addr').value;
    const amt = document.getElementById('bridge-amt').value;
    
    if(!addr || !amt) return alert("All navigational coordinates required.");

    const res = await fetch('/api/economy/bridge/transfer', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, network: net, amount: amt, address: addr })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت برای لود پل
const originalInit501 = initGame;
initGame = async () => {
    await originalInit501();
    loadBridge();
};
async function checkShardHealth() {
    try {
        const res = await fetch(`/api/system/shard/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            document.getElementById('active-shard').innerText = data.assigned_shard;
            document.getElementById('net-ping').innerText = data.latency_ms + "ms";
        }
    } catch(e) {}
}

const originalInit502 = initGame;
initGame = async () => {
    await originalInit502();
    checkShardHealth();
};
async function loadDevPortal() {
    try {
        const res = await fetch('/api/platform/dev/apps');
        const data = await res.json();
        if(data.success) {
            const apps = Object.keys(data.apps).map(id => {
                const app = data.apps[id];
                return `<div style="background:#111; padding:5px; border-bottom:1px solid #333; font-size:0.55em; display:flex; justify-content:space-between;">
                            <span>${app.name} <small style="color:#666">by ${app.dev}</small></span>
                            <span style="color:#0f0">${app.status}</span>
                        </div>`;
            }).join('');

            document.getElementById('dev-zone').innerHTML = `
                <div class="zone-card" style="border: 2px solid #f1c40f; background: rgba(241, 196, 15, 0.02); margin-top:10px;">
                    <div class="zone-title" style="color: #f1c40f;">🛠️ DEVELOPER HUB</div>
                    <div style="padding:10px;">
                        <div id="dev-app-list" style="margin-bottom:10px;">${apps}</div>
                        <button onclick="registerAsDev()" style="width:100%; background:none; border:1px solid #f1c40f; color:#f1c40f; padding:5px; font-weight:bold; font-size:0.6em; border-radius:3px;">APPLY FOR DEV LICENSE</button>
                    </div>
                </div>
            `;
        }
    } catch(e) {}
}

async function registerAsDev() {
    const res = await fetch('/api/platform/dev/register', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

const originalInit503 = initGame;
initGame = async () => {
    await originalInit503();
    loadDevPortal();
};
async function translateMsg(msgId, text) {
    const userLang = "EN"; // در سیستم واقعی از پروفایل لود می‌شود
    const res = await fetch('/api/social/comms/translate', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ text: text, lang: userLang })
    });
    const data = await res.json();
    if(data.success) {
        alert("TRANSLATED: " + data.translated_text);
    }
}

// بروزرسانی رندرینگ چت برای اضافه کردن دکمه ترجمه
const oldFetchComms = fetchComms;
fetchComms = async () => {
    try {
        const res = await fetch('/api/social/comms/fetch');
        const data = await res.json();
        if(data.success) {
            const feed = document.getElementById('comms-feed');
            feed.innerHTML = data.feed.map(m => `
                <div style="margin-bottom:5px; border-bottom:1px solid #111; padding-bottom:2px;">
                    <div style="display:flex; justify-content:space-between;">
                        <b style="color:#fff; font-size:0.9em;">${m.user}:</b>
                        <button onclick="translateMsg('${m.time}', '${m.text}')" style="background:none; border:1px solid #0f0; color:#0f0; font-size:0.5em; padding:1px 3px; border-radius:2px; cursor:pointer;">TR</button>
                    </div>
                    <span style="color:#0f0; font-size:0.85em;">${m.text}</span>
                </div>
            `).reverse().join('');
        }
    } catch(e) {}
};
async function toggleAR(mode) {
    console.log("SWITCHING AR MODE: " + mode);
    try {
        const res = await fetch('/api/visual/ar/overlay');
        const data = await res.json();
        if(data.success) {
            const overlay = data.overlay;
            // نمایش افکتی بصری بر روی صفحه
            const app = document.getElementById('app-container');
            app.style.boxShadow = mode === 'war' ? "inset 0 0 100px rgba(255,0,0,0.2)" : "inset 0 0 100px rgba(0,255,255,0.1)";
            alert(`AR ACTIVE: ${mode.toUpperCase()} DENSITY SCANNED IN ${overlay.status} STATE.`);
        }
    } catch(e) {}
}

// اضافه کردن دکمه‌های کنترل AR به هدر
const originalInit505 = initGame;
initGame = async () => {
    await originalInit505();
    const header = document.querySelector('.flex.justify-between.items-center');
    if(header && !document.getElementById('ar-controls')) {
        const controls = document.createElement('div');
        controls.id = 'ar-controls';
        controls.innerHTML = `
            <button onclick="toggleAR('wealth')" style="background:none; border:1px solid #00f3ff; color:#00f3ff; font-size:0.4em; padding:2px 5px; margin-right:5px;">AR:WEALTH</button>
            <button onclick="toggleAR('war')" style="background:none; border:1px solid #ff4d4d; color:#ff4d4d; font-size:0.4em; padding:2px 5px;">AR:WAR</button>
        `;
        header.appendChild(controls);
    }
};
async function applyUnificationSeal() {
    console.log("APPLYING THE UNIFICATION SEAL...");
    const brandElements = document.querySelectorAll('.brand-text');
    brandElements.forEach(el => {
        // اگر زبان سیستم فارسی باشد، نام را تغییر بده (ساده‌سازی شده)
        el.innerText = "نصریوم"; 
    });
}

// انیمیشن مهر نهایی در لود اولیه
const originalInit506 = initGame;
initGame = async () => {
    await originalInit506();
    applyUnificationSeal();
    console.log("نصریوم IS READY FOR THE WORLD.");
};
async function loadInsurance() {
    try {
        const res = await fetch(`/api/economy/insurance/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('economy-hub');
            const insuranceCard = `
                <div class="zone-card" style="border: 2px solid #3498db; background: rgba(52, 152, 219, 0.05); margin-top:10px;">
                    <div class="zone-title" style="color: #3498db;">🛡️ SOVEREIGN INSURANCE</div>
                    <div style="padding:10px;">
                        <p style="font-size:0.5em; color:#aaa; text-align:center;">Protect your wealth from raids.</p>
                        <div id="ins-plan-list" style="display:grid; grid-template-columns: 1fr 1fr; gap:5px; margin-top:10px;">
                            ${Object.keys(data.plans).map(id => `
                                <button onclick="buyInsurance('${id}')" style="background:#222; border:1px solid #3498db; color:#fff; font-size:0.5em; padding:5px; border-radius:3px;">
                                    ${data.plans[id].name}<br><small style="color:#0f0">${data.plans[id].coverage*100}% COVER</small>
                                </button>
                            `).join('')}
                        </div>
                    </div>
                </div>
            `;
            if(!document.getElementById('insurance-zone')) {
                const div = document.createElement('div');
                div.id = 'insurance-zone';
                div.innerHTML = insuranceCard;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

async function buyInsurance(pid) {
    const res = await fetch('/api/economy/insurance/subscribe', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, plan_id: pid })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// انتهای اینیت
const oldInit507 = initGame;
initGame = async () => {
    await oldInit507();
    loadInsurance();
};
async function loadLending() {
    try {
        const res = await fetch(`/api/economy/lending/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('economy-hub');
            const lendingCard = `
                <div class="zone-card" style="border: 2px solid #f1c40f; background: rgba(241, 196, 15, 0.05); margin-top:10px;">
                    <div class="zone-title" style="color: #f1c40f;">💰 IMPERIAL CREDIT</div>
                    <div style="padding:10px; text-align:center;">
                        <p style="font-size:0.5em; color:#aaa;">Instant Gold Liquidity based on TH Level.</p>
                        <div style="font-size:0.6em; color:#fff; margin-bottom:5px;">Credit Limit: <b style="color:#f1c40f">${data.limit}</b></div>
                        <input id="loan-amount" type="number" placeholder="Amount" style="width:80%; background:#000; color:#fff; border:1px solid #444; font-size:0.6em; padding:5px; margin-bottom:5px;">
                        <button onclick="requestLoan()" style="width:100%; background:#f1c40f; color:#000; border:none; padding:5px; font-weight:bold; font-size:0.6em; border-radius:3px;">REQUEST LOAN</button>
                    </div>
                </div>
            `;
            if(!document.getElementById('lending-zone')) {
                const div = document.createElement('div');
                div.id = 'lending-zone';
                div.innerHTML = lendingCard;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

async function requestLoan() {
    const amt = document.getElementById('loan-amount').value;
    const res = await fetch('/api/economy/lending/request', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, amount: amt })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// انتهای اینیت
const oldInit508 = initGame;
initGame = async () => {
    await oldInit508();
    loadLending();
};
async function loadBondMarket() {
    try {
        const res = await fetch('/api/social/bonds/market');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('federal-treasury-zone');
            if(!container) return;

            const bondHtml = Object.keys(data.bonds).map(id => {
                const b = data.bonds[id];
                const progress = (b.sold / b.volume) * 100;
                return `
                    <div style="background:#111; padding:8px; border:1px solid #2ecc71; border-radius:5px; margin-top:5px;">
                        <div style="display:flex; justify-content:space-between; font-size:0.6em; color:#fff;">
                            <b>${b.issuer} BOND</b>
                            <span style="color:#2ecc71">+${b.interest*100}% Yield</span>
                        </div>
                        <div style="width:100%; height:4px; background:#222; margin:5px 0;">
                            <div style="width:${progress}%; height:100%; background:#2ecc71;"></div>
                        </div>
                        <button onclick="buyBond('${id}')" style="width:100%; background:#2ecc71; color:#000; border:none; font-size:0.5em; font-weight:bold; padding:3px;">INVEST NSM</button>
                    </div>
                `;
            }).join('');

            const marketDiv = document.createElement('div');
            marketDiv.id = 'bond-market-display';
            marketDiv.innerHTML = `<h4 style="color:#2ecc71; font-size:0.6em; margin-top:10px;">ACTIVE BONDS</h4>` + bondHtml;
            container.appendChild(marketDiv);
        }
    } catch(e) {}
}

async function buyBond(bid) {
    const amt = prompt("Enter NSM amount to invest in this Federation:");
    if(!amt) return;
    const res = await fetch('/api/social/bonds/buy', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, bond_id: bid, amount: amt })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit509 = initGame;
initGame = async () => {
    await oldInit509();
    loadBondMarket();
};
async function loadDerivatives() {
    try {
        const res = await fetch('/api/economy/derivatives/market');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('economy-hub');
            const marketHtml = Object.keys(data.market).map(id => {
                const c = data.market[id];
                return `
                    <div style="background:#111; padding:8px; border-left:3px solid #ff4757; border-radius:5px; margin-top:5px; display:flex; justify-content:space-between; align-items:center;">
                        <div style="font-size:0.55em; color:#fff;">
                            <b>${c.title}</b><br>
                            <small style="color:#aaa">Pool: ${c.total_bets.toLocaleString()} NSM</small>
                        </div>
                        <button onclick="predictEvent('${id}')" style="background:#ff4757; color:#fff; border:none; font-size:0.7em; font-weight:bold; padding:5px 10px; border-radius:3px;">
                            x${c.odds}
                        </button>
                    </div>
                `;
            }).join('');

            if(!document.getElementById('derivatives-zone')) {
                const div = document.createElement('div');
                div.id = 'derivatives-zone';
                div.className = "zone-card";
                div.style.border = "2px solid #ff4757";
                div.style.background = "rgba(255, 71, 87, 0.05)";
                div.style.marginTop = "10px";
                div.innerHTML = `<div class="zone-title" style="color:#ff4757;">📈 IMPERIAL ODDS</div><div style="padding:10px;">${marketHtml}</div>`;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

async function predictEvent(cid) {
    const amt = prompt("Enter prediction amount (NSM):");
    if(!amt) return;
    const res = await fetch('/api/economy/derivatives/predict', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, contract_id: cid, amount: amt })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit510 = initGame;
initGame = async () => {
    await oldInit510();
    loadDerivatives();
};
