import mysql from 'mysql2/promise';
import type { Pool } from 'mysql2/promise';
import { envConfig } from '@/env';
import { logger } from '@/utils/logger';

export const db: Pool = mysql.createPool({
  host: envConfig.DB_HOST,
  port: Number((envConfig as unknown).DB_PORT) || 3306,
  user: envConfig.DB_USER,
  password: envConfig.DB_PASSWORD,
  database: envConfig.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

export const checkConnection = async () => {
  try {
    const connection = await db.getConnection();
    logger.info('Database connected successfully');
    connection.release();
  } catch (err) {
    logger.error('Database connection failed', err);
  }
};
