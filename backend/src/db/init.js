import pool from '../config/db.js';

export async function initDb() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      first_name VARCHAR(50) NOT NULL,
      last_name VARCHAR(50) NOT NULL,
      email VARCHAR(255) UNIQUE NOT NULL,
      phone VARCHAR(20) NOT NULL,
      password_hash TEXT NOT NULL,
      wallet_balance NUMERIC(14,2) NOT NULL DEFAULT 3000000.28,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );

    CREATE TABLE IF NOT EXISTS shipments (
      id SERIAL PRIMARY KEY,
      user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      tracking_id VARCHAR(30) NOT NULL,
      sender VARCHAR(100) NOT NULL,
      receiver VARCHAR(100) NOT NULL,
      pickup_location VARCHAR(100) NOT NULL,
      delivery_location VARCHAR(100) NOT NULL,
      amount NUMERIC(12,2) NOT NULL,
      status VARCHAR(20) NOT NULL,
      processing_time VARCHAR(30) NOT NULL,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    );
  `);
}