import mysql from 'mysql2/promise';

export const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '1028',
  database: process.env.DB_NAME || 'accreditrack_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

pool
  .getConnection()
  .then(conn => {
    console.log('Connected to MySQL Database!');
    conn.release();
  })
  .catch(err => {
    console.error('Database Connection Failed:', err);
  });
