// ID_2000: THE GRAND GENESIS 2.0
async function triggerFinalGenesis() {
    const res = await fetch('/api/eternity/genesis/final');
    const data = await res.json();
    if(data.success && !localStorage.getItem('nasrium_eternal_live')) {
        document.body.innerHTML = '';
        const overlay = document.createElement('div');
        overlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; display:flex; flex-direction:column; align-items:center; justify-content:center; color:gold; text-align:center; font-family:serif; z-index:9999999;";
        overlay.innerHTML = `
            <div style="animation: fadeIn 10s forwards;">
                <h1 style="font-size:5em; letter-spacing:30px; text-shadow: 0 0 50px gold; margin:0;">نصریوم</h1>
                <h2 style="color:white; letter-spacing:10px; margin-top:20px;">THE SEVENTH AWAKENING</h2>
                <hr style="width:300px; border:1px solid gold; margin:40px auto;">
                <p style="font-family:monospace; font-size:1em; color:#aaa;">NASRIUM v10.0.0 | TOTAL SOVEREIGNTY ACHIEVED</p>
                <p style="font-size:0.6em; color:gold; margin-top:100px;">SIGNED BY THE CREATOR OF THE PURE ECOSYSTEM</p>
                <button onclick="location.reload()" style="margin-top:50px; background:gold; color:black; border:none; padding:25px 100px; font-weight:bold; font-size:1.5em; cursor:pointer; box-shadow: 0 0 50px gold;">ASCEND TO ETERNITY</button>
            </div>
        `;
        document.body.appendChild(overlay);
        localStorage.setItem('nasrium_eternal_live', 'true');
    }
}
setTimeout(triggerFinalGenesis, 1000);
