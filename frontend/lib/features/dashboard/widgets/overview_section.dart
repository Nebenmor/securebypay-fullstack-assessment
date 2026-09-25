import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';

class OverviewSection extends StatelessWidget {
  final double walletBalance;
  final List<dynamic> stats;
  const OverviewSection({super.key, required this.walletBalance, required this.stats});

  @override
  Widget build(BuildContext context) {
    final balanceCard = Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Balance', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Color(0xB2FFFFFF))),
            const SizedBox(height: 8),
            Text(
              '₦${walletBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: -0.5, color: Color(0xE5FFFFFF)),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Fund Wallet', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
        ),
      ),
    );

    Widget statCard(Map s, String icon, Color iconBg) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.sidebarBorder)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    child: SvgPicture.asset(icon),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(s['label'], style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('${s['value']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      const Icon(Icons.arrow_upward, size: 14, color: Colors.green),
                      Text('${s['change']}%', style: const TextStyle(fontSize: 12, color: Colors.green)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Vs last month', style: TextStyle(fontSize: 11, color: AppColors.neutral500)),
            ],
          ),
        ),
      );
    }

    final iconFor = {
      'totalShipments': ('assets/icons/icon_total_shipments.svg', const Color(0xFFF4E3C4)),
      'totalExports': ('assets/icons/icon_export.svg', const Color(0xFFD9FFD7)),
      'totalImports': ('assets/icons/icon_import.svg', const Color(0xFFD7FDFF)),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(border: Border.all(color: AppColors.sidebarBorder), borderRadius: BorderRadius.circular(8)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text('This Month', style: TextStyle(fontSize: 13)), SizedBox(width: 4), Icon(Icons.keyboard_arrow_down, size: 16)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            balanceCard,
            for (final s in stats) ...[
              const SizedBox(width: 16),
              statCard(s, iconFor[s['key']]!.$1, iconFor[s['key']]!.$2),
            ],
          ],
        ),
      ],
    );
  }
}