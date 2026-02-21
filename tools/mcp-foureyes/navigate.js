#!/usr/bin/env node

import WebSocket from "ws";

const CDP_HOST = "127.0.0.1";
const CDP_PORT = 9222;

async function fetchDebuggerUrl() {
  const listUrl = `http://${CDP_HOST}:${CDP_PORT}/json/list`;
  const response = await fetch(listUrl);
  const targets = await response.json();
  const page = targets.find((t) => t.type === "page");
  if (!page || !page.webSocketDebuggerUrl) {
    throw new Error("No debuggable page found");
  }
  return page.webSocketDebuggerUrl;
}

async function navigate(url) {
  const wsUrl = await fetchDebuggerUrl();
  const ws = new WebSocket(wsUrl);
  
  return new Promise((resolve, reject) => {
    let id = 0;
    
    ws.on("open", () => {
      id++;
      ws.send(JSON.stringify({
        id,
        method: "Page.navigate",
        params: { url }
      }));
    });
    
    ws.on("message", (data) => {
      const msg = JSON.parse(data.toString());
      if (msg.id === id) {
        console.log("Navigation result:", JSON.stringify(msg.result));
        ws.close();
        resolve(msg.result);
      }
    });
    
    ws.on("error", reject);
    
    setTimeout(() => {
      ws.close();
      reject(new Error("Timeout"));
    }, 10000);
  });
}

const url = process.argv[2] || "https://play.firekirin.xyz";
console.log(`Navigating to: ${url}`);
navigate(url).then(() => {
  console.log("Done");
  process.exit(0);
}).catch(err => {
  console.error("Error:", err.message);
  process.exit(1);
});
