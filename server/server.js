const os = require('os');
const { WebSocketServer } = require('ws');

const PORT = 8080;
const wss = new WebSocketServer({ port: PORT });

const ips = Object.values(os.networkInterfaces())
  .flat()
  .filter((i) => i && i.family === 'IPv4' && !i.internal)
  .map((i) => i.address);
console.log(`Listening on port ${PORT}. Use one of: ${ips.map((ip) => `ws://${ip}:${PORT}`).join('  ')}`);

wss.on('connection', (socket, req) => {
  console.log(`\nDevice connected from ${req.socket.remoteAddress}`);

  socket.on('message', (raw) => {
    let report;
    try {
      report = JSON.parse(raw.toString());
    } catch {
      socket.send(JSON.stringify({ type: 'error', received: 0 }));
      return;
    }

    console.log(`${report.device_name} · ${report.model} · iOS ${report.system_version}`);
    console.table(
      report.results.map((r) => ({ test: r.name, status: r.status, detail: r.detail }))
    );

    // Handshake reply: the app decodes this into ServerAck.
    socket.send(JSON.stringify({ type: 'ack', received: report.results.length }));
  });

  socket.on('close', () => console.log('Device disconnected'));
});
