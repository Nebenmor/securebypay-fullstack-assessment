import pool from '../config/db.js';

// Demo stats: multiplier per period applied to base numbers
const PERIODS = { this_month: 1, last_month: 0.8, this_year: 9 };

export const overview = async (req, res) => {
  const period = PERIODS[req.query.period] ? req.query.period : 'this_month';
  const m = PERIODS[period];

  const { rows } = await pool.query('SELECT wallet_balance FROM users WHERE id = $1', [req.userId]);
  if (!rows[0]) return res.status(404).json({ message: 'User not found' });

  res.json({
    period,
    walletBalance: Number(rows[0].wallet_balance),
    stats: [
      { key: 'totalShipments', label: 'Total Shipments', value: Math.round(34 * m), change: 16 },
      { key: 'totalExports', label: 'Total Exports', value: Math.round(34 * m), change: 16 },
      { key: 'totalImports', label: 'Total Imports', value: Math.round(34 * m), change: 16 },
    ],
  });
};

const GROWTH = {
  year: {
    labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
    values: [300, 330, 380, 350, 420, 400, 470, 520, 450, 650, 300, 1000],
  },
  month: {
    labels: Array.from({ length: 30 }, (_, i) => String(i + 1)),
    values: Array.from({ length: 30 }, (_, i) => Math.round(300 + 200 * Math.sin(i / 3) + i * 10)),
  },
  week: {
    labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    values: [120, 210, 180, 320, 260, 400, 350],
  },
};

export const growth = (req, res) => {
  const range = GROWTH[req.query.range] ? req.query.range : 'year';
  res.json({ range, ...GROWTH[range] });
};