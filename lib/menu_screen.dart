import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'models.dart';
import 'theme.dart';
import 'utils.dart';
import 'data.dart';

class MenuScreen extends StatefulWidget {
  final List<MenuItemModel> menuItems;
  final Lang lang;
  final Function(List<MenuItemModel>) onUpdate;

  const MenuScreen({
    Key? key,
    required this.menuItems,
    required this.lang,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _search = "";

  void _toggleActive(String id) {
    final newItems = widget.menuItems.map((m) {
      if (m.id == id) {
        return m.copyWith(isAvailable: !m.isAvailable);
      }
      return m;
    }).toList();
    widget.onUpdate(newItems);
  }

  @override
  Widget build(BuildContext context) {
    final t = (String k) => TR[widget.lang]?[k] ?? k;

    final filtered = widget.menuItems.where((m) {
      final q = _search.toLowerCase();
      return q.isEmpty || m.nameKu.toLowerCase().contains(q) || m.nameAr.toLowerCase().contains(q);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t("menuMgmt"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textDark)),
              ElevatedButton.icon(
                icon: const Icon(LucideIcons.plusCircle, size: 16),
                label: Text(t("addItem")),
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  textStyle: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold),
                ),
              ),
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
                      dataRowMaxHeight: 64,
                      columns: [
                        const DataColumn(label: Text("")),
                        DataColumn(label: Text(t("kurdishName"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("arabicName"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("category"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("price"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("status"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                        DataColumn(label: Text(t("actions"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted))),
                      ],
                      rows: filtered.map((m) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    m.imageUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (ctx, _, __) => Container(width: 48, height: 48, color: AppColors.bgLight),
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Text(m.nameKu, style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                            DataCell(Text(m.nameAr, style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textLightMuted))),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  CATS[m.categoryId] != null ? (widget.lang == Lang.ku ? CATS[m.categoryId]![Lang.ku]! : CATS[m.categoryId]![Lang.ar]!) : m.categoryId,
                                  style: const TextStyle(fontFamily: AppFonts.cairo, fontSize: 12, color: AppColors.textMuted),
                                ),
                              ),
                            ),
                            DataCell(Text(fp(m.priceIQD), style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                            DataCell(
                              Switch(
                                value: m.isAvailable,
                                onChanged: (_) => _toggleActive(m.id),
                                activeColor: AppColors.navy,
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(LucideIcons.edit2, size: 16, color: AppColors.textMuted),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(LucideIcons.trash2, size: 16, color: AppColors.errorText),
                                    onPressed: () {},
                                  ),
                                ],
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
