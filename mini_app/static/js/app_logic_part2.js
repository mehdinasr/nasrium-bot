
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