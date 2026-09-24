import pool from '../config/db.js';

const templates = [
  { pickup: 'Lagos, Nigeria', delivery: 'Oyo, Nigeria', amount: 3000, status: 'in_transit', time: '10 hours' },
  { pickup: 'Lagos, Nigeria', delivery: 'Oyo, Nigeria', amount: 3000, status: 'delayed', time: '10 hours' },
  { pickup: 'Abuja, Nigeria', delivery: 'Lagos, Nigeria', amount: 4500, status: 'delivered', time: '2 days' },
  { pickup: 'Ibadan, Nigeria', delivery: 'Enugu, Nigeria', amount: 2800, status: 'in_transit', time: '6 hours' },
];

export async function seedShipments(user) {
  for (const [i, t] of templates.entries()) {
    await pool.query(
      `INSERT INTO shipments
        (user_id, tracking_id, sender, receiver, pickup_location, delivery_location, amount, status, processing_time)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
      [user.id, `MAF-100-234-${291 + i}`, `${user.first_name} ${user.last_name}`, 'Mercy', t.pickup, t.delivery, t.amount, t.status, t.time]
    );
  }
}