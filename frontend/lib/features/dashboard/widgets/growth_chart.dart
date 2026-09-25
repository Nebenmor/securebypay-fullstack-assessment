import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive.dart';
import '../dashboard_service.dart';
import 'growth_line.dart';

class GrowthChartCard extends StatefulWidget {
  final Map<String, dynamic> initialGrowth;
  const GrowthChartCard({super.key, required this.initialGrowth});

  @override
  State<GrowthChartCard> createState() => _GrowthChartCardState();
}

class _GrowthChartCardState extends State<GrowthChartCard> {
  late Map<String, dynamic> _data = widget.initialGrowth;
  String _range = 'year';
  bool _loading = false;

  Future<void> _select(String range) async {
    if (range == _range) return;
    setState(() { _range = range; _loading = true; });
    final res = await DashboardService.growth(range: range);
    if (mounted) setState(() { _data = res; _loading = false; });
  }

  Widget _tab(String label, String value) {
    final active = _range == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => _select(value),
        child: Container(
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? Colors.white : null,
            borderRadius: BorderRadius.circular(4),
            boxShadow: active ? [const BoxShadow(color: Colors.black12, blurRadius: 2)] : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: active ? const Color(0xFF1D2939) : const Color(0xFF667085),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.sidebarBorder)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            const Text('Company Growth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Container(
              height: 40,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(8)),
              child: Row(children: [_tab('Year', 'year'), _tab('Month', 'month'), _tab('Week', 'week')]),
            ),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Company Growth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Container(
                  width: 272,
                  height: 40,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: const Color(0xFFF2F4F7), borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [_tab('Year', 'year'), _tab('Month', 'month'), _tab('Week', 'week')]),
                ),
              ],
            ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : GrowthLine(values: _data['values']),
          ),
        ],
      ),
    );
  }
}