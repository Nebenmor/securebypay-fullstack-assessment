import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/responsive.dart';
import 'dashboard_service.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/growth_chart.dart'; // now exports GrowthChartCard
import 'widgets/overview_section.dart';
import 'widgets/shipment_tile.dart';
import 'widgets/sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = Future.wait([
      DashboardService.me(),
      DashboardService.overview(),
      DashboardService.growth(),
      DashboardService.shipments(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.authBg,
      drawer: isDesktop
          ? null
          : Drawer(
              child: FutureBuilder<List<dynamic>>(
                future: _future,
                builder: (context, snap) {
                  final name = snap.hasData
                      ? '${snap.data![0]['user']['firstName']} ${snap.data![0]['user']['lastName']}'
                      : '';
                  return Sidebar(userName: name);
                },
              ),
            ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Could not load dashboard: ${snapshot.error}'),
            );
          }

          final me = snapshot.data![0]['user'];
          final overview = snapshot.data![1];
          final growth = snapshot.data![2];
          final shipments = snapshot.data![3] as List<dynamic>;
          final userName = '${me['firstName']} ${me['lastName']}';

          final content = SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BusinessBanner(),
                const SizedBox(height: 12),
                const BannerDots(),
                const SizedBox(height: 24),
                OverviewSection(
                  walletBalance: (overview['walletBalance'] as num).toDouble(),
                  stats: overview['stats'],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent shipment',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.sidebarBorder),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                GrowthChartCard(initialGrowth: growth),
                const SizedBox(height: 16),
                for (final s in shipments) ShipmentTile(shipment: s),
              ],
            ),
          );

          if (!isDesktop) {
            return Column(
              children: [
                DashboardHeader(
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                Expanded(child: content),
              ],
            );
          }

          return Row(
            children: [
              Sidebar(userName: userName),
              Expanded(
                child: Column(
                  children: [
                    const DashboardHeader(),
                    Expanded(child: content),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
