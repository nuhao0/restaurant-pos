import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'models.dart';
import 'theme.dart';
import 'utils.dart';
import 'data.dart';

class POSScreen extends StatefulWidget {
  final List<CartItem> cart;
  final List<MenuItemModel> menuItems;
  final int orderNum;
  final String cashierName;
  final Lang lang;
  final Function(MenuItemModel) onAdd;
  final Function(String, int) onQty;
  final Function(String) onRemove;
  final VoidCallback onNewOrder;
  final VoidCallback onClear;
  final VoidCallback onCheckout;

  const POSScreen({
    Key? key,
    required this.cart,
    required this.menuItems,
    required this.orderNum,
    required this.cashierName,
    required this.lang,
    required this.onAdd,
    required this.onQty,
    required this.onRemove,
    required this.onNewOrder,
    required this.onClear,
    required this.onCheckout,
  }) : super(key: key);

  @override
  _POSScreenState createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  String _selectedCat = "all";
  String _search = "";

  @override
  Widget build(BuildContext context) {
    final t = (String k) => TR[widget.lang]?[k] ?? k;

    final activeItems = widget.menuItems.where((m) => m.isAvailable).toList();
    final filtered = activeItems.where((m) {
      final inCat = _selectedCat == "all" || m.categoryId == _selectedCat;
      final q = _search.toLowerCase();
      final inSearch = q.isEmpty ||
          m.nameKu.toLowerCase().contains(q) ||
          m.nameAr.toLowerCase().contains(q);
      return inCat && inSearch;
    }).toList();

    final subtotal = widget.cart.fold<double>(0, (s, ci) => s + (ci.item.priceIQD * ci.qty));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        Widget cartPanel = Container(
          width: isMobile ? double.infinity : 320,
          color: AppColors.white,
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.borderLight)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${t('cashier')}: ${widget.cashierName}",
                          style: const TextStyle(fontSize: 12, color: AppColors.textLightMuted, fontFamily: AppFonts.cairo),
                        ),
                        Row(
                          children: [
                            Text(
                              "#${widget.orderNum.toString().padLeft(4, '0')}",
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.gold, fontFamily: AppFonts.jakarta),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              t('orderNum'),
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: AppFonts.cairo),
                            ),
                            const SizedBox(width: 8),
                            const Icon(LucideIcons.shoppingCart, size: 16, color: AppColors.gold),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${fd(DateTime.now())} — ${ft(DateTime.now())}",
                      style: const TextStyle(fontSize: 11, color: AppColors.textLightMuted),
                    ),
                  ],
                ),
              ),

              // Items
              Expanded(
                child: widget.cart.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(LucideIcons.shoppingCart, size: 36, color: AppColors.textLightMuted.withOpacity(0.4)),
                            const SizedBox(height: 8),
                            Text(t('emptyCart'), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textLightMuted)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: widget.cart.length,
                        itemBuilder: (context, i) {
                          final ci = widget.cart[i];
                          return _buildCartItem(ci);
                        },
                      ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.borderLight)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          fp(subtotal),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark, fontFamily: AppFonts.jakarta),
                        ),
                        Text(
                          t('subtotal'),
                          style: const TextStyle(fontSize: 14, color: AppColors.textMuted, fontFamily: AppFonts.cairo),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderLight))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fp(subtotal), // total is subtotal here
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.gold, fontFamily: AppFonts.jakarta),
                          ),
                          Text(
                            t('total'),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: AppFonts.cairo),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: widget.cart.isEmpty ? null : () {
                        if (isMobile) Navigator.pop(context);
                        widget.onCheckout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        widget.lang == Lang.ku ? 'پارەدان (Checkout)' : 'الدفع (Checkout)',
                        style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.cart.isEmpty ? null : () {
                               if (isMobile) Navigator.pop(context);
                               widget.onClear();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.errorText,
                              side: const BorderSide(color: AppColors.errorBg),
                              minimumSize: const Size(0, 40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              widget.lang == Lang.ku ? 'سڕینەوە' : 'مسح',
                              style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.cart.isEmpty ? null : () {
                              if (isMobile) Navigator.pop(context);
                              widget.onNewOrder();
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textDark,
                              side: const BorderSide(color: AppColors.borderLight),
                              minimumSize: const Size(0, 40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              widget.lang == Lang.ku ? 'نوێ' : 'جديد',
                              style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

        return Scaffold(
          floatingActionButton: isMobile
              ? FloatingActionButton.extended(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) => SizedBox(height: MediaQuery.of(context).size.height * 0.8, child: cartPanel),
                    );
                  },
                  backgroundColor: AppColors.gold,
                  icon: const Icon(LucideIcons.shoppingCart, color: Colors.white),
                  label: Text(
                    "${widget.cart.fold<int>(0, (s, c) => s + c.qty)} - ${fp(subtotal)}",
                    style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                )
              : null,
          body: Row(
            children: [
              // Main content
              Expanded(
                child: Column(
                  children: [
                    // Categories
                    Container(
                      height: 70,
                      color: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              reverse: true, // RTL
                              children: [
                                _buildCatButton('all', t('all'), _selectedCat == 'all'),
                                ...CATS.entries.map((e) {
                                  final names = e.value;
                                  final name = widget.lang == Lang.ku ? names[Lang.ku]! : names[Lang.ar]!;
                                  return _buildCatButton(e.key, name, _selectedCat == e.key);
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 250,
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.bgLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.search, size: 16, color: AppColors.textMuted),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    textAlign: TextAlign.right,
                                    onChanged: (v) => setState(() => _search = v),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      hintText: t('searchPlaceholder'),
                                      hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontFamily: AppFonts.cairo),
                                    ),
                                    style: const TextStyle(fontSize: 12, fontFamily: AppFonts.cairo),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Grid
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(child: Text(t('noItems'), style: const TextStyle(color: AppColors.textMuted, fontFamily: AppFonts.cairo)))
                          : GridView.builder(
                              padding: const EdgeInsets.all(24),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isMobile ? 2 : 4,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, i) {
                                final item = filtered[i];
                                final inCart = widget.cart.where((c) => c.item.id == item.id).toList();
                                final inCartCount = inCart.isNotEmpty ? inCart.first.qty : 0;
                                return _buildMenuItem(item, inCartCount);
                              },
                            ),
                    ),
                  ],
                ),
              ),

              // Cart Panel (Desktop only)
              if (!isMobile) cartPanel,
            ],
          ),
        );
      },
    );
  }

  Widget _buildCatButton(String id, String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () => setState(() => _selectedCat = id),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.navy : AppColors.bgLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: AppFonts.cairo,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(MenuItemModel item, int inCartCount) {
    return InkWell(
      onTap: () => widget.onAdd(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: inCartCount > 0 ? AppColors.gold : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, _, __) => Container(color: AppColors.bgLight),
                    ),
                  ),
                  if (inCartCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          inCartCount.toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.nameKu,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontFamily: AppFonts.cairo, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark, height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.nameAr,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontFamily: AppFonts.cairo, fontSize: 12, color: AppColors.textLightMuted, height: 1.2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.navy,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.plus, color: Colors.white, size: 14),
                      ),
                      Text(
                        fp(item.priceIQD),
                        style: const TextStyle(fontFamily: AppFonts.jakarta, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.gold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem(CartItem ci) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => widget.onRemove(ci.item.id),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(LucideIcons.trash2, size: 12, color: AppColors.errorText),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(ci.item.nameKu, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: AppFonts.cairo)),
                    Text(ci.item.nameAr, style: const TextStyle(fontSize: 10, color: AppColors.textLightMuted, fontFamily: AppFonts.cairo)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fp(ci.item.priceIQD * ci.qty),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: AppFonts.jakarta),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () => widget.onQty(ci.item.id, 1),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(color: AppColors.navy, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.plus, size: 10, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 24,
                    child: Text(
                      ci.qty.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark, fontFamily: AppFonts.jakarta),
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.onQty(ci.item.id, -1),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: AppColors.borderLight), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(LucideIcons.minus, size: 10, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
