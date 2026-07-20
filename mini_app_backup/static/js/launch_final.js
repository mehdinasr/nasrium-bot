function launchNasriumOne() {
    document.body.innerHTML = ''; // پاکسازی کامل برای نمایش تمدن پاک
    const launchOverlay = document.createElement('div');
    launchOverlay.style = "position:fixed; top:0; left:0; width:100%; height:100%; background:#000; display:flex; flex-direction:column; align-items:center; justify-content:center; color:gold; font-family:serif; text-align:center; overflow:hidden;";
    
    launchOverlay.innerHTML = `
        <div style="animation: fadeIn 5s forwards;">
            <h1 style="font-size:5em; letter-spacing:20px; text-shadow: 0 0 50px gold;">نصریوم</h1>
            <h2 style="color:white; letter-spacing:5px;">NASRIUM PURE ECOSYSTEM v1.0</h2>
            <hr style="width:50%; border:1px solid gold; margin:30px auto;">
            <p style="font-family:monospace; font-size:0.8em; color:#aaa;">SIGNED BY THE CREATOR</p>
            <div style="font-size:0.5em; color:cyan; margin-top:10px;">${Math.random().toString(16).toUpperCase()}...</div>
            <button onclick="location.reload()" style="margin-top:50px; background:gold; color:black; border:none; padding:20px 80px; font-weight:bold; font-size:1.5em; cursor:pointer; box-shadow: 0 0 30px gold;">ENTER ETERNITY</button>
        </div>
        <style> @keyframes fadeIn { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } } </style>
    `;
    document.body.appendChild(launchOverlay);
}
// فعال‌سازی در لحظه لود
setTimeout(launchNasriumOne, 1000);
