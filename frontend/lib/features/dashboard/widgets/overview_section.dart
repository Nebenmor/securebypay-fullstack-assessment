import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_theme.dart';

class OverviewSection extends StatelessWidget {
  final double walletBalance;
  final List<dynamic> stats;
  const OverviewSection({super.key, required this.walletBalance, required this.stats});

  @override
  Widget build(BuildContext context) {
    final balanceCard = Container(
      width: 280,
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
        ],
      ),
    );

    final statCards = stats.map<Widget>((s) {
      final icon = s['key'] == 'totalExports'
          ? 'assets/icons/icon_export.svg'
          : s['key'] == 'totalImports'
              ? 'assets/icons/icon_import.svg'
              : 'assets/icons/icon_total_shipments.svg';
      return Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.sidebarBorder)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, width: 24, height: 24),
            const SizedBox(height: 8),
            Text('${s['value']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text('${s['label']}  +${s['change']}%', style: const TextStyle(fontSize: 12, color: AppColors.neutral500)),
          ],
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Overview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        const SizedBox(height: 16),
        Wrap(spacing: 16, runSpacing: 16, children: [balanceCard, ...statCards]),
      ],
    );
  }
}