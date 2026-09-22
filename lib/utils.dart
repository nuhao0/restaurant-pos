import 'package:intl/intl.dart';
import 'models.dart';

String fp(double n) {
  final format = NumberFormat("#,##0", "en_US");
  return "${format.format(n)} د.ع";
}

String fd(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}

String ft(DateTime date) {
  return DateFormat('HH:mm').format(date);
}

String nm(dynamic item, Lang lang) {
  if (lang == Lang.ku) {
    return item.nameKu;
  }
  return item.nameAr;
}
