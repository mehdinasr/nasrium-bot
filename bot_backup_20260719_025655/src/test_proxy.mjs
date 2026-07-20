import { ProxyAgent, setGlobalDispatcher } from "undici";

setGlobalDispatcher(new ProxyAgent("http://127.0.0.1:56506"));

console.log("Testing connection to Telegram...");
try {
    const res = await fetch("https://api.telegram.org");
    console.log("SUCCESS - status:", res.status);
} catch (err) {
    console.log("FAILED:", err.message);
}
