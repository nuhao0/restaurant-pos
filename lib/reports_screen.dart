import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'models.dart';
import 'theme.dart';
import 'utils.dart';
import 'data.dart';
import 'widgets.dart';

class ReportsScreen extends StatelessWidget {
  final List<Order> orders;
  final Lang lang;

  const ReportsScreen({
    Key? key,
    required this.orders,
    required this.lang,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = (String k) => TR[lang]?[k] ?? k;
    final rev = orders.where((o) => o.status == OrderStatus.completed).fold<double>(0, (s, o) => s + o.total);
    final count = orders.where((o) => o.status == OrderStatus.completed).length;
    final avg = count > 0 ? rev / count : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t("daily"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textDark)),
              ElevatedButton.icon(
                icon: const Icon(LucideIcons.printer, size: 16),
                label: Text(t("print")),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.textDark,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(width: 300, child: StatCard(label: t("totalRevenue"), value: fp(rev), icon: LucideIcons.trendingUp, color: AppColors.navy)),
              SizedBox(width: 300, child: StatCard(label: t("totalOrders"), value: count.toString(), icon: LucideIcons.shoppingCart, color: AppColors.gold)),
              SizedBox(width: 300, child: StatCard(label: t("avgOrder"), value: fp(avg), icon: LucideIcons.barChart2, color: const Color(0xFF16A34A))),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 800) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                          child: const Center(
                            child: Text(
                              "Chart Area",
                              style: TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textLightMuted),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                          child: const Center(
                            child: Text(
                              "Pie Chart Area",
                              style: TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textLightMuted),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                
                return Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                        child: const Center(
                          child: Text(
                            "Chart Area (Use fl_chart package for charts)",
                            style: TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textLightMuted),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                        child: const Center(
                          child: Text(
                            "Pie Chart Area",
                            style: TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textLightMuted),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
