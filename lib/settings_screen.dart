import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';
import 'theme.dart';
import 'data.dart';
import 'auth_screens.dart';

class SettingsScreen extends StatefulWidget {
  final Lang lang;
  final String cashierName;
  final bool autoPrint;
  final Function(Lang) onLangChange;
  final Function(String) onCashierChange;
  final Function(bool) onAutoPrintChange;

  const SettingsScreen({
    Key? key,
    required this.lang,
    required this.cashierName,
    required this.autoPrint,
    required this.onLangChange,
    required this.onCashierChange,
    required this.onAutoPrintChange,
  }) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _nameInput;

  @override
  void initState() {
    super.initState();
    _nameInput = widget.cashierName;
  }

  @override
  Widget build(BuildContext context) {
    final t = (String k) => TR[widget.lang]?[k] ?? k;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 672),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t("settings"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.textDark)),
              const SizedBox(height: 24),

              // Profile Settings
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(t("profileSettings"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderLight, height: 1),
                    const SizedBox(height: 16),
                    
                    Text(t("cashierName"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: _nameInput)..selection = TextSelection.collapsed(offset: _nameInput.length),
                            onChanged: (v) => _nameInput = v,
                            textDirection: TextDirection.rtl,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.borderLight)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.gold, width: 2)),
                            ),
                            style: const TextStyle(fontFamily: AppFonts.cairo),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () => widget.onCashierChange(_nameInput),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            textStyle: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold),
                          ),
                          child: Text(t("save")),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Printer Settings
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(t("printerSettings") ?? "ڕێکخستنی چاپکەر", style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderLight, height: 1),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Switch(
                            value: widget.autoPrint,
                            onChanged: widget.onAutoPrintChange,
                            activeColor: AppColors.gold,
                          ),
                          Text(widget.lang == Lang.ku ? "چاپکردنی وەصل بە شێوەی خۆکار" : "طباعة الفاتورة تلقائياً", style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Cloud Settings
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(widget.lang == Lang.ku ? "خەزنکردن لە کلاود (Cloud Sync)" : "مزامنة مع الكلاود (Cloud Sync)", style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderLight, height: 1),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (c) => const Center(child: CircularProgressIndicator()),
                        );
                        try {
                          final batch = FirebaseFirestore.instance.batch();
                          for (var item in INITIAL_MENU) {
                            final doc = FirebaseFirestore.instance.collection('menu').doc(item.id);
                            batch.set(doc, item.toJson());
                          }
                          await batch.commit();
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu synced to Cloud successfully!')));
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \$e')));
                          }
                        }
                      },
                      icon: const Icon(Icons.cloud_upload),
                      label: Text(widget.lang == Lang.ku ? "بەرزکردنەوەی مەنیو بۆ کلاود" : "رفع القائمة إلى الكلاود", style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Language
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(t("language"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderLight, height: 1),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => widget.onLangChange(Lang.ku),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: widget.lang == Lang.ku ? const Color(0xFFFDF8F0) : AppColors.white,
                                border: Border.all(color: widget.lang == Lang.ku ? AppColors.gold : AppColors.borderLight, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.languages, size: 16, color: widget.lang == Lang.ku ? AppColors.gold : AppColors.textMuted),
                                  const SizedBox(width: 8),
                                  Text(t("kurdish"), style: TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: widget.lang == Lang.ku ? AppColors.gold : AppColors.textMuted)),
                                  if (widget.lang == Lang.ku) ...[
                                    const SizedBox(width: 8),
                                    const Icon(LucideIcons.checkCircle, size: 14, color: AppColors.gold),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: () => widget.onLangChange(Lang.ar),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: widget.lang == Lang.ar ? const Color(0xFFFDF8F0) : AppColors.white,
                                border: Border.all(color: widget.lang == Lang.ar ? AppColors.gold : AppColors.borderLight, width: 2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(LucideIcons.languages, size: 16, color: widget.lang == Lang.ar ? AppColors.gold : AppColors.textMuted),
                                  const SizedBox(width: 8),
                                  Text(t("arabic"), style: TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: widget.lang == Lang.ar ? AppColors.gold : AppColors.textMuted)),
                                  if (widget.lang == Lang.ar) ...[
                                    const SizedBox(width: 8),
                                    const Icon(LucideIcons.checkCircle, size: 14, color: AppColors.gold),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // App Settings
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(t("appSettings"), style: const TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.borderLight, height: 1),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("v2.1.0", style: TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          const Text("نسخەی سیستەم", style: TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.borderLight, height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("IQD — د.ع", style: TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                          const Text("دراو", style: TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    const Divider(color: AppColors.borderLight, height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("MM House", style: TextStyle(fontFamily: AppFonts.jakarta, fontWeight: FontWeight.bold, color: AppColors.gold)),
                          const Text("ناوی ڕستۆران", style: TextStyle(fontFamily: AppFonts.cairo, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Manage Employees (Admin only)
              Container(
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                constraints: const BoxConstraints(maxHeight: 500),
                child: const EmployeesScreen(),
              ),
              const SizedBox(height: 20),

              // Migrate Legacy Data (Admin only)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Migrate Legacy Data', style: TextStyle(fontFamily: AppFonts.cairo, fontWeight: FontWeight.bold, color: AppColors.textDark)),
                    const SizedBox(height: 12),
                    const Text('If you have existing menu items and orders from before authentication was added, click here to assign them to your restaurant account. This is a one-time operation.', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final userProvider = UserProvider.of(context);
                        if (userProvider == null) return;
                        
                        showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
                        
                        try {
                          final batch = FirebaseFirestore.instance.batch();
                          
                          // Migrate menu
                          final menuSnap = await FirebaseFirestore.instance.collection('menu').get();
                          for (var doc in menuSnap.docs) {
                            if (!(doc.data().containsKey('restaurantId'))) {
                              batch.update(doc.reference, {'restaurantId': userProvider.restaurantId});
                            }
                          }
                          
                          // Migrate orders
                          final ordersSnap = await FirebaseFirestore.instance.collection('orders').get();
                          for (var doc in ordersSnap.docs) {
                            if (!(doc.data().containsKey('restaurantId'))) {
                              batch.update(doc.reference, {'restaurantId': userProvider.restaurantId});
                            }
                          }
                          
                          await batch.commit();
                          Navigator.pop(context); // close dialog
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Legacy data migrated successfully!')));
                        } catch (e) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.navy, padding: const EdgeInsets.symmetric(vertical: 16)),
                      child: const Text('Migrate Legacy Data', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
