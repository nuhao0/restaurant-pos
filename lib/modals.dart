import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'models.dart';
import 'theme.dart';
import 'utils.dart';
import 'data.dart';

void showCheckoutModal({
  required BuildContext context,
  required List<CartItem> cart,
  required int orderNum,
  required String cashierName,
  required Lang lang,
  required Function(PayMethod, double, double, bool) onConfirm,
}) {
  showDialog(
    context: context,
    builder: (ctx) => _CheckoutModal(
      cart: cart,
      orderNum: orderNum,
      cashierName: cashierName,
      lang: lang,
      onConfirm: onConfirm,
    ),
  );
}

class _CheckoutModal extends StatefulWidget {
  final List<CartItem> cart;
  final int orderNum;
  final String cashierName;
  final Lang lang;
  final Function(PayMethod, double, double, bool) onConfirm;

  const _CheckoutModal({
    required this.cart,
    required this.orderNum,
    required this.cashierName,
    required this.lang,
    required this.onConfirm,
  });

  @override
  __CheckoutModalState createState() => __CheckoutModalState();
}

class __CheckoutModalState extends State<_CheckoutModal> {
  PayMethod _payMethod = PayMethod.cash;
  double _discount = 0;
  String _paidInput = "";

  @override
  Widget build(BuildContext context) {
    final t = (String k) => TR[widget.lang]?[k] ?? k;
    final subtotal = widget.cart.fold<double>(0, (s, ci) => s + (ci.item.price * ci.qty));
    final total = (subtotal - _discount) < 0 ? 0.0 : (subtotal - _discount);
    final paid = _payMethod == PayMethod.card ? total : (double.tryParse(_paidInput) ?? total); // Default to total if nothing typed
    final change = (paid - total) < 0 ? 0.0 : (paid - total);
    final canConfirm = _payMethod == PayMethod.card || paid >= total;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 440,
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t("confirmPayment"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 18, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            
            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxHeight: 160),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(12)),
                    child: SingleChildScrollView(
                      child: Column(
                        children: widget.cart.map((ci) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${nm(ci.item, widget.lang)} ×${ci.qty}", style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                                Text(fp(ci.item.price * ci.qty), style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t("subtotal"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                      Text(fp(subtotal), style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t("discount"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                      SizedBox(
                        width: 128,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          onChanged: (v) {
                            double val = double.tryParse(v) ?? 0;
                            if (val > subtotal) val = subtotal;
                            setState(() => _discount = val);
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "0",
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.borderLight)),
                          ),
                          style: const TextStyle(fontFamily: AppFonts.jakarta),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.borderLight),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t("total"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                      Text(fp(total), style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  Text(t("payMethod"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _payMethod = PayMethod.cash),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _payMethod == PayMethod.cash ? const Color(0xFFFDF8F0) : AppColors.white,
                              border: Border.all(color: _payMethod == PayMethod.cash ? AppColors.gold : AppColors.borderLight, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.banknote, size: 16, color: _payMethod == PayMethod.cash ? AppColors.gold : AppColors.textMuted),
                                const SizedBox(width: 8),
                                Text(t("cash"), style: TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: _payMethod == PayMethod.cash ? AppColors.gold : AppColors.textMuted)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _payMethod = PayMethod.card),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _payMethod == PayMethod.card ? const Color(0xFFFDF8F0) : AppColors.white,
                              border: Border.all(color: _payMethod == PayMethod.card ? AppColors.gold : AppColors.borderLight, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.creditCard, size: 16, color: _payMethod == PayMethod.card ? AppColors.gold : AppColors.textMuted),
                                const SizedBox(width: 8),
                                Text(t("card"), style: TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: _payMethod == PayMethod.card ? AppColors.gold : AppColors.textMuted)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  if (_payMethod == PayMethod.cash) ...[
                    Text(t("enterPaid"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 8),
                    TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      onChanged: (v) => setState(() => _paidInput = v),
                      decoration: InputDecoration(
                        hintText: fp(total),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight, width: 2)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.gold, width: 2)),
                      ),
                      style: const TextStyle(fontFamily: AppFonts.jakarta, fontSize: 16),
                    ),
                    if (paid >= total) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(t("change"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: Colors.green)),
                          Text(fp(change), style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: Colors.green)),
                        ],
                      ),
                    ],
                  ]
                ],
              ),
            ),
            
            // Footer
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(LucideIcons.printer, size: 16),
                      label: Text(widget.lang == Lang.ku ? "چاپکردن" : "طباعة وحفظ"),
                      onPressed: canConfirm ? () {
                        widget.onConfirm(_payMethod, paid, _discount, true);
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(LucideIcons.save, size: 16),
                      label: Text(widget.lang == Lang.ku ? "بێ چاپ" : "حفظ فقط"),
                      onPressed: canConfirm ? () {
                        widget.onConfirm(_payMethod, paid, _discount, false);
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showReceiptModal({
  required BuildContext context,
  required Order order,
  required Lang lang,
}) {
  showDialog(
    context: context,
    builder: (ctx) => _ReceiptModal(order: order, lang: lang),
  );
}

class _ReceiptModal extends StatelessWidget {
  final Order order;
  final Lang lang;

  const _ReceiptModal({required this.order, required this.lang});

  @override
  Widget build(BuildContext context) {
    final t = (String k) => TR[lang]?[k] ?? k;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 380,
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(LucideIcons.printer, size: 48, color: AppColors.gold),
                  const SizedBox(height: 16),
                  const Text("MM HOUSE", style: TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.navy)),
                  Text(lang == Lang.ku ? "خواردنی خێرا" : "وجبات سريعة", style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t("orderNum"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                      Text("#${order.numStr}", style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t("cashierName"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                      Text(order.cashier, style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t("date"), style: const TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                      Text("${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString().padLeft(2, '0')} ${order.date.hour}:${order.date.minute.toString().padLeft(2, '0')}", style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.borderLight),
                  const SizedBox(height: 16),
                  ...order.items.map((i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text("${lang == Lang.ku ? i.nameKu : i.nameAr} ×${i.qty}", style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark))),
                          Text(fp(i.price * i.qty), style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.borderLight),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t("total"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
                      Text(fp(order.total), style: const TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(LucideIcons.printer, size: 16),
                      label: Text(lang == Lang.ku ? "چاپکردن" : "طباعة"),
                      onPressed: () {
                        // In a real app this would trigger a bluetooth/usb printer
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(lang == Lang.ku ? "نێردرا بۆ چاپکەر" : "تم الإرسال للطابعة")));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: AppColors.borderLight),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(t("no"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

