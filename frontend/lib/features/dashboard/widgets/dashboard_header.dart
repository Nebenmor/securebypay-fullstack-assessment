import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback? onMenuTap;
  const DashboardHeader({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.sidebarBorder)),
      ),
      child: Row(
        children: [
          if (onMenuTap != null) ...[
            IconButton(icon: const Icon(Icons.menu), onPressed: onMenuTap),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('Invite & Earn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                SizedBox(height: 4),
                Text(
                  'Keep track of your addresses, location updates. Edit, Delete, Update and see all your saved addresses',
                  style: TextStyle(fontSize: 12, height: 20 / 12, color: AppColors.neutral500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BusinessBanner extends StatelessWidget {
  const BusinessBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      decoration: BoxDecoration(
        color: AppColors.bannerBg,
        borderRadius: BorderRadius.circular(6),
        image: const DecorationImage(
          image: AssetImage('assets/images/banner_pattern.png'),
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.all(32),
      alignment: Alignment.centerLeft,
      child: const Text(
        'KEEP UP WITH YOUR\nBUSINESS NEEDS',
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          height: 44 / 42.47,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
      ),
    );
  }
}