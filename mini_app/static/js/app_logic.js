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
