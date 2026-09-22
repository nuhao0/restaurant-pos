import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'models.dart';
import 'theme.dart';
import 'utils.dart';
import 'data.dart';
import 'widgets.dart';

class HistoryScreen extends StatefulWidget {
  final List<Order> orders;
  final Lang lang;
  final Function(Order) onReprint;

  const HistoryScreen({
    Key? key,
    required this.orders,
    required this.lang,
    required this.onReprint,
  }) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final t = (String k) => TR[widget.lang]?[k] ?? k;

    final filtered = widget.orders.where((o) {
      final q = _search.toLowerCase();
      return q.isEmpty || o.numStr.contains(q) || o.cashier.toLowerCase().contains(q);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t("history"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textDark)),
            ],
          ),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.search, size: 16, color: AppColors.textLightMuted),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (v) => setState(() => _search = v),
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: t("searchPlaceholder"),
                              hintStyle: const TextStyle(fontFamily: AppFonts.cairo, fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(AppColors.bgLight),
                      columns: [
                        DataColumn(label: Text(t("orderNum"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("filterDate"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("cashierName"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("total"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("payMethod"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("status"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("actions"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                      ],
                      rows: filtered.map((o) {
                        return DataRow(
                          cells: [
                            DataCell(Text("#${o.numStr}", style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                            DataCell(Text("${fd(o.date)} ${ft(o.date)}", style: const TextStyle(fontFamily: AppFonts.jakarta, color: AppColors.textDark))),
                            DataCell(Text(o.cashier, style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textDark))),
                            DataCell(Text(fp(o.total), style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.gold))),
                            DataCell(Text(o.payMethod == PayMethod.cash ? t("cash") : t("card"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textDark))),
                            DataCell(StatusBadge(status: o.status, lang: widget.lang)),
                            DataCell(
                              IconButton(
                                icon: const Icon(LucideIcons.printer, size: 16, color: AppColors.textMuted),
                                onPressed: () => widget.onReprint(o),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
