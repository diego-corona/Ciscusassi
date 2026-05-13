// import del modulo sqlite3
import sqlite3 from 'sqlite3';

// creazione del database e della tabella clienti
const DB_PATH = process.env.DB_PATH || './data/database.sqlite';
const db = new sqlite3.Database(DB_PATH, (err) => {
	if (err) {
		console.error('❌ Errore connessione al database:', err.message);
		return;
	}

	console.log('🛜  Connesso al database SQLite');
});

export default db;
