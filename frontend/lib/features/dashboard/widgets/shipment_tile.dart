import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';

class ShipmentTile extends StatefulWidget {
  final Map<String, dynamic> shipment;
  const ShipmentTile({super.key, required this.shipment});

  @override
  State<ShipmentTile> createState() => _ShipmentTileState();
}

class _ShipmentTileState extends State<ShipmentTile> {
  bool _expanded = false;

  Color _statusBg(String s) => switch (s) {
    'in_transit' => AppColors.statusInTransitBg,
    'delayed' => AppColors.statusDelayedBg,
    'delivered' => AppColors.statusDeliveredBg,
    _ => AppColors.statusPaidBg,
  };

  Color _statusText(String s) => switch (s) {
    'in_transit' => AppColors.statusInTransitText,
    'delayed' => AppColors.statusDelayedText,
    'delivered' => AppColors.statusDeliveredText,
    _ => AppColors.statusPaidText,
  };

  String _statusLabel(String s) => switch (s) {
    'in_transit' => 'In-Transit',
    'delayed' => 'Delayed',
    'delivered' => 'Delivered',
    _ => s,
  };

  Widget _labelValue(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: AppColors.rowLabel),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontSize: 16, color: AppColors.rowValue),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final s = widget.shipment;
    final isMobile = Responsive.isMobile(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sidebarBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _labelValue('Tracking ID', s['trackingId'])),
              if (!isMobile) ...[
                Expanded(child: _labelValue('Sender', s['sender'])),
                Expanded(child: _labelValue('Receiver', s['receiver'])),
              ],
              IconButton(
                icon: Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: () => setState(() => _expanded = !_expanded),
              ),
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _labelValue('Sender', s['sender'])),
                Expanded(child: _labelValue('Receiver', s['receiver'])),
              ],
            ),
          ],
          if (_expanded) ...[
            const SizedBox(height: 12),
            if (isMobile) ...[
              _labelValue('Pick Up From', '🇳🇬 ${s['pickupLocation']}'),
              const SizedBox(height: 12),
              _labelValue('Delivery To', '🇳🇬 ${s['deliveryLocation']}'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _labelValue('Amount', '₦${s['amount']}'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBg(s['status']),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusLabel(s['status']),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _statusText(s['status']),
                      ),
                    ),
                  ),
                ],
              ),
            ] else
              Row(
                children: [
                  Expanded(
                    child: _labelValue(
                      'Pick Up From',
                      '🇳🇬 ${s['pickupLocation']}',
                    ),
                  ),
                  Expanded(
                    child: _labelValue(
                      'Delivery To',
                      '🇳🇬 ${s['deliveryLocation']}',
                    ),
                  ),
                  Expanded(child: _labelValue('Amount', '₦${s['amount']}')),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBg(s['status']),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusLabel(s['status']),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _statusText(s['status']),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            if (isMobile)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Processing time',
                    style: TextStyle(fontSize: 12, color: Color(0xFF808080)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Color(0xFF3A3A3A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        s['processingTime'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3A3A3A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF262A48)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('View More'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: s['status'] == 'delayed'
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF32385E),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text('Pay Now'),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.statusPaidBg,
                                  foregroundColor: AppColors.statusPaidText,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: null,
                                child: const Text('Paid'),
                              ),
                      ),
                    ],
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Processing time',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Color(0xFF3A3A3A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              s['processingTime'],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF3A3A3A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF262A48)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('View More'),
                  ),
                  const SizedBox(width: 8),
                  if (s['status'] == 'delayed')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF32385E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Pay Now'),
                    )
                  else
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.statusPaidBg,
                        foregroundColor: AppColors.statusPaidText,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: null,
                      child: const Text('Paid'),
                    ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
