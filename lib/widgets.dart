import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'models.dart';
import 'theme.dart';
import 'utils.dart';
import 'data.dart';
import 'dart:async';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final Color color;
  final IconData icon;

  const StatCard({
    Key? key,
    required this.label,
    required this.value,
    this.sub,
    this.color = AppColors.gold,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                    fontFamily: AppFonts.cairo,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                    fontFamily: AppFonts.jakarta,
                    height: 1.1,
                  ),
                ),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    sub!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLightMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final OrderStatus status;
  final Lang lang;

  const StatusBadge({Key? key, required this.status, required this.lang})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label = "";
    Color bg = Colors.transparent;
    Color text = Colors.transparent;

    final String Function(String) t = (k) => TR[lang]?[k] ?? k;

    switch (status) {
      case OrderStatus.completed:
        bg = AppColors.successBg;
        text = AppColors.successText;
        label = t("completed");
        break;
      case OrderStatus.cancelled:
        bg = AppColors.errorBg;
        text = AppColors.errorText;
        label = t("cancelled");
        break;
      case OrderStatus.refunded:
        bg = AppColors.warningBg;
        text = AppColors.warningText;
        label = t("refunded");
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: AppFonts.cairo,
        ),
      ),
    );
  }
}

class Sidebar extends StatelessWidget {
  final ScreenType screen;
  final Lang lang;
  final ValueChanged<ScreenType> onNavigate;
  final VoidCallback onLogout;

  const Sidebar({
    Key? key,
    required this.screen,
    required this.lang,
    required this.onNavigate,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = (String k) => TR[lang]?[k] ?? k;

    final navItems = [
      {'id': ScreenType.pos, 'label': t('pos'), 'icon': LucideIcons.home},
      {'id': ScreenType.history, 'label': t('history'), 'icon': LucideIcons.list},
      {'id': ScreenType.reports, 'label': t('daily'), 'icon': LucideIcons.barChart2},
      {'id': ScreenType.menu, 'label': t('menuMgmt'), 'icon': LucideIcons.package},
      {'id': ScreenType.settings, 'label': t('settings'), 'icon': LucideIcons.settings},
    ];

    return Container(
      width: 224,
      color: AppColors.navy,
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08))),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "MM",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      fontFamily: AppFonts.jakarta,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "MM House",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        fontFamily: AppFonts.jakarta,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "نظام المبيعات",
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 10,
                        fontFamily: AppFonts.cairo,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Nav
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              children: navItems.map((item) {
                final id = item['id'] as ScreenType;
                final isSelected = screen == id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: InkWell(
                    onTap: () => onNavigate(id),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.gold : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'] as IconData,
                            size: 18,
                            color: isSelected ? AppColors.textDark : Colors.white.withOpacity(0.65),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['label'] as String,
                              style: TextStyle(
                                color: isSelected ? AppColors.textDark : Colors.white.withOpacity(0.65),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppFonts.cairo,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              LucideIcons.chevronRight,
                              size: 14,
                              color: AppColors.textDark,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Logout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white.withOpacity(0.08))),
            ),
            child: InkWell(
              onTap: onLogout,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Icon(LucideIcons.logOut, size: 16, color: Colors.white.withOpacity(0.5)),
                    const SizedBox(width: 12),
                    Text(
                      t('logout'),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.cairo,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatefulWidget {
  final Lang lang;
  final String cashierName;
  final VoidCallback onLangToggle;
  final bool isMobile;

  const TopBar({
    Key? key,
    required this.lang,
    required this.cashierName,
    required this.onLangToggle,
    this.isMobile = false,
  }) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: widget.isMobile ? null : const Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (!widget.isMobile) const Icon(LucideIcons.calendar, size: 13, color: AppColors.textLightMuted),
              if (!widget.isMobile) const SizedBox(width: 6),
              if (!widget.isMobile) Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontFamily: AppFonts.jakarta,
                ),
              ),
              if (!widget.isMobile) const SizedBox(width: 16),
              if (!widget.isMobile) const Icon(LucideIcons.clock, size: 13, color: AppColors.textLightMuted),
              if (!widget.isMobile) const SizedBox(width: 6),
              if (!widget.isMobile) Text(
                timeStr,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  fontFamily: AppFonts.jakarta,
                ),
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: widget.onLangToggle,
                icon: const Icon(LucideIcons.languages, size: 13, color: AppColors.textDark),
                label: Text(
                  widget.lang == Lang.ku ? "کوردی" : "عربي",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    fontFamily: AppFonts.cairo,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderLight),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  minimumSize: const Size(0, 32),
                ),
              ),
              if (!widget.isMobile) const SizedBox(width: 12),
              if (!widget.isMobile) Container(
                width: 1,
                height: 24,
                color: AppColors.borderLight,
              ),
              if (!widget.isMobile) const SizedBox(width: 12),
              if (!widget.isMobile) Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.cashierName.isNotEmpty ? widget.cashierName[0] : "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (!widget.isMobile) const SizedBox(width: 8),
              if (!widget.isMobile) Text(
                widget.cashierName,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  fontFamily: AppFonts.cairo,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
