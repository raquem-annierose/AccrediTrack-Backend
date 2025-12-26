import mysql from 'mysql2/promise';
import type { Pool } from 'mysql2/promise';
import { envConfig } from '@/env';
import { logger } from '@/utils/logger';
import type { DatabaseConfig } from '@/types/Database';

const config = envConfig as unknown as DatabaseConfig;

export const db: Pool = mysql.createPool({
  host: config.DB_HOST,
  port: Number(config.DB_PORT) || 3306,
  user: config.DB_USER,
  password: config.DB_PASSWORD,
  database: config.DB_NAME,
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
