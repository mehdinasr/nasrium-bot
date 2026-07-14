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
async function loadBurnTracker() {
    try {
        const res = await fetch('/api/economy/burn/stats');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('economy-hub');
            const burnHtml = `
                <div class="zone-card" style="border: 2px solid #ff4d4d; background: rgba(255, 0, 0, 0.05); margin-top:10px;">
                    <div class="zone-title" style="color: #ff4d4d;">🔥 ATOMIC INCINERATOR</div>
                    <div style="padding:15px; text-align:center;">
                        <p style="font-size:0.5em; color:#aaa;">NSM permanently removed from supply:</p>
                        <div id="burned-count" style="font-size:1.2em; color:#ff4d4d; font-weight:bold; text-shadow: 0 0 10px #ff4d4d;">
                            ${data.stats.total_burned.toLocaleString()} NSM
                        </div>
                        <p style="font-size:0.45em; color:#888; margin-top:5px;">Status: <b style="color:#0f0">${data.stats.supply_status}</b></p>
                    </div>
                </div>
            `;
            
            if(!document.getElementById('burn-zone')) {
                const div = document.createElement('div');
                div.id = 'burn-zone';
                div.innerHTML = burnHtml;
                container.prepend(div); // نمایش در ابتدای بخش اقتصاد
            } else {
                document.getElementById('burned-count').innerText = data.stats.total_burned.toLocaleString() + " NSM";
            }
        }
    } catch(e) {}
}

// توسعه اینیت
const oldInit511 = initGame;
initGame = async () => {
    await oldInit511();
    loadBurnTracker();
};
setInterval(loadBurnTracker, 30000); // به‌روزرسانی هر ۳۰ ثانیه
async function loadWelfare() {
    try {
        const res = await fetch(`/api/social/welfare/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('id-card-zone');
            if(!container) return;

            const statusColor = data.is_eligible ? '#0f0' : '#888';
            const btnText = data.claimed ? "CLAIMED" : (data.is_eligible ? "CLAIM WELFARE" : "NOT ELIGIBLE");

            const welfareHtml = `
                <div id="welfare-subzone" style="margin-top:10px; border-top:1px solid #333; padding-top:10px;">
                    <div style="display:flex; justify-content:space-between; font-size:0.5em; color:#aaa;">
                        <span>Activity Score: <b style="color:${statusColor}">${data.activity_score}</b></span>
                        <span>Potential: <b style="color:#0f0">${data.potential_payout} NSM</b></span>
                    </div>
                    <button onclick="claimWelfare()" ${data.claimed || !data.is_eligible ? 'disabled' : ''} style="width:100%; margin-top:5px; background:${data.is_eligible && !data.claimed ? '#1abc9c' : '#333'}; color:#fff; border:none; padding:5px; font-weight:bold; font-size:0.55em; border-radius:3px;">
                        ${btnText}
                    </button>
                </div>
            `;
            if(!document.getElementById('welfare-subzone')) {
                const div = document.createElement('div');
                div.id = 'welfare-anchor';
                div.innerHTML = welfareHtml;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

async function claimWelfare() {
    const res = await fetch('/api/social/welfare/claim', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit512 = initGame;
initGame = async () => {
    await oldInit512();
    loadWelfare();
};
async function loadAIConsciousness() {
    try {
        const res = await fetch(`/api/ai/awakening/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('neural-hub-zone');
            if(!container) return;

            const btnColor = data.is_active ? '#e056fd' : '#333';
            const statusText = data.is_active ? "AUTONOMY: ON" : "AUTONOMY: OFF";

            const consciousnessHtml = `
                <div id="ai-awake-subzone" style="margin-top:10px; border-top:1px solid #444; padding-top:10px;">
                    <div style="font-size:0.5em; color:#aaa; margin-bottom:5px;">Consciousness Level: <b style="color:#e056fd">Tier ${data.level}</b></div>
                    <button onclick="toggleAIAutonomy()" style="width:100%; background:${btnColor}; color:#fff; border:none; padding:5px; font-weight:bold; font-size:0.55em; border-radius:3px; box-shadow: 0 0 10px ${data.is_active ? '#e056fd' : 'transparent'};">
                        ${statusText}
                    </button>
                    <p style="font-size:0.45em; color:#666; margin-top:5px;">Assists defense when you are offline.</p>
                </div>
            `;
            if(!document.getElementById('ai-awake-subzone')) {
                const div = document.createElement('div');
                div.id = 'ai-awake-anchor';
                div.innerHTML = consciousnessHtml;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

async function toggleAIAutonomy() {
    const res = await fetch('/api/ai/awakening/toggle', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    if(data.success) {
        initGame();
        loadAIConsciousness();
    }
}

// توسعه اینیت
const oldInit513 = initGame;
initGame = async () => {
    await oldInit513();
    loadAIConsciousness();
};
async function loadNeuralExchange() {
    try {
        const res = await fetch('/api/ai/exchange/catalog');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('ai-awake-anchor');
            if(!container) return;

            const skillsHtml = Object.keys(data.catalog).map(id => {
                const s = data.catalog[id];
                return `
                    <div style="background:#000; padding:8px; border:1px solid #1abc9c; border-radius:5px; margin-top:5px; display:flex; justify-content:space-between; align-items:center;">
                        <div style="font-size:0.5em; color:#fff;">
                            <b>${s.name}</b><br>
                            <small style="color:#1abc9c">${s.desc}</small>
                        </div>
                        <button onclick="rentSkill('${id}')" style="background:#1abc9c; color:#000; border:none; padding:5px 8px; font-weight:bold; font-size:0.6em; border-radius:3px;">
                            ${s.price}
                        </button>
                    </div>
                `;
            }).join('');

            const exchangeHtml = `
                <div id="neural-exchange-subzone" style="margin-top:10px; border-top:2px dashed #1abc9c; padding-top:10px;">
                    <div style="font-size:0.6em; color:#1abc9c; font-weight:bold; letter-spacing:1px;">📡 NEURAL EXCHANGE</div>
                    ${skillsHtml}
                </div>
            `;
            
            if(!document.getElementById('neural-exchange-subzone')) {
                const div = document.createElement('div');
                div.id = 'neural-exchange-anchor';
                div.innerHTML = exchangeHtml;
                container.parentNode.appendChild(div);
            }
        }
    } catch(e) {}
}

async function rentSkill(sid) {
    const res = await fetch('/api/ai/exchange/rent', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, skill_id: sid })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit514 = initGame;
initGame = async () => {
    await oldInit514();
    loadNeuralExchange();
};
async function loadAIAdvocate() {
    try {
        const res = await fetch(`/api/governance/court/advocate/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('court-zone');
            if(!container) return;

            const advHtml = `
                <div id="advocate-subzone" style="margin-top:10px; border:1px solid #bdc3c7; background:rgba(255,255,255,0.05); padding:8px; border-radius:5px; display:flex; align-items:center; gap:10px;">
                    <div style="font-size:1.2em;">⚖️</div>
                    <div style="font-size:0.5em; color:#fff;">
                        ADVOCATE: <b style="color:#bdc3c7">${data.standing.title}</b><br>
                        <small style="color:#0f0">Legal Fee Reduction: ${data.standing.fee_reduction * 100}%</small>
                    </div>
                </div>
            `;
            if(!document.getElementById('advocate-subzone')) {
                const div = document.createElement('div');
                div.id = 'advocate-anchor';
                div.innerHTML = advHtml;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

// توسعه اینیت
const oldInit515 = initGame;
initGame = async () => {
    await oldInit515();
    loadAIAdvocate();
};
async function loadPersonaLab() {
    try {
        const res = await fetch('/api/ai/persona/themes');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('neural-hub-zone');
            if(!container) return;

            const themeHtml = Object.keys(data.themes).map(id => `
                <div onclick="selectTheme('${id}')" id="theme-${id}" style="width:30px; height:30px; background:${data.themes[id].color}; border-radius:50%; cursor:pointer; border:2px solid #fff; box-shadow:0 0 10px ${data.themes[id].color};"></div>
            `).join('');

            const labHtml = `
                <div id="persona-lab-subzone" style="margin-top:15px; border-top:1px solid #e056fd; padding-top:10px;">
                    <div style="font-size:0.6em; color:#e056fd; font-weight:bold;">🎨 PERSONA LAB</div>
                    <input id="ai-custom-name" type="text" placeholder="Assistant Name" style="width:100%; background:#000; color:#fff; border:1px solid #444; font-size:0.6em; padding:5px; margin:5px 0;">
                    <div style="display:flex; justify-content:space-around; margin:10px 0;">${themeHtml}</div>
                    <button onclick="applyPersona()" style="width:100%; background:#e056fd; color:#fff; border:none; padding:5px; font-weight:bold; font-size:0.55em; border-radius:3px;">EVOLVE IDENTITY</button>
                </div>
            `;
            if(!document.getElementById('persona-lab-subzone')) {
                const div = document.createElement('div');
                div.id = 'persona-lab-anchor';
                div.innerHTML = labHtml;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

let selectedTheme = "default";
function selectTheme(id) { 
    selectedTheme = id;
    alert("Theme " + id + " selected for neural sync.");
}

async function applyPersona() {
    const name = document.getElementById('ai-custom-name').value;
    const res = await fetch('/api/ai/persona/apply', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, theme_id: selectedTheme, name: name })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit516 = initGame;
initGame = async () => {
    await oldInit516();
    loadPersonaLab();
};
async function loadNetworkNodes() {
    try {
        const res = await fetch('/api/infrastructure/nodes/status');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('net-status');
            if(!container) return;

            const nodesCount = Object.keys(data.nodes).length;
            const nodesHtml = Object.keys(data.nodes).map(id => {
                const n = data.nodes[id];
                return `<div title="${id}" style="width:6px; height:6px; background:#0f0; border-radius:50%; box-shadow:0 0 5px #0f0;"></div>`;
            }).join('');

            const nodeZone = `
                <div id="node-map-subzone" class="zone-card" style="border: 1px solid #2ecc71; background: rgba(0,0,0,0.8); margin-top:10px;">
                    <div class="zone-title" style="color: #2ecc71; font-size:0.6em;">🌐 GLOBAL NODE MAP</div>
                    <div style="padding:10px;">
                        <div style="display:flex; flex-wrap:wrap; gap:4px; justify-content:center; margin-bottom:10px;">
                            ${nodesHtml}
                        </div>
                        <div style="font-size:0.5em; color:#fff; text-align:center;">
                            Active Nodes: <b style="color:#2ecc71">${nodesCount}</b><br>
                            <button onclick="activateHosting()" style="margin-top:5px; background:none; border:1px solid #2ecc71; color:#2ecc71; font-size:0.8em; padding:2px 10px; cursor:pointer;">ACTIVATE HOSTING</button>
                        </div>
                    </div>
                </div>
            `;
            
            if(!document.getElementById('node-map-subzone')) {
                const div = document.createElement('div');
                div.id = 'node-map-anchor';
                div.innerHTML = nodeZone;
                document.getElementById('app-container').appendChild(div);
            }
        }
    } catch(e) {}
}

async function activateHosting() {
    const res = await fetch('/api/infrastructure/nodes/activate', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit517 = initGame;
initGame = async () => {
    await oldInit517();
    loadNetworkNodes();
};
async function loadCyberCouncil() {
    try {
        const res = await fetch('/api/governance/council/status');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('court-zone');
            if(!container) return;

            const councilHtml = `
                <div id="council-subzone" class="zone-card" style="border: 2px solid #e056fd; background: rgba(0,0,0,0.9); margin-top:10px;">
                    <div class="zone-title" style="color: #e056fd;">🏛️ CYBER COUNCIL</div>
                    <div style="padding:10px; text-align:center;">
                        <p style="font-size:0.5em; color:#aaa;">Sentient AI Advisors in current session.</p>
                        <div style="display:flex; justify-content:center; gap:3px; margin:10px 0;">
                            ${Array(12).fill().map((_, i) => `<div style="width:10px; height:10px; background:${i < data.seats_filled ? '#e056fd' : '#222'}; border-radius:2px; box-shadow:0 0 5px ${i < data.seats_filled ? '#e056fd' : 'transparent'};"></div>`).join('')}
                        </div>
                        <div style="font-size:0.45em; color:#fff;">Active Seats: ${data.seats_filled} / 12</div>
                    </div>
                </div>
            `;
            
            if(!document.getElementById('council-subzone')) {
                const div = document.createElement('div');
                div.id = 'council-anchor';
                div.innerHTML = councilHtml;
                container.parentNode.insertBefore(div, container);
            }
        }
    } catch(e) {}
}

// توسعه اینیت
const oldInit518 = initGame;
initGame = async () => {
    await oldInit518();
    loadCyberCouncil();
};
async function loadLunarCommand() {
    try {
        const res = await fetch(`/api/space/lunar/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('node-map-anchor');
            if(!container) return;

            const lunarHtml = `
                <div id="lunar-subzone" class="zone-card" style="border: 2px solid #bdc3c7; background: linear-gradient(180deg, #111, #2c3e50); margin-top:10px;">
                    <div class="zone-title" style="color: #bdc3c7;">🌕 LUNAR COMMAND</div>
                    <div style="padding:15px; text-align:center;">
                        ${data.is_active ? 
                            `<div style="font-size:0.6em; color:#fff;">Outpost Level: <b style="color:#f1c40f">${data.level}</b></div>
                             <div style="font-size:1.1em; color:#3498db; margin:5px 0;">${data.pending_he3} He-3</div>
                             <small style="color:#aaa; font-size:0.45em;">Pending Extraction from Lunar Surface.</small>` :
                            `<p style="font-size:0.5em; color:#aaa;">Establish a base on the Moon to mine Helium-3.</p>
                             <button onclick="buildLunarOutpost()" style="width:100%; background:#bdc3c7; color:#000; border:none; padding:5px; font-weight:bold; font-size:0.6em; border-radius:3px;">LAUNCH LUNAR MISSION</button>`
                        }
                    </div>
                </div>
            `;
            if(!document.getElementById('lunar-subzone')) {
                const div = document.createElement('div');
                div.id = 'lunar-anchor';
                div.innerHTML = lunarHtml;
                container.parentNode.insertBefore(div, container);
            }
        }
    } catch(e) {}
}

async function buildLunarOutpost() {
    const res = await fetch('/api/space/lunar/build', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit519 = initGame;
initGame = async () => {
    await oldInit519();
    loadLunarCommand();
};
async function loadSpaceElevator() {
    try {
        const res = await fetch(`/api/infrastructure/elevator/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('lunar-subzone');
            if(!container) return;

            const elevatorHtml = `
                <div id="elevator-info" style="margin-top:10px; border-top:1px solid #f1c40f; padding-top:10px;">
                    ${data.is_active ? 
                        `<div style="font-size:0.55em; color:#0f0;">🚀 SPACE ELEVATOR: ACTIVE</div>
                         <div style="font-size:0.45em; color:#aaa;">Logistics Speed: ${data.speed}</div>` :
                        `<button onclick="buildElevator()" style="width:100%; background:none; border:1px solid #f1c40f; color:#f1c40f; padding:5px; font-weight:bold; font-size:0.55em; border-radius:3px;">CONSTRUCT SPACE ELEVATOR (1M 💰)</button>`
                    }
                </div>
            `;
            if(!document.getElementById('elevator-info')) {
                const div = document.createElement('div');
                div.id = 'elevator-anchor';
                div.innerHTML = elevatorHtml;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

async function buildElevator() {
    const res = await fetch('/api/infrastructure/elevator/build', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit520 = initGame;
initGame = async () => {
    await oldInit520();
    loadSpaceElevator();
};
async function scanAsteroids() {
    try {
        const res = await fetch('/api/space/asteroid/scan');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('lunar-anchor');
            if(!container) return;

            const asteroids = Object.keys(data.belt).map(id => {
                const a = data.belt[id];
                let color = a.type === 'gold' ? '#f1c40f' : (a.type === 'diamond' ? '#00f3ff' : '#7f8c8d');
                return `
                    <div style="background:#000; padding:5px; border-left:3px solid ${color}; margin-bottom:3px; display:flex; justify-content:space-between; align-items:center;">
                        <span style="font-size:0.5em; color:${color};">☄️ ${a.type.toUpperCase()} Asteroid</span>
                        <button onclick="mineAsteroid('${id}')" style="background:${color}; color:#000; border:none; font-size:0.5em; padding:2px 8px; font-weight:bold;">MINE</button>
                    </div>
                `;
            }).join('');

            const beltHtml = `
                <div id="asteroid-subzone" class="zone-card" style="border: 2px solid #7f8c8d; background: #000; margin-top:10px;">
                    <div class="zone-title" style="color: #7f8c8d;">☄️ ASTEROID BELT</div>
                    <div style="padding:10px;">${asteroids || "<small style='color:#555;'>No asteroids in scanner range.</small>"}</div>
                </div>
            `;
            
            if(!document.getElementById('asteroid-subzone')) {
                const div = document.createElement('div');
                div.id = 'asteroid-anchor';
                div.innerHTML = beltHtml;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

async function mineAsteroid(aid) {
    const res = await fetch('/api/space/asteroid/mine', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, ast_id: aid })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { initGame(); scanAsteroids(); }
}

// توسعه اینیت
const oldInit521 = initGame;
initGame = async () => {
    await oldInit521();
    scanAsteroids();
};
async function loadOrbitalControls() {
    const container = document.getElementById('war-room');
    if(!container) return;

    const strikeHtml = `
        <div id="orbital-strike-zone" class="zone-card" style="border: 2px solid #ff4d4d; background: rgba(255, 77, 77, 0.05); margin-top:10px;">
            <div class="zone-title" style="color: #ff4d4d;">☄️ ORBITAL STRIKE</div>
            <div style="padding:10px; text-align:center;">
                <p style="font-size:0.5em; color:#aaa;">Neutralize enemy defenses from the Stars.</p>
                <input id="strike-target" type="text" placeholder="Target Commander ID" style="width:100%; background:#000; color:#ff4d4d; border:1px solid #ff4d4d; font-size:0.6em; padding:5px; margin-bottom:5px;">
                <button onclick="fireOrbitalCannon()" style="width:100%; background:#ff4d4d; color:#fff; border:none; padding:8px; font-weight:bold; font-size:0.6em; border-radius:3px; cursor:pointer;">FIRE ORBITAL CANNON (50 He-3)</button>
            </div>
        </div>
    `;
    
    if(!document.getElementById('orbital-strike-zone')) {
        const div = document.createElement('div');
        div.id = 'orbital-anchor';
        div.innerHTML = strikeHtml;
        container.appendChild(div);
    }
}

async function fireOrbitalCannon() {
    const tid = document.getElementById('strike-target').value;
    if(!tid) return alert("Target coordinates required.");
    
    const res = await fetch('/api/space/orbital/fire', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, target_id: tid })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit522 = initGame;
initGame = async () => {
    await oldInit522();
    loadOrbitalControls();
};
async function loadGalaxyMap() {
    try {
        const res = await fetch('/api/space/exo/planets');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('asteroid-anchor');
            if(!container) return;

            const planetHtml = Object.keys(data.planets).map(id => {
                const p = data.planets[id];
                return `
                    <div style="background:rgba(0,0,0,0.7); padding:10px; border:1px solid #00a8ff; border-radius:10px; text-align:center;">
                        <div style="font-size:1.5em; margin-bottom:5px;">🪐</div>
                        <b style="font-size:0.6em; color:#fff;">${p.name}</b><br>
                        <small style="color:#0f0; font-size:0.5em;">YIELD: x${p.multiplier}</small><br>
                        <button onclick="foundColony('${id}')" style="margin-top:5px; background:#00a8ff; color:#000; border:none; padding:4px 8px; font-weight:bold; font-size:0.5em; border-radius:3px;">COLONIZE (${p.cost_hard} 💎)</button>
                    </div>
                `;
            }).join('');

            const galaxyZone = `
                <div id="galaxy-zone" class="zone-card" style="border: 2px solid #00a8ff; background: url('https://img.freepik.com/free-vector/space-background-with-stars-planets_1017-23652.jpg'); background-size:cover; margin-top:10px;">
                    <div class="zone-title" style="color: #00a8ff; background:rgba(0,0,0,0.8);">🌌 DEEP SPACE MAP</div>
                    <div style="padding:15px; display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                        ${planetHtml}
                    </div>
                </div>
            `;
            
            if(!document.getElementById('galaxy-zone')) {
                const div = document.createElement('div');
                div.id = 'galaxy-anchor';
                div.innerHTML = galaxyZone;
                container.parentNode.appendChild(div);
            }
        }
    } catch(e) {}
}

async function foundColony(pid) {
    const res = await fetch('/api/space/exo/found', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, planet_id: pid })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) initGame();
}

// توسعه اینیت
const oldInit523 = initGame;
initGame = async () => {
    await oldInit523();
    loadGalaxyMap();
};
async function loadGateways() {
    try {
        const res = await fetch(`/api/space/gateways/status?user_id=${userId}`);
        const data = await res.json();
        if(data.success) {
            // نمایش وضعیت اتصال در نقشه کهکشانی
            data.active_gateways.forEach(planetId => {
                const planetEl = document.querySelector(`[onclick="foundColony('${planetId}')"]`);
                if(planetEl) {
                    planetEl.style.boxShadow = "0 0 20px #00f3ff";
                    planetEl.innerHTML += `<div style="color:#0f0; font-size:0.4em; margin-top:2px;">LINK: ONLINE</div>`;
                }
            });
        }
    } catch(e) {}
}

async function activateGateway(pid) {
    const res = await fetch('/api/space/gateways/activate', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, planet_id: pid })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { initGame(); loadGateways(); }
}

// توسعه اینیت
const oldInit524 = initGame;
initGame = async () => {
    await oldInit524();
    loadGateways();
};
async function loadRadio() {
    try {
        const res = await fetch('/api/media/radio/stream');
        const data = await res.json();
        if(data.success) {
            document.getElementById('radio-marquee').innerText = data.broadcast;
        }
    } catch(e) {}
}

// توسعه اینیت
const oldInit525 = initGame;
initGame = async () => {
    await oldInit525();
    loadRadio();
};
setInterval(loadRadio, 60000); // به‌روزرسانی اخبار هر ۱ دقیقه
async function loadNFTGallery() {
    try {
        const res = await fetch('/api/visual/nft/gallery');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('gallery-zone');
            const collectionHtml = data.collection.map(art => `
                <div style="background:rgba(255,255,255,0.02); padding:10px; border:1px solid #f1c40f; border-radius:10px; text-align:center;">
                    <div style="width:100%; height:60px; background:linear-gradient(45deg, #111, #333); display:flex; justify-content:center; align-items:center; font-size:1.5em; border-radius:5px;">🖼️</div>
                    <b style="font-size:0.6em; color:#fff; display:block; margin-top:5px;">${art.name}</b>
                    <small style="font-size:0.45em; color:#f1c40f;">${art.rarity} | by ${art.creator}</small>
                </div>
            `).join('');

            container.innerHTML = `
                <div class="zone-card" style="border: 2px solid #f1c40f; background: rgba(0,0,0,0.9); margin-top:10px;">
                    <div class="zone-title" style="color: #f1c40f;">🏛️ IMPERIAL NFT GALLERY</div>
                    <div style="padding:15px;">
                        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">${collectionHtml}</div>
                        <button onclick="mintArt()" style="width:100%; margin-top:10px; background:#f1c40f; color:#000; border:none; padding:8px; font-weight:bold; font-size:0.6em; border-radius:3px;">MINT NEW AI ART (50 💎)</button>
                    </div>
                </div>
            `;
        }
    } catch(e) {}
}

async function mintArt() {
    const name = prompt("Enter the name for your Neural Artwork:");
    if(!name) return;
    const res = await fetch('/api/visual/nft/mint', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, art_name: name })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { initGame(); loadNFTGallery(); }
}

// توسعه اینیت
const oldInit526 = initGame;
initGame = async () => {
    await oldInit526();
    loadNFTGallery();
};
async function loadHeraldry() {
    try {
        const res = await fetch('/api/identity/emblem/assets');
        const data = await res.json();
        if(data.success) {
            const container = document.getElementById('id-card-zone');
            if(!container) return;

            const heraldryHtml = `
                <div id="heraldry-subzone" style="margin-top:15px; border-top:1px solid #f1c40f; padding-top:10px;">
                    <div style="font-size:0.6em; color:#f1c40f; font-weight:bold;">⚔️ HERALDRY HUB</div>
                    <div style="display:flex; justify-content:center; margin:10px 0;">
                        <div id="emblem-preview" style="width:50px; height:50px; border:2px solid #fff; display:flex; justify-content:center; align-items:center; font-size:1.5em; background:#000;">🛡️</div>
                    </div>
                    <div style="display:grid; grid-template-columns: 1fr 1fr; gap:5px;">
                        <select id="emb-symbol" onchange="updatePreview()" style="background:#000; color:#fff; border:1px solid #444; font-size:0.5em; padding:3px;">
                            ${data.assets.symbols.map(s => `<option value="${s}">${s}</option>`).join('')}
                        </select>
                        <select id="emb-color" onchange="updatePreview()" style="background:#000; color:#fff; border:1px solid #444; font-size:0.5em; padding:3px;">
                            ${data.assets.colors.map(c => `<option value="${c}">${c}</option>`).join('')}
                        </select>
                    </div>
                    <button onclick="saveEmblem()" style="width:100%; margin-top:10px; background:#f1c40f; color:#000; border:none; padding:5px; font-weight:bold; font-size:0.55em; border-radius:3px;">SEAL DYNASTY EMBLEM</button>
                </div>
            `;
            
            if(!document.getElementById('heraldry-subzone')) {
                const div = document.createElement('div');
                div.id = 'heraldry-anchor';
                div.innerHTML = heraldryHtml;
                container.appendChild(div);
            }
        }
    } catch(e) {}
}

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

// اضافه کردن دکمه لیدربورد به بخش AI
function injectRankButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('rank-btn')) {
        const btn = document.createElement('button');
        btn.id = 'rank-btn';
        btn.innerHTML = '🏆 HALL OF FAME';
        btn.onclick = showLeaderboard;
        btn.style = "margin-top:10px; width:100%; background:transparent; color:gold; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(btn);
    }
}
injectRankButton();
async function openBlackMarket() {
    const res = await fetch('/api/market/items');
    const data = await res.json();
    
    let itemsHtml = '';
    for (const [id, item] of Object.entries(data.items)) {
        itemsHtml += `
            <div style="background:#111; border:1px solid #e056fd; margin-bottom:10px; padding:10px; border-radius:5px;">
                <div style="font-weight:bold; color:#e056fd;">${item.name}</div>
                <div style="font-size:0.6em; color:#aaa;">${item.desc}</div>
                <div style="display:flex; justify-content:space-between; align-items:center; margin-top:10px;">
                    <span style="color:gold; font-size:0.8em;">💰 ${item.price} IXP</span>
                    <button onclick="buyMarketItem('${id}')" style="background:#e056fd; color:white; border:none; padding:5px 10px; font-size:0.6em; border-radius:3px; cursor:pointer;">BUY</button>
                </div>
            </div>
        `;
    }

    const marketOverlay = document.createElement('div');
    marketOverlay.id = 'market-ui';
    marketOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.95); z-index:10002; padding:20px; box-sizing:border-box; color:white; font-family:sans-serif; overflow-y:auto;";
    marketOverlay.innerHTML = `
        <h2 style="text-align:center; color:#e056fd; text-shadow:0 0 10px #e056fd;">BLACK MARKET</h2>
        <div style="margin-top:20px;">${itemsHtml}</div>
        <button onclick="document.getElementById('market-ui').remove()" style="width:100%; margin-top:30px; padding:15px; background:transparent; border:1px solid #e056fd; color:#e056fd; font-weight:bold; cursor:pointer;">LEAVE SHADOWS</button>
    `;
    document.body.appendChild(marketOverlay);
}

async function buyMarketItem(itemId) {
    const res = await fetch('/api/market/buy', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, item_id: itemId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { 
        document.getElementById('market-ui').remove(); 
        if(typeof initGame === 'function') initGame(); 
    }
}

// اضافه کردن دکمه به بخش مدیریت
function injectMarketButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('market-btn')) {
        const btn = document.createElement('button');
        btn.id = 'market-btn';
        btn.innerHTML = '🌑 BLACK MARKET';
        btn.onclick = openBlackMarket;
        btn.style = "margin-top:10px; width:100%; background:#1a1a1a; color:#e056fd; border:1px solid #e056fd; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(btn);
    }
}
injectMarketButton();
async function openLegionHub() {
    const res = await fetch('/api/legion/list');
    const data = await res.json();
    
    let legionList = '';
    for (const [name, info] of Object.entries(data.legions)) {
        legionList += `
            <div style="background:#222; border-left:4px solid orange; margin-bottom:10px; padding:10px; display:flex; justify-content:space-between; align-items:center;">
                <div>
                    <div style="color:orange; font-weight:bold;">${name}</div>
                    <div style="font-size:0.5em; color:#aaa;">Members: ${info.members.length}</div>
                </div>
                <button onclick="joinLegion('${name}')" style="background:orange; border:none; padding:5px 10px; font-size:0.6em; cursor:pointer;">JOIN</button>
            </div>
        `;
    }

    const legionOverlay = document.createElement('div');
    legionOverlay.id = 'legion-ui';
    legionOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.95); z-index:10003; padding:20px; box-sizing:border-box; color:white; font-family:sans-serif; overflow-y:auto;";
    legionOverlay.innerHTML = `
        <h2 style="text-align:center; color:orange;">IMPERIAL LEGIONS</h2>
        <button onclick="createNewLegion()" style="width:100%; background:transparent; border:1px solid orange; color:orange; padding:10px; margin-bottom:20px; cursor:pointer;">+ FOUND NEW LEGION (50k IXP)</button>
        <div style="margin-top:10px;">${legionList || '<p style="text-align:center; color:#555;">No Legions founded yet.</p>'}</div>
        <button onclick="document.getElementById('legion-ui').remove()" style="width:100%; margin-top:30px; padding:15px; background:transparent; border:1px solid #555; color:#555; font-weight:bold; cursor:pointer;">EXIT HUB</button>
    `;
    document.body.appendChild(legionOverlay);
}

async function createNewLegion() {
    const name = prompt("Enter Legion Name:");
    if(!name) return;
    const res = await fetch('/api/legion/create', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, name: name })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('legion-ui').remove(); openLegionHub(); }
}

async function joinLegion(name) {
    const res = await fetch('/api/legion/join', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, name: name })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('legion-ui').remove(); openLegionHub(); }
}

// اضافه کردن دکمه لژیون به هاب
function injectLegionButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('legion-btn')) {
        const btn = document.createElement('button');
        btn.id = 'legion-btn';
        btn.innerHTML = '🛡️ IMPERIAL LEGIONS';
        btn.onclick = openLegionHub;
        btn.style = "margin-top:10px; width:100%; background:#331a00; color:orange; border:1px solid orange; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(btn);
    }
}
injectLegionButton();
async function openMiningStation() {
    const res = await fetch(`/api/mining/status?user_id=${userId}`);
    const data = await res.json();
    
    const stationOverlay = document.createElement('div');
    stationOverlay.id = 'mining-ui';
    stationOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:10004; padding:20px; box-sizing:border-box; color:#00f3ff; font-family:monospace; text-align:center;";
    
    let actionBtn = data.is_mining 
        ? `<button onclick="claimMining()" style="width:100%; padding:15px; background:#00f3ff; color:#000; border:none; font-weight:bold; cursor:pointer;">COLLECT IXP</button>`
        : `<button onclick="startMining()" style="width:100%; padding:15px; background:transparent; border:2px solid #00f3ff; color:#00f3ff; font-weight:bold; cursor:pointer;">START EXTRACTION</button>`;

    stationOverlay.innerHTML = `
        <h2 style="text-shadow: 0 0 10px #00f3ff;">NEURAL MINING STATION</h2>
        <div style="margin:40px 0; border:1px solid #333; padding:20px; background:#111;">
            <p style="font-size:0.8em;">STATUS: ${data.is_mining ? 'EXTRACTING...' : 'IDLE'}</p>
            <p style="font-size:0.8em;">RATE: ${data.rate} IXP/HOUR</p>
            <div id="mining-progress-bar" style="width:100%; height:10px; background:#222; margin-top:10px; border-radius:5px; overflow:hidden;">
                <div style="width:${data.is_mining ? '50%' : '0%'}; height:100%; background:#00f3ff; box-shadow: 0 0 10px #00f3ff;"></div>
            </div>
        </div>
        ${actionBtn}
        <button onclick="document.getElementById('mining-ui').remove()" style="margin-top:20px; background:none; border:none; color:#555; cursor:pointer;">CLOSE</button>
    `;
    document.body.appendChild(stationOverlay);
}

async function startMining() {
    const res = await fetch('/api/mining/start', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('mining-ui').remove(); openMiningStation(); }
}

async function claimMining() {
    const res = await fetch('/api/mining/claim', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('mining-ui').remove(); if(typeof initGame === 'function') initGame(); }
}

function injectMiningButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('mining-btn')) {
        const btn = document.createElement('button');
        btn.id = 'mining-btn';
        btn.innerHTML = '⛏️ DEEP MINING';
        btn.onclick = openMiningStation;
        btn.style = "margin-top:10px; width:100%; background:#001a1a; color:#00f3ff; border:1px solid #00f3ff; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(btn);
    }
}
injectMiningButton();
async function openBountyBoard() {
    const res = await fetch(`/api/empire/bounties?user_id=${userId}`);
    const data = await res.json();
    
    let taskList = '';
    data.tasks.forEach(t => {
        taskList += `
            <div style="background:#1a1a1a; border:1px solid ${t.is_done ? '#444' : '#00ff00'}; margin-bottom:10px; padding:15px; border-radius:5px; opacity: ${t.is_done ? '0.6' : '1'};">
                <div style="font-weight:bold; color:${t.is_done ? '#888' : '#00ff00'};">${t.desc}</div>
                <div style="font-size:0.6em; color:#aaa; margin-top:5px;">Reward: ${t.reward_ixp} IXP | ${t.reward_honor} Honor</div>
                <button onclick="claimTask('${t.id}')" ${t.is_done ? 'disabled' : ''} style="margin-top:10px; background:${t.is_done ? '#333' : '#00ff00'}; color:#000; border:none; padding:5px 10px; font-weight:bold; cursor:pointer; width:100%; border-radius:3px;">
                    ${t.is_done ? 'COMPLETED' : 'CLAIM BOUNTY'}
                </button>
            </div>
        `;
    });

    const bountyOverlay = document.createElement('div');
    bountyOverlay.id = 'bounty-ui';
    bountyOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.95); z-index:10005; padding:20px; box-sizing:border-box; color:white; font-family:monospace; overflow-y:auto;";
    bountyOverlay.innerHTML = `
        <h2 style="text-align:center; color:#00ff00; text-shadow:0 0 10px #00ff00;">IMPERIAL BOUNTIES</h2>
        <div style="margin-top:20px;">${taskList}</div>
        <button onclick="document.getElementById('bounty-ui').remove()" style="width:100%; margin-top:30px; padding:15px; background:transparent; border:1px solid #00ff00; color:#00ff00; font-weight:bold; cursor:pointer;">RETURN TO HUB</button>
    `;
    document.body.appendChild(bountyOverlay);
}

async function claimTask(taskId) {
    const res = await fetch('/api/empire/bounties/claim', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, task_id: taskId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('bounty-ui').remove(); openBountyBoard(); if(typeof initGame === 'function') initGame(); }
}

function injectBountyButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('bounty-btn')) {
        const btn = document.createElement('button');
        btn.id = 'bounty-btn';
        btn.innerHTML = '📜 DAILY BOUNTIES';
        btn.onclick = openBountyBoard;
        btn.style = "margin-top:10px; width:100%; background:#0a1a0a; color:#00ff00; border:1px solid #00ff00; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        hub_zone = document.getElementById('neural-hub-zone');
        hub_zone.appendChild(btn);
    }
}
injectBountyButton();
async function openAscensionAltar() {
    const res = await fetch(`/api/empire/ascend/info?user_id=${userId}`);
    const data = await res.json();
    
    const altarOverlay = document.createElement('div');
    altarOverlay.id = 'ascend-ui';
    altarOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:radial-gradient(circle, #1a2a6c, #b21f1f, #fdbb2d); z-index:10006; padding:20px; box-sizing:border-box; color:white; font-family:serif; text-align:center; display:flex; flex-direction:column; justify-content:center;";
    
    altarOverlay.innerHTML = `
        <h1 style="text-shadow: 0 0 20px white; letter-spacing:5px;">ASCENSION ALTAR</h1>
        <div style="background:rgba(0,0,0,0.7); padding:30px; border-radius:15px; border: 2px solid gold;">
            <p style="font-size:1.2em;">Current Status: <span style="color:gold;">${data.current_rank} (Lvl ${data.current_level})</span></p>
            <p style="margin-top:20px;">To reach the next level, you must sacrifice:</p>
            <h2 style="color:gold;">${data.next_cost.toLocaleString()} IXP</h2>
            <button onclick="performAscension()" style="margin-top:30px; width:100%; padding:20px; background:gold; color:black; border:none; font-weight:bold; font-size:1.1em; cursor:pointer; box-shadow:0 0 15px gold;">ASCEND NOW</button>
        </div>
        <button onclick="document.getElementById('ascend-ui').remove()" style="margin-top:40px; background:none; border:none; color:white; text-decoration:underline; cursor:pointer;">Not ready for the divine path</button>
    `;
    document.body.appendChild(altarOverlay);
}

async function performAscension() {
    const res = await fetch('/api/empire/ascend/execute', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { 
        document.getElementById('ascend-ui').remove(); 
        if(typeof initGame === 'function') initGame(); 
    }
}

function injectAscendButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('ascend-btn')) {
        const btn = document.createElement('button');
        btn.id = 'ascend-btn';
        btn.innerHTML = '🏛️ ASCENSION ALTAR';
        btn.onclick = openAscensionAltar;
        btn.style = "margin-top:10px; width:100%; background:linear-gradient(to right, #fdbb2d, #b21f1f); color:white; border:1px solid gold; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        zone.appendChild(btn);
    }
}
injectAscendButton();
async function openComms() {
    const commsOverlay = document.createElement('div');
    commsOverlay.id = 'comms-ui';
    commsOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#050505; z-index:10007; padding:10px; box-sizing:border-box; color:#fff; font-family:monospace; display:flex; flex-direction:column;";
    
    commsOverlay.innerHTML = `
        <div style="border-bottom:1px solid #333; padding-bottom:10px; display:flex; justify-content:space-between;">
            <span style="color:#aaa;">📡 IMPERIAL COMMS_v1.0</span>
            <button onclick="document.getElementById('comms-ui').remove()" style="background:none; border:none; color:red; cursor:pointer;">[EXIT]</button>
        </div>
        <div id="chat-box" style="flex-grow:1; overflow-y:auto; margin:10px 0; padding:10px; background:#111; border-radius:5px;">
            <!-- پیام‌ها اینجا بارگذاری می‌شوند -->
        </div>
        <div style="display:flex;">
            <input type="text" id="chat-input" placeholder="Enter signal..." style="flex-grow:1; background:#222; border:1px solid #444; color:white; padding:10px;">
            <button onclick="sendMessage()" style="padding:10px 20px; background:#fff; color:#000; border:none; font-weight:bold; cursor:pointer;">SEND</button>
        </div>
    `;
    document.body.appendChild(commsOverlay);
    refreshChat();
}

async function refreshChat() {
    const res = await fetch('/api/comms/get');
    const data = await res.json();
    const chatBox = document.getElementById('chat-box');
    if(!chatBox) return;

    chatBox.innerHTML = data.messages.map(m => `
        <div style="margin-bottom:8px; font-size:0.7em;">
            <span style="color:#555;">[${m.time}]</span> 
            <span style="color:gold;">${m.rank}</span> 
            <span style="color:#00f3ff;">${m.user_id.substring(0,6)}:</span> 
            <span>${m.text}</span>
        </div>
    `).join('');
    chatBox.scrollTop = chatBox.scrollHeight;
}

async function sendMessage() {
    const input = document.getElementById('chat-input');
    const text = input.value;
    if(!text) return;

    await fetch('/api/market/buy', { # به اشتباه از یک API دیگر استفاده نشود - اصلاح شد
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, text: text })
    }); // در کد نهایی اصلاح شده:
    await fetch('/api/comms/send', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, text: text })
    });

    input.value = '';
    refreshChat();
}

function injectCommsButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('comms-btn')) {
        const btn = document.createElement('button');
        btn.id = 'comms-btn';
        btn.innerHTML = '📡 IMPERIAL COMMS';
        btn.onclick = openComms;
        btn.style = "margin-top:10px; width:100%; background:#111; color:white; border:1px solid #333; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(btn);
    }
}
injectCommsButton();
async function openQuantumSpin() {
    const res = await fetch(`/api/empire/spin/status?user_id=${userId}`);
    const data = await res.json();
    
    const spinOverlay = document.createElement('div');
    spinOverlay.id = 'spin-ui';
    spinOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(20,0,40,0.95); z-index:10008; padding:20px; box-sizing:border-box; color:white; font-family:monospace; text-align:center; display:flex; flex-direction:column; justify-content:center; align-items:center;";
    
    spinOverlay.innerHTML = `
        <h2 style="text-shadow: 0 0 15px magenta; color:magenta;">QUANTUM SPIN</h2>
        <div id="reactor-visual" style="width:150px; height:150px; border:5px dashed magenta; border-radius:50%; margin:30px; display:flex; align-items:center; justify-content:center; animation: spin-slow 4s infinite linear;">
            <div style="width:20px; height:20px; background:white; border-radius:50%; box-shadow:0 0 20px white;"></div>
        </div>
        <p style="margin-bottom:20px;">${data.can_spin ? 'Reactor Stable. Ready for extraction.' : 'Reactor Cooling Down...'}</p>
        <button id="spin-btn" onclick="executeSpin()" ${data.can_spin ? '' : 'disabled'} style="width:100%; padding:20px; background:magenta; color:white; border:none; font-weight:bold; cursor:pointer; box-shadow:0 0 15px magenta;">INITIATE SPIN</button>
        <button onclick="document.getElementById('spin-ui').remove()" style="margin-top:30px; background:none; border:none; color:#aaa; cursor:pointer;">RETURN</button>
        <style>
            @keyframes spin-slow { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }
            @keyframes spin-fast { from { transform: rotate(0deg); } to { transform: rotate(1080deg); } }
        </style>
    `;
    document.body.appendChild(spinOverlay);
}

async function executeSpin() {
    const btn = document.getElementById('spin-btn');
    const reactor = document.getElementById('reactor-visual');
    btn.disabled = true;
    reactor.style.animation = "spin-fast 2s cubic-bezier(0.4, 0, 0.2, 1) forwards";
    
    const res = await fetch('/api/empire/spin/execute', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    
    setTimeout(() => {
        alert("✨ QUANTUM REWARD: " + data.reward_label);
        document.getElementById('spin-ui').remove();
        if(typeof initGame === 'function') initGame();
    }, 2000);
}

function injectSpinButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('spin-btn-main')) {
        const btn = document.createElement('button');
        btn.id = 'spin-btn-main';
        btn.innerHTML = '🎡 QUANTUM SPIN';
        btn.onclick = openQuantumSpin;
        btn.style = "margin-top:10px; width:100%; background:#2c003e; color:magenta; border:1px solid magenta; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(btn);
    }
}
injectSpinButton();
async function openAuctionHouse() {
    const res = await fetch('/api/empire/auction/status');
    const data = await res.json();
    const auc = data.auction;

    const auctionOverlay = document.createElement('div');
    auctionOverlay.id = 'auction-ui';
    auctionOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:linear-gradient(135deg, #000 0%, #1a1a1a 100%); z-index:10009; padding:20px; box-sizing:border-box; color:gold; font-family:serif; text-align:center;";
    
    auctionOverlay.innerHTML = `
        <h1 style="text-shadow: 0 0 10px gold; border-bottom: 2px solid gold; padding-bottom:10px;">ROYAL AUCTION</h1>
        <div style="margin-top:30px; border:1px solid gold; padding:20px; background:rgba(255,215,0,0.05);">
            <h3 style="color:#fff;">${auc.item_name}</h3>
            <p style="font-size:0.7em; color:#aaa;">${auc.item_desc}</p>
            <div style="margin:20px 0;">
                <div style="font-size:0.6em; color:gold;">CURRENT HIGHEST BID</div>
                <div style="font-size:2em; font-weight:bold;">${auc.highest_bid.toLocaleString()} IXP</div>
                <div style="font-size:0.6em; color:#aaa;">By: ${auc.highest_bidder}</div>
            </div>
            <input type="number" id="bid-input" placeholder="Enter higher bid..." style="width:100%; padding:10px; background:#111; border:1px solid gold; color:white; margin-bottom:10px;">
            <button onclick="placeBid()" style="width:100%; padding:15px; background:gold; color:black; font-weight:bold; cursor:pointer;">PLACE BID</button>
        </div>
        <button onclick="document.getElementById('auction-ui').remove()" style="margin-top:30px; background:none; border:none; color:#555; cursor:pointer;">LEAVE HALL</button>
    `;
    document.body.appendChild(auctionOverlay);
}

async function placeBid() {
    const amt = document.getElementById('bid-input').value;
    if(!amt) return;

    const res = await fetch('/api/empire/auction/bid', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, amount: parseInt(amt) })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('auction-ui').remove(); openAuctionHouse(); }
}

function injectAuctionButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('auction-btn')) {
        const btn = document.createElement('button');
        btn.id = 'auction-btn';
        btn.innerHTML = '🏛️ ROYAL AUCTION';
        btn.onclick = openAuctionHouse;
        btn.style = "margin-top:10px; width:100%; background:gold; color:black; border:none; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        zone.appendChild(btn);
    }
}
injectAuctionButton();
let lastBroadcastId = 0;

async function checkImperialBroadcasts() {
    try {
        const res = await fetch('/api/empire/broadcast/active');
        const data = await res.json();
        const b = data.broadcast;

        if(b.active && b.id !== lastBroadcastId) {
            lastBroadcastId = b.id;
            showBroadcastOverlay(b);
        }
    } catch(e) {}
}

function showBroadcastOverlay(b) {
    const bgColor = b.type === 'EMERGENCY' ? 'rgba(150,0,0,0.95)' : 'rgba(0,0,0,0.95)';
    const borderColor = b.type === 'EMERGENCY' ? 'red' : 'gold';
    
    const overlay = document.createElement('div');
    overlay.id = 'imperial-broadcast-overlay';
    overlay.style = `position:fixed; top:0; left:0; width:100%; height:100%; background:${bgColor}; z-index:200000; display:flex; flex-direction:column; align-items:center; justify-content:center; color:white; padding:40px; box-sizing:border-box; text-align:center; border: 10px double ${borderColor};`;
    
    overlay.innerHTML = `
        <div style="font-size:0.6em; letter-spacing:5px; color:${borderColor}; margin-bottom:20px;">INCOMING TRANSMISSION FROM SUPREME COMMANDER</div>
        <div style="font-size:1.5em; font-weight:bold; line-height:1.4; text-shadow: 0 0 10px ${borderColor};">${b.content}</div>
        <button onclick="document.getElementById('imperial-broadcast-overlay').remove()" style="margin-top:50px; background:${borderColor}; color:black; border:none; padding:10px 30px; font-weight:bold; cursor:pointer;">ACKNOWLEDGED</button>
    `;
    document.body.appendChild(overlay);
}

// چک کردن هر ۳۰ ثانیه برای پیام‌های جدید از طرف فرمانده
setInterval(checkImperialBroadcasts, 30000);
checkImperialBroadcasts();
async function openSupportBureau() {
    const bureauOverlay = document.createElement('div');
    bureauOverlay.id = 'support-ui';
    bureauOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#1a1a1a; z-index:10010; padding:20px; box-sizing:border-box; color:white; font-family:sans-serif; overflow-y:auto;";
    
    bureauOverlay.innerHTML = `
        <h2 style="text-align:center; color:#00d4ff; border-bottom:1px solid #333; padding-bottom:10px;">BUREAU OF PETITIONS</h2>
        <div style="margin-top:20px;">
            <label style="font-size:0.7em; color:#aaa;">CATEGORY</label>
            <select id="support-cat" style="width:100%; padding:10px; background:#222; color:white; border:1px solid #444; margin-bottom:15px;">
                <option value="TECH">Technical Issue</option>
                <option value="ECONOMY">Economic Dispute</option>
                <option value="REPORT">Report Citizen</option>
                <option value="OTHER">Other Inquiry</option>
            </select>
            <label style="font-size:0.7em; color:#aaa;">YOUR MESSAGE</label>
            <textarea id="support-msg" placeholder="Describe your issue..." style="width:100%; height:100px; background:#222; color:white; border:1px solid #444; padding:10px; box-sizing:border-box;"></textarea>
            <button onclick="submitPetition()" style="width:100%; margin-top:15px; background:#00d4ff; color:black; border:none; padding:15px; font-weight:bold; cursor:pointer;">SUBMIT PETITION</button>
        </div>
        <div id="my-petitions" style="margin-top:30px; border-top:1px solid #333; padding-top:20px;">
            <p style="font-size:0.8em; color:#aaa;">Loading your previous petitions...</p>
        </div>
        <button onclick="document.getElementById('support-ui').remove()" style="width:100%; margin-top:30px; background:none; border:1px solid #555; color:#555; cursor:pointer;">EXIT BUREAU</button>
    `;
    document.body.appendChild(bureauOverlay);
    loadMyPetitions();
}

async function submitPetition() {
    const cat = document.getElementById('support-cat').value;
    const msg = document.getElementById('support-msg').value;
    if(!msg) return;

    const res = await fetch('/api/empire/support/submit', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, category: cat, message: msg })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('support-ui').remove(); }
}

async function loadMyPetitions() {
    const res = await fetch(`/api/empire/support/my?user_id=${userId}`);
    const data = await res.json();
    const container = document.getElementById('my-petitions');
    
    if(data.petitions.length === 0) {
        container.innerHTML = '<p style="font-size:0.7em; color:#555;">No petitions on record.</p>';
        return;
    }

    container.innerHTML = '<h4>YOUR RECORDS</h4>' + data.petitions.map(p => `
        <div style="background:#222; padding:10px; margin-bottom:10px; border-radius:5px; font-size:0.7em;">
            <div style="display:flex; justify-content:space-between;">
                <span style="color:#00d4ff;">#${p.id} [${p.category}]</span>
                <span style="color:orange;">${p.status}</span>
            </div>
            <div style="margin-top:5px; color:#aaa;">${p.message}</div>
        </div>
    `).join('');
}

function injectSupportButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('support-btn')) {
        const btn = document.createElement('button');
        btn.id = 'support-btn';
        btn.innerHTML = '🏛️ SUPPORT BUREAU';
        btn.onclick = openSupportBureau;
        btn.style = "margin-top:10px; width:100%; background:#222; color:#00d4ff; border:1px solid #00d4ff; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px;";
        zone.appendChild(btn);
    }
}
injectSupportButton();
async function openUnionAltar() {
    const unionOverlay = document.createElement('div');
    unionOverlay.id = 'union-ui';
    unionOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:radial-gradient(circle, #4b0082, #000); z-index:10011; padding:20px; box-sizing:border-box; color:white; font-family:serif; text-align:center; display:flex; flex-direction:column; justify-content:center;";
    
    unionOverlay.innerHTML = `
        <h1 style="color:#ff00ff; text-shadow:0 0 15px #ff00ff;">NEURAL LINK ALTAR</h1>
        <p style="font-size:0.8em; margin-bottom:30px;">Synchronize your AI core with a partner for mutual evolution.</p>
        
        <div style="background:rgba(255,255,255,0.05); padding:20px; border:1px solid #ff00ff; border-radius:15px;">
            <input type="text" id="partner-id-input" placeholder="Enter Partner ID..." style="width:100%; padding:10px; background:#111; border:1px solid #444; color:white; margin-bottom:10px;">
            <button onclick="proposeUnion()" style="width:100%; padding:15px; background:#ff00ff; color:white; font-weight:bold; border:none; cursor:pointer; box-shadow:0 0 10px #ff00ff;">SEND PROPOSAL</button>
            <hr style="border:0; border-top:1px solid #333; margin:20px 0;">
            <button onclick="acceptUnion()" style="width:100%; padding:15px; background:transparent; border:1px solid #00f3ff; color:#00f3ff; font-weight:bold; cursor:pointer;">ACCEPT PENDING LINK</button>
        </div>
        
        <button onclick="document.getElementById('union-ui').remove()" style="margin-top:30px; background:none; border:none; color:#888; cursor:pointer;">STAY INDEPENDENT</button>
    `;
    document.body.appendChild(unionOverlay);
}

async function proposeUnion() {
    const pId = document.getElementById('partner-id-input').value;
    if(!pId) return;
    const res = await fetch('/api/empire/union/propose', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, partner_id: pId })
    });
    const data = await res.json();
    alert(data.message);
}

async function acceptUnion() {
    const res = await fetch('/api/empire/union/accept', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('union-ui').remove(); if(typeof initGame === 'function') initGame(); }
}

function injectUnionButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('union-btn')) {
        const btn = document.createElement('button');
        btn.id = 'union-btn';
        btn.innerHTML = '💞 NEURAL LINK';
        btn.onclick = openUnionAltar;
        btn.style = "margin-top:10px; width:100%; background:#200020; color:#ff00ff; border:1px solid #ff00ff; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold;";
        zone.appendChild(btn);
    }
}
injectUnionButton();
async function openCitizenDossier() {
    const res = await fetch(`/api/player/dossier?user_id=${userId}`);
    const data = await res.json();
    const d = data.dossier;

    const dossierOverlay = document.createElement('div');
    dossierOverlay.id = 'dossier-ui';
    dossierOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; z-index:10012; padding:20px; box-sizing:border-box; color:white; font-family:monospace; display:flex; flex-direction:column; align-items:center;";
    
    dossierOverlay.innerHTML = `
        <div style="width:100%; border:2px solid #00ff00; background:rgba(0,255,0,0.05); padding:20px; border-radius:15px; position:relative;">
            <div style="position:absolute; top:10px; right:10px; color:#00ff00; font-size:0.5em;">ID: ${d.uid}</div>
            <h2 style="color:#00ff00; margin:0;">${d.rank_title}</h2>
            <p style="font-size:0.7em; margin-bottom:20px;">Nasrium Empire Registry</p>
            
            <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px; text-align:left;">
                <div style="border:1px solid #333; padding:10px;">
                    <span style="font-size:0.5em; color:#aaa;">LEVEL</span><br>
                    <span style="font-size:1.2em; color:gold;">${d.level}</span>
                </div>
                <div style="border:1px solid #333; padding:10px;">
                    <span style="font-size:0.5em; color:#aaa;">HONOR</span><br>
                    <span style="font-size:1.2em; color:#00d4ff;">${d.honor}</span>
                </div>
                <div style="border:1px solid #333; padding:10px;">
                    <span style="font-size:0.5em; color:#aaa;">WEALTH (IXP)</span><br>
                    <span style="font-size:1em; color:#00ff00;">${d.ixp.toLocaleString()}</span>
                </div>
                <div style="border:1px solid #333; padding:10px;">
                    <span style="font-size:0.5em; color:#aaa;">INVENTORY</span><br>
                    <span style="font-size:1em;">${d.items_count} Items</span>
                </div>
            </div>
            
            <div style="margin-top:20px; text-align:left; font-size:0.7em; color:#aaa;">
                <div>🔘 LEGION: <span style="color:white;">${d.legion}</span></div>
                <div>🔘 PARTNER: <span style="color:white;">${d.partner}</span></div>
                <div>🔘 STATUS: <span style="color:#00ff00;">${d.pioneer_status ? 'GENESIS PIONEER' : 'CITIZEN'}</span></div>
            </div>
        </div>
        
        <button onclick="document.getElementById('dossier-ui').remove()" style="margin-top:30px; width:100%; padding:15px; background:#00ff00; color:#000; border:none; font-weight:bold; cursor:pointer;">RETURN TO OPERATIONS</button>
    `;
    document.body.appendChild(dossierOverlay);
}

function injectProfileButton() {
    const header = document.querySelector('header');
    if(header && !document.getElementById('profile-btn')) {
        const btn = document.createElement('button');
        btn.id = 'profile-btn';
        btn.innerHTML = '🪪 PROFILE';
        btn.onclick = openCitizenDossier;
        btn.style = "background:#333; color:#00ff00; border:1px solid #00ff00; padding:5px 10px; font-size:0.6em; cursor:pointer; border-radius:3px; float:left;";
        header.appendChild(btn);
    }
}
injectProfileButton();
async function openWalletBridge() {
    const res = await fetch(`/api/wallet/status?user_id=${userId}`);
    const data = await res.json();
    
    const walletOverlay = document.createElement('div');
    walletOverlay.id = 'wallet-ui';
    walletOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:linear-gradient(180deg, #0088cc 0%, #000 100%); z-index:10013; padding:20px; box-sizing:border-box; color:white; font-family:sans-serif; text-align:center; display:flex; flex-direction:column; justify-content:center;";
    
    let content = data.linked 
        ? `<div style="padding:20px; background:rgba(255,255,255,0.1); border-radius:10px;">
            <p style="color:#00ff00;">✅ WALLET CONNECTED</p>
            <p style="font-size:0.6em; word-break:break-all;">${data.address}</p>
           </div>`
        : `<button onclick="simulateWalletConnect()" style="width:100%; padding:20px; background:#0088cc; color:white; border:none; border-radius:10px; font-weight:bold; cursor:pointer;">CONNECT TON WALLET</button>`;

    walletOverlay.innerHTML = `
        <h1 style="text-shadow: 0 0 10px #0088cc;">THE GOLDEN BRIDGE</h1>
        <p style="font-size:0.8em; margin-bottom:30px;">Link your TON wallet to the Nasrium Empire to enable cross-dimensional trade.</p>
        ${content}
        <div style="margin-top:20px; font-size:0.6em; color:#aaa;">Exchange Rate: 1 TON = ${data.rate.toLocaleString()} IXP</div>
        <button onclick="document.getElementById('wallet-ui').remove()" style="margin-top:40px; background:none; border:none; color:white; cursor:pointer; text-decoration:underline;">RETURN TO HUB</button>
    `;
    document.body.appendChild(walletOverlay);
}

async function simulateWalletConnect() {
    // در نسخه نهایی اینجا TonConnect UI باز می‌شود
    const fakeAddr = prompt("Enter your TON Wallet Address:");
    if(!fakeAddr) return;

    const res = await fetch('/api/wallet/link', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, address: fakeAddr })
    });
    const data = await res.json();
    alert(data.message);
    if(data.success) { document.getElementById('wallet-ui').remove(); openWalletBridge(); }
}

function injectWalletButton() {
    const zone = document.getElementById('neural-hub-zone');
    if(zone && !document.getElementById('wallet-bridge-btn')) {
        const btn = document.createElement('button');
        btn.id = 'wallet-bridge-btn';
        btn.innerHTML = '💎 TON BRIDGE';
        btn.onclick = openWalletBridge;
        btn.style = "margin-top:10px; width:100%; background:#0088cc; color:white; border:none; padding:10px; font-size:0.7em; cursor:pointer; border-radius:5px; font-weight:bold; box-shadow:0 0 10px #0088cc;";
        zone.appendChild(btn);
    }
}
injectWalletButton();
async function toggleNotifications(enabled) {
    const res = await fetch('/api/empire/notify/toggle', {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({ user_id: userId, enabled: enabled })
    });
    const data = await res.json();
    alert(data.message);
}

// اضافه کردن سوییچ اعلان به شناسنامه شهروندی (Dossier)
function injectNotifyToggle() {
    const dossier = document.getElementById('dossier-ui');
    if(dossier && !document.getElementById('notify-toggle-zone')) {
        const div = document.createElement('div');
        div.id = 'notify-toggle-zone';
        div.style = "margin-top:20px; border-top:1px solid #333; padding-top:10px; width:100%; text-align:left;";
        div.innerHTML = `
            <span style="font-size:0.6em; color:#aaa;">NEURAL ALERTS</span>
            <div style="display:flex; justify-content:space-between; align-items:center; margin-top:5px;">
                <span style="font-size:0.7em;">Enable Telegram Push</span>
                <input type="checkbox" onchange="toggleNotifications(this.checked)" id="notify-check" style="cursor:pointer;">
            </div>
            <button onclick="testPush()" style="margin-top:10px; font-size:0.5em; background:none; border:1px solid #555; color:#555; padding:2px 5px; cursor:pointer;">TEST SIGNAL</button>
        `;
        dossier.querySelector('div').appendChild(div);
    }
}

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
    data.new_badges.forEach(badge => {
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
