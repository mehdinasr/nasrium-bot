
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