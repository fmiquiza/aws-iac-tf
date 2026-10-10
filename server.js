const http = require('http');

const PORT = 8000;

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
  res.end(`
    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AWS Student Day Demo</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #0f172a;
                color: #f8fafc;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }
            .card {
                background-color: #1e293b;
                padding: 2.5rem;
                border-radius: 12px;
                box-shadow: 0 10px 25px rgba(0,0,0,0.5);
                text-align: center;
                border: 1px solid #334155;
            }
            h1 { color: #ff9900; }
            .badge {
                background-color: #10b981;
                color: #064e3b;
                padding: 0.4rem 0.8rem;
                border-radius: 20px;
                font-weight: bold;
                display: inline-block;
                margin-top: 1rem;
            }
        </style>
    </head>
    <body>
        <div class="card">
            <h1>🚀 AWS Student Day 2026 - Demo TF</h1>
            <h2>Versión 1.1 — EC2</h2>
            <p>¡La infraestructura y el código de la app levantadas sin procesos manuales mediante Terraform.</p>
            <div class="badge">Estado del Pipeline: En Vivo y Desplegado</div>
        </div>
    </body>
    </html>
  `);
});

server.listen(PORT, () => {
  console.log(`Servidor ejecutándose en el puerto ${PORT}`);
});