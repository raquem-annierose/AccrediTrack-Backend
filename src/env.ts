import { config } from 'dotenv';
import { z } from 'zod';
config();

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  NODE_PORT: z.coerce.number().default(3000),
  PROTOCOL: z.enum(['http', 'https']).default('http'),
  // Add database variables
  DB_HOST: z.string().default('localhost'),
  DB_USER: z.string(),
  DB_PASSWORD: z.string(),
  DB_NAME: z.string(),
});

export const envConfig = envSchema.parse({
  NODE_ENV: process.env.NODE_ENV,
  NODE_PORT: process.env.NODE_PORT,
  PROTOCOL: process.env.PROTOCOL,
  // Map process.env to zod schema
  DB_HOST: process.env.DB_HOST,
  DB_USER: process.env.DB_USER,
  DB_PASSWORD: process.env.DB_PASSWORD,
  DB_NAME: process.env.DB_NAME,
});

export type EnvConfig = z.infer<typeof envSchema>;
export const isHttps = envConfig.PROTOCOL === 'https';
