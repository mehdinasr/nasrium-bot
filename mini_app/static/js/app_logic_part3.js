
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