
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