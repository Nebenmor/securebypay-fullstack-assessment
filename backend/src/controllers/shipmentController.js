import pool from '../config/db.js';

export const list = async (req, res) => {
  const limit = Math.min(parseInt(req.query.limit, 10) || 10, 50);

  const { rows } = await pool.query(
    'SELECT * FROM shipments WHERE user_id = $1 ORDER BY id LIMIT $2',
    [req.userId, limit]
  );

  res.json({
    shipments: rows.map((s) => ({
      id: s.id,
      trackingId: s.tracking_id,
      sender: s.sender,
      receiver: s.receiver,
      pickupLocation: s.pickup_location,
      deliveryLocation: s.delivery_location,
      amount: Number(s.amount),
      status: s.status,
      processingTime: s.processing_time,
    })),
  });
};