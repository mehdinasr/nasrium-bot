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
