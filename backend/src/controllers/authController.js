import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import pool from '../config/db.js';
import { seedShipments } from '../db/seed.js';

const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
const PHONE_RE = /^\+?[0-9]{7,15}$/;

const signToken = (user) =>
  jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '7d' });

const publicUser = (u) => ({
  id: u.id,
  firstName: u.first_name,
  lastName: u.last_name,
  email: u.email,
  phone: u.phone,
});

export const register = async (req, res) => {
  const { firstName, lastName, email, phone, password } = req.body || {};
  const errors = {};

  if (!firstName?.trim()) errors.firstName = 'First name is required';
  if (!lastName?.trim()) errors.lastName = 'Last name is required';
  if (!email || !EMAIL_RE.test(email.trim())) errors.email = 'Enter a valid email address';
  if (!phone || !PHONE_RE.test(phone.replace(/\s/g, ''))) errors.phone = 'Enter a valid phone number';
  if (!password || password.length < 8) errors.password = 'Password must be at least 8 characters';

  if (Object.keys(errors).length) {
    return res.status(400).json({ message: 'Validation failed', errors });
  }

  const passwordHash = await bcrypt.hash(password, 10);

  try {
    const { rows } = await pool.query(
      `INSERT INTO users (first_name, last_name, email, phone, password_hash)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [firstName.trim(), lastName.trim(), email.trim().toLowerCase(), phone.replace(/\s/g, ''), passwordHash]
    );
    const user = rows[0];
    await seedShipments(user);
    res.status(201).json({ token: signToken(user), user: publicUser(user) });
  } catch (err) {
    if (err.code === '23505') {
      return res.status(409).json({
        message: 'Email already registered',
        errors: { email: 'Email already registered' },
      });
    }
    throw err;
  }
};

export const login = async (req, res) => {
  const { email, password } = req.body || {};
  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  const { rows } = await pool.query('SELECT * FROM users WHERE email = $1', [email.trim().toLowerCase()]);
  const user = rows[0];
  const valid = user && (await bcrypt.compare(password, user.password_hash));

  if (!valid) return res.status(401).json({ message: 'Invalid email or password' });

  res.json({ token: signToken(user), user: publicUser(user) });
};

export const me = async (req, res) => {
  const { rows } = await pool.query('SELECT * FROM users WHERE id = $1', [req.userId]);
  if (!rows[0]) return res.status(404).json({ message: 'User not found' });
  res.json({ user: publicUser(rows[0]) });
};