const express = require('express');
const { Pool } = require('pg');
const http = require('http');
const socketIo = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

app.use(express.json());
app.use(express.static('client')); // sert les fichiers du dossier client

// Exemple route pour récupérer prospects
app.get('/api/prospects', async (req, res) => {
  const result = await pool.query('SELECT * FROM prospects');
  res.json(result.rows);
});

server.listen(10000, () => {
  console.log('Serveur en ligne sur le port 10000');
});
