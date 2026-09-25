import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/auth_service.dart';

class _NavItem {
  final String icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

const _navItems = [
  _NavItem('assets/icons/icon_dashboard.svg', 'Dashboard'),
  _NavItem('assets/icons/icon_shipments.svg', 'Shipments'),
  _NavItem('assets/icons/icon_services.svg', 'Our Services'),
  _NavItem('assets/icons/icon_notifications.svg', 'Notifications'),
  _NavItem('assets/icons/icon_wallet.svg', 'Wallet'),
  _NavItem('assets/icons/icon_addresses.svg', 'My Addresses'),
  _NavItem('assets/icons/icon_invite.svg', 'Invite & Earn'),
  _NavItem('assets/icons/icon_help.svg', 'Help Center'),
];

class Sidebar extends StatelessWidget {
  final String userName;
  const Sidebar({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 120),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (var i = 0; i < _navItems.length; i++)
                  _NavTile(item: _navItems[i], isActive: i == 0),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.sidebarBorder),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/images/profile_placeholder.png'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(userName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      GestureDetector(
                        onTap: () async {
                          await AuthService.logout();
                          if (context.mounted) context.go('/login');
                        },
                        child: const Text('Logout', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  const _NavTile({required this.item, required this.isActive});

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        constraints: const BoxConstraints(minHeight: 56),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary
              : _hover
                  ? AppColors.authBg
                  : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              widget.item.icon,
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                active ? const Color(0xFFEBFFE2) : AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.item.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? const Color(0xFFEBFFE2) : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}