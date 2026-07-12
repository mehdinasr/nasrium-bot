const API_BASE = "آدرس_جدید_را_اینجا_بگذارید/api";
const PLAYER_ID = "TEST_USER_001";

// دریافت اطلاعات بازیکن از سرور
async function fetchPlayerData() {
    try {
        let res = await fetch(`${API_BASE}/player/${PLAYER_ID}`);
        let data = await res.json();
        
        // اگر کاربر پیدا نشد ابتدا او را ثبتنام کن
        if (data.Status === "Fail" && data.Message === "Player Not Found") {
            logStatus("Registering new node...");
            res = await fetch(`${API_BASE}/auth/${PLAYER_ID}?name=CyberRunner`);
            data = await res.json();
        }
        
        if (data.Resources) {
            document.getElementById("res-credits").innerText = Math.floor(data.Resources.Credits);
            document.getElementById("res-bandwidth").innerText = Math.floor(data.Resources.Bandwidth);
            logStatus("System Online. Awaiting commands.");
        }
    } catch (e) {
        logStatus("Connection Error: Server offline?");
    }
}

// ارسال درخواست ارتقا به سرور
async function upgradeBuilding(type) {
    logStatus(`Upgrading ${type}...`);
    try {
        const res = await fetch(`${API_BASE}/upgrade/${PLAYER_ID}?building=${type}`);
        const data = await res.json();
        if (data.Success) {
            logStatus(`Success! ${type} upgraded to Level ${data.NewLevel}.`);
            fetchPlayerData(); // بروزرسانی منابع
        } else {
            logStatus(`Failed: ${data.Message}`);
        }
    } catch (e) {
        logStatus("Network Error");
    }
}

function logStatus(msg) {
    document.getElementById("status-log").innerText = msg;
}

// لود اولیه اطلاعات
fetchPlayerData();