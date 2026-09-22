import 'dart:math';
import 'models.dart';

const Map<Lang, Map<String, String>> TR = {
  Lang.ku: {
    "appName":"MM House", "pos":"کاشیر", "history":"مێژووی فرۆشتن", "daily":"ڕاپۆرتی ڕۆژانە",
    "monthly":"ڕاپۆرتی مانگانە", "yearly":"ڕاپۆرتی ساڵانە", "menuMgmt":"بەڕێوەبردنی مینیۆ",
    "settings":"ڕێکخستنەکان", "logout":"چوونەدەرەوە", "all":"هەموو",
    "newOrder":"داواکاری نوێ", "clearOrder":"سڕینەوە", "checkout":"پرداخت", "print":"چاپکردن",
    "subtotal":"کۆی جیاواز", "discount":"داشکاندن", "total":"کۆی گشتی",
    "paid":"پرداخت کرا", "change":"پاشگەڕاندنەوە", "cash":"نەقد", "card":"کارت",
    "orderNum":"ژمارەی داواکاری", "cashier":"کاشیر", "totalRevenue":"کۆی داهات",
    "totalOrders":"کۆی داواکاری", "avgOrder":"ناوەندی داواکاری", "bestItems":"باشترین بابەتەکان",
    "bestCats":"باشترین جۆرەکان", "payBreakdown":"جۆری پرداخت", "salesTrend":"ڕوانگەی فرۆشتن",
    "thankYou":"سوپاس بۆ داواکاریەکەتان", "active":"چالاک", "inactive":"ناچالاک",
    "save":"پاشەکەوتکردن", "language":"زمان", "kurdish":"کوردی (سۆرانی)", "arabic":"عەرەبی",
    "confirmClear":"دڵنیای لە سڕینەوەی داواکاری؟", "yes":"بەڵێ", "no":"نەخێر",
    "reprint":"دووبارە چاپکردن", "status":"دۆخ", "completed":"تەواوبوو",
    "cancelled":"هەڵوەشاوە", "refunded":"گەڕاندرایەوە", "receipt":"وەصل", "close":"داخستن",
    "payMethod":"جۆری پرداخت", "addItem":"زیادکردنی بابەتێک", "editItem":"دەستکاریکردن",
    "kurdishName":"ناوی کوردی", "arabicName":"ناوی عەرەبی", "price":"نرخ",
    "category":"جۆر", "actions":"کردارەکان", "from":"لە", "to":"بۆ",
    "cashierName":"ناوی کاشیر", "qty":"ژمارە", "searchPlaceholder":"گەڕان بکە...",
    "revenue":"داهات", "orders":"داواکاری", "filterDate":"فلتەری بەروار",
    "emptyCart":"داواکاری بەتاڵە", "confirmPayment":"پشتڕاستکردنەوەی پرداخت",
    "enterPaid":"بڕی پرداخت بنووسە", "printerSettings":"ڕێکخستنی چاپکەر",
    "appSettings":"ڕێکخستنی سیستەم", "name":"ناو",
    "profileSettings": "ڕێکخستنی پرۆفایل",
  },
  Lang.ar: {
    "appName":"MM House", "pos":"الكاشير", "history":"سجل المبيعات", "daily":"التقارير اليومية",
    "monthly":"التقارير الشهرية", "yearly":"التقارير السنوية", "menuMgmt":"إدارة القائمة",
    "settings":"الإعدادات", "logout":"تسجيل الخروج", "all":"الكل",
    "newOrder":"طلب جديد", "clearOrder":"مسح", "checkout":"الدفع", "print":"طباعة",
    "subtotal":"المجموع الفرعي", "discount":"الخصم", "total":"المجموع الكلي",
    "paid":"المدفوع", "change":"الباقي", "cash":"نقدي", "card":"بطاقة",
    "orderNum":"رقم الطلب", "cashier":"الكاشير", "totalRevenue":"إجمالي الإيرادات",
    "totalOrders":"إجمالي الطلبات", "avgOrder":"متوسط الطلب", "bestItems":"أفضل العناصر",
    "bestCats":"أفضل الفئات", "payBreakdown":"تفصيل الدفع", "salesTrend":"مؤشر المبيعات",
    "thankYou":"شكراً لطلبكم", "active":"نشط", "inactive":"غير نشط",
    "save":"حفظ", "language":"اللغة", "kurdish":"الكردية (السورانية)", "arabic":"العربية",
    "confirmClear":"هل أنت متأكد من مسح الطلب؟", "yes":"نعم", "no":"لا",
    "reprint":"إعادة الطباعة", "status":"الحالة", "completed":"مكتمل",
    "cancelled":"ملغى", "refunded":"مسترد", "receipt":"الفاتورة", "close":"إغلاق",
    "payMethod":"طريقة الدفع", "addItem":"إضافة عنصر", "editItem":"تعديل",
    "kurdishName":"الاسم الكردي", "arabicName":"الاسم العربي", "price":"السعر",
    "category":"الفئة", "actions":"الإجراءات", "from":"من", "to":"إلى",
    "cashierName":"اسم الكاشير", "qty":"الكمية", "searchPlaceholder":"ابحث...",
    "revenue":"الإيرادات", "orders":"الطلبات", "filterDate":"تصفية بالتاريخ",
    "emptyCart":"الطلب فارغ", "confirmPayment":"تأكيد الدفع",
    "enterPaid":"أدخل المبلغ المدفوع", "printerSettings":"إعدادات الطابعة",
    "appSettings":"إعدادات النظام", "name":"الاسم",
    "profileSettings": "إعدادات الملف الشخصي",
  }
};

const Map<String, Map<Lang, String>> CATS = {
  "pasta":    { Lang.ku:"پاستا و برینج",        Lang.ar:"معكرونة وأرز" },
  "grills":   { Lang.ku:"کباب و خواردنی تەواو", Lang.ar:"مشاوي وأكلات تقليدية" },
  "shawarma": { Lang.ku:"شاوەرما و بێرگەر",     Lang.ar:"شاورما وبرجر" },
  "kentucky": { Lang.ku:"کینتاکی",              Lang.ar:"كنتاكي" },
  "sides":    { Lang.ku:"خواردنی لاوەکی",       Lang.ar:"مقبلات وأطباق جانبية" },
  "drinks":   { Lang.ku:"خواردنەوە",            Lang.ar:"مشروبات" },
};

String u(String id) => 'https://images.unsplash.com/photo-$id?w=320&h=220&fit=crop&auto=format&q=80';

final List<MenuItemModel> INITIAL_MENU = [
  MenuItemModel(id:"p01", nameKu:"پاستای ئەلفریدۆ",                     nameAr:"معكرونة الفريدو",             price:5000,  cat:"pasta",    img:u("1621996346565-e3dbc646d9a9"), active:true),
  MenuItemModel(id:"p02", nameKu:"پاستای ئەلفریدۆ لەگەڵ گۆشت",          nameAr:"معكرونة الفريدو باللحم",      price:5000,  cat:"pasta",    img:u("1563379926898-05f4575a45d8"), active:true),
  MenuItemModel(id:"p03", nameKu:"پاستای سۆسی سوور لەگەڵ مریشک",        nameAr:"معكرونة صلصة حمراء بالدجاج", price:5000,  cat:"pasta",    img:u("1567608346072-b31551b7ee48"), active:true),
  MenuItemModel(id:"p04", nameKu:"پاستای سۆسی تێکەڵ",                   nameAr:"معكرونة بصلصات مشكلة",       price:5000,  cat:"pasta",    img:u("1621996346565-e3dbc646d9a9"), active:true),
  MenuItemModel(id:"p05", nameKu:"پاستای سۆس و گۆشت",                   nameAr:"معكرونة بالصلصة واللحم",     price:5000,  cat:"pasta",    img:u("1563379926898-05f4575a45d8"), active:true),
  MenuItemModel(id:"p06", nameKu:"پاستای موزاریلا",                      nameAr:"معكرونة بجبن الموزاريلا",    price:6000,  cat:"pasta",    img:u("1569050467447-ce54b3bbc37d"), active:true),
  MenuItemModel(id:"p07", nameKu:"ریزۆ",                                 nameAr:"ريزو",                        price:5000,  cat:"pasta",    img:u("1476124369491-e7addf5db371"), active:true),
  MenuItemModel(id:"p08", nameKu:"برینج لەگەڵ مەرەق (شیلە)",            nameAr:"أرز مع المرق (شيلة)",        price:3000,  cat:"pasta",    img:u("1536304929831-ee1ca9d44906"), active:true),
  MenuItemModel(id:"p09", nameKu:"کباب لەگەڵ برینج",                    nameAr:"كباب مع أرز",                 price:5000,  cat:"pasta",    img:u("1544025162-d76538fd41e3"),   active:true),
  MenuItemModel(id:"p10", nameKu:"تیکای مریشک لەگەڵ برینج",             nameAr:"تكة دجاج مع أرز",            price:4000,  cat:"pasta",    img:u("1598103442097-8b74394b95c8"), active:true),
  MenuItemModel(id:"p11", nameKu:"تیکای گۆشت لەگەڵ برینج",             nameAr:"تكة لحم مع أرز",             price:5000,  cat:"pasta",    img:u("1555939594-58d7cb561ad1"),   active:true),
  MenuItemModel(id:"p12", nameKu:"بریانی MM House",                     nameAr:"برياني MM House",             price:5000,  cat:"pasta",    img:u("1603360946369-dc9bb6258143"), active:true),
  MenuItemModel(id:"p13", nameKu:"برینج لەگەڵ مریشکی قواتە",           nameAr:"أرز مع دجاج قواطة",          price:5500,  cat:"pasta",    img:u("1536304929831-ee1ca9d44906"), active:true),
  MenuItemModel(id:"p14", nameKu:"برینج لەگەڵ گازی گۆشت",              nameAr:"أرز مع غاز اللحم",           price:5000,  cat:"pasta",    img:u("1603360946369-dc9bb6258143"), active:true),
  MenuItemModel(id:"p15", nameKu:"برینج لەگەڵ گازی مریشک",             nameAr:"أرز مع غاز الدجاج",          price:5000,  cat:"pasta",    img:u("1598103442097-8b74394b95c8"), active:true),
  
  MenuItemModel(id:"g01", nameKu:"یەک شیش کباب",                       nameAr:"شيش كباب واحد",               price:3000,  cat:"grills",   img:u("1544025162-d76538fd41e3"),   active:true),
  MenuItemModel(id:"g02", nameKu:"جگەر",                                nameAr:"كبد",                         price:3000,  cat:"grills",   img:u("1555939594-58d7cb561ad1"),   active:true),
  MenuItemModel(id:"g03", nameKu:"تیکای مریشک",                        nameAr:"تكة دجاج",                    price:2000,  cat:"grills",   img:u("1532550907401-a500c9a57435"), active:true),
  MenuItemModel(id:"g04", nameKu:"باڵی مریشک",                         nameAr:"أجنحة دجاج",                  price:3500,  cat:"grills",   img:u("1527477396000-e27163b481c2"), active:true),
  MenuItemModel(id:"g05", nameKu:"دوو شیش کباب",                       nameAr:"شيشتا كباب",                  price:9000,  cat:"grills",   img:u("1544025162-d76538fd41e3"),   active:true),
  MenuItemModel(id:"g06", nameKu:"تەبسی کباب تێکەڵ MM House",         nameAr:"صينية مشاوي مشكلة MM House",  price:25000, cat:"grills",   img:u("1555939594-58d7cb561ad1"),   active:true),
  MenuItemModel(id:"g07", nameKu:"یەک شیش کباب تێکەڵ (محشی)",         nameAr:"شيش كباب مشكل (محشي)",        price:3500,  cat:"grills",   img:u("1544025162-d76538fd41e3"),   active:true),
  MenuItemModel(id:"g08", nameKu:"تەشریبی گاز",                        nameAr:"تشريب غاز",                   price:5000,  cat:"grills",   img:u("1529006557810-274b9b2fc783"), active:true),
  MenuItemModel(id:"g09", nameKu:"مریشکی تاوکراوی سادە",               nameAr:"دجاج مشوي بسيط",              price:13000, cat:"grills",   img:u("1598103442097-8b74394b95c8"), active:true),
  MenuItemModel(id:"g10", nameKu:"مریشکی تاوکراو لەگەڵ لیمۆ",         nameAr:"دجاج مشوي بالليمون",          price:14000, cat:"grills",   img:u("1598103442097-8b74394b95c8"), active:true),
  MenuItemModel(id:"g11", nameKu:"مریشکی تاوکراو لەگەڵ مەنگۆ",        nameAr:"دجاج مشوي بالمانجو",          price:14000, cat:"grills",   img:u("1598103442097-8b74394b95c8"), active:true),
  MenuItemModel(id:"g12", nameKu:"مریشکی تاوکراو لەگەڵ بیبەر",        nameAr:"دجاج مشوي بالفلفل",           price:14000, cat:"grills",   img:u("1598103442097-8b74394b95c8"), active:true),
  MenuItemModel(id:"g13", nameKu:"ساندویچی گازی مریشک",                nameAr:"ساندويتش غاز دجاج",           price:3500,  cat:"grills",   img:u("1550950158-d0d960dff596"),   active:true),
  MenuItemModel(id:"g14", nameKu:"گازی گۆشت",                          nameAr:"غاز اللحم",                   price:4000,  cat:"grills",   img:u("1555939594-58d7cb561ad1"),   active:true),
  MenuItemModel(id:"g15", nameKu:"یەک تەبسی گازی گۆشت",               nameAr:"صينية غاز لحم",               price:6000,  cat:"grills",   img:u("1555939594-58d7cb561ad1"),   active:true),
  
  MenuItemModel(id:"s01", nameKu:"یەک تەبسی شاوەرما",                  nameAr:"صينية شاورما",                price:6000,  cat:"shawarma", img:u("1529006557810-274b9b2fc783"), active:true),
  MenuItemModel(id:"s02", nameKu:"شاوەرمای مریشک",                     nameAr:"شاورما دجاج",                 price:2000,  cat:"shawarma", img:u("1529006557810-274b9b2fc783"), active:true),
  MenuItemModel(id:"s03", nameKu:"شاوەرمای گۆشت",                      nameAr:"شاورما لحم",                  price:2500,  cat:"shawarma", img:u("1529006557810-274b9b2fc783"), active:true),
  MenuItemModel(id:"s04", nameKu:"بێرگەر",                              nameAr:"برجر",                        price:3500,  cat:"shawarma", img:u("1568901346375-23c9450c58cd"), active:true),
  MenuItemModel(id:"s05", nameKu:"بێرگەری گاوی لەگەڵ پەنیر",           nameAr:"برجر لحم بالجبن",             price:4000,  cat:"shawarma", img:u("1568901346375-23c9450c58cd"), active:true),
  MenuItemModel(id:"s06", nameKu:"بێرگەری مریشک",                      nameAr:"برجر دجاج",                   price:3000,  cat:"shawarma", img:u("1550950158-d0d960dff596"),   active:true),
  MenuItemModel(id:"s07", nameKu:"بێرگەری مریشک لەگەڵ پەنیر",         nameAr:"برجر دجاج بالجبن",            price:3500,  cat:"shawarma", img:u("1550950158-d0d960dff596"),   active:true),
  MenuItemModel(id:"s08", nameKu:"بێرگەری تاوی ئاگر",                  nameAr:"برجر مشوي على النار",         price:5000,  cat:"shawarma", img:u("1568901346375-23c9450c58cd"), active:true),
  
  MenuItemModel(id:"k01", nameKu:"مریشکی کینتاکی — ١ پارچە",          nameAr:"دجاج كنتاكي — قطعة",          price:2000,  cat:"kentucky", img:u("1562967914-608f82629710"),   active:true),
  MenuItemModel(id:"k02", nameKu:"مریشکی کینتاکی — ٢ پارچە",          nameAr:"دجاج كنتاكي — قطعتان",        price:4000,  cat:"kentucky", img:u("1562967914-608f82629710"),   active:true),
  MenuItemModel(id:"k03", nameKu:"مریشکی کینتاکی — ٤-٥ پارچە",        nameAr:"دجاج كنتاكي — ٤-٥ قطع",      price:7500,  cat:"kentucky", img:u("1562967914-608f82629710"),   active:true),
  MenuItemModel(id:"k04", nameKu:"مریشکی کینتاکی — ٨ پارچە",          nameAr:"دجاج كنتاكي — ٨ قطع",        price:14500, cat:"kentucky", img:u("1562967914-608f82629710"),   active:true),
  
  MenuItemModel(id:"a01", nameKu:"بەژێی پیاز",                         nameAr:"باجي بصل",                    price:3000,  cat:"sides",    img:u("1541014741259-de529411b96a"), active:true),
  MenuItemModel(id:"a02", nameKu:"سامبووسای گۆشت",                     nameAr:"سمبوسة لحم",                  price:3500,  cat:"sides",    img:u("1601050690597-df0568f70950"), active:true),
  MenuItemModel(id:"a03", nameKu:"سامبووسای سەوزە",                    nameAr:"سمبوسة خضار",                 price:3000,  cat:"sides",    img:u("1601050690597-df0568f70950"), active:true),
  MenuItemModel(id:"a04", nameKu:"فینگەر فرایز",                       nameAr:"بطاطا مقلية",                 price:2000,  cat:"sides",    img:u("1573080496219-bb080dd4f877"), active:true),
  MenuItemModel(id:"a05", nameKu:"فینگەر فرایز لەگەڵ سۆس",            nameAr:"بطاطا مقلية بالصوص",          price:2500,  cat:"sides",    img:u("1573080496219-bb080dd4f877"), active:true),
  MenuItemModel(id:"a06", nameKu:"فینگەر وێجز لەگەڵ گۆشت",            nameAr:"بطاطا ويدجز باللحم",          price:6000,  cat:"sides",    img:u("1573080496219-bb080dd4f877"), active:true),
  MenuItemModel(id:"a07", nameKu:"فینگەر وێجز لەگەڵ سۆس",             nameAr:"بطاطا ويدجز بالصوص",          price:4000,  cat:"sides",    img:u("1573080496219-bb080dd4f877"), active:true),
  MenuItemModel(id:"a08", nameKu:"فەلافەل",                            nameAr:"فلافل",                       price:750,   cat:"sides",    img:u("1601050690597-df0568f70950"), active:true),
  MenuItemModel(id:"a09", nameKu:"فەلافەلی تیژ لەگەڵ نان",            nameAr:"فلافل حار مع خبز النان",       price:1000,  cat:"sides",    img:u("1601050690597-df0568f70950"), active:true),
  MenuItemModel(id:"a10", nameKu:"کروکێت",                             nameAr:"كروكيت",                      price:2500,  cat:"sides",    img:u("1573080496219-bb080dd4f877"), active:true),
  MenuItemModel(id:"a11", nameKu:"حەلقەی پیاز",                        nameAr:"حلقات البصل",                 price:2500,  cat:"sides",    img:u("1541014741259-de529411b96a"), active:true),
  MenuItemModel(id:"a12", nameKu:"تەبسی پێشخواردنی گەورە",            nameAr:"صينية مقبلات كبيرة",          price:4000,  cat:"sides",    img:u("1577303935007-0d306ee638cf"), active:true),
  MenuItemModel(id:"a13", nameKu:"تەبسی پێشخواردنی ناوەند",           nameAr:"صينية مقبلات وسط",            price:3000,  cat:"sides",    img:u("1577303935007-0d306ee638cf"), active:true),
  MenuItemModel(id:"a14", nameKu:"تەبسی پێشخواردنی بچووک",            nameAr:"صينية مقبلات صغيرة",          price:2000,  cat:"sides",    img:u("1577303935007-0d306ee638cf"), active:true),
  
  MenuItemModel(id:"d01", nameKu:"ئاو",                                nameAr:"ماء",                         price:250,   cat:"drinks",   img:u("1548839140-29a749e1cf4d"),   active:true),
  MenuItemModel(id:"d02", nameKu:"پێپسی",                              nameAr:"بيبسي",                       price:500,   cat:"drinks",   img:u("1622483767028-3f66f32aef97"), active:true),
  MenuItemModel(id:"d03", nameKu:"کۆلا",                               nameAr:"كولا",                        price:500,   cat:"drinks",   img:u("1622483767028-3f66f32aef97"), active:true),
  MenuItemModel(id:"d04", nameKu:"سپرایت",                             nameAr:"سبرايت",                      price:500,   cat:"drinks",   img:u("1622483767028-3f66f32aef97"), active:true),
  MenuItemModel(id:"d05", nameKu:"پێپسی دایت",                        nameAr:"بيبسي دايت",                  price:500,   cat:"drinks",   img:u("1622483767028-3f66f32aef97"), active:true),
  MenuItemModel(id:"d06", nameKu:"پێپسی زیرۆ",                        nameAr:"بيبسي زيرو",                  price:500,   cat:"drinks",   img:u("1622483767028-3f66f32aef97"), active:true),
  MenuItemModel(id:"d07", nameKu:"دۆ",                                 nameAr:"دو",                          price:1000,  cat:"drinks",   img:u("1558113583-d75f23fcb8a9"),   active:true),
  MenuItemModel(id:"d08", nameKu:"ماستاو",                             nameAr:"ماستاو (عيران)",               price:1000,  cat:"drinks",   img:u("1596151163116-98a5033814c2"), active:true),
  MenuItemModel(id:"d09", nameKu:"میراندا",                            nameAr:"ميراندا",                     price:500,   cat:"drinks",   img:u("1622483767028-3f66f32aef97"), active:true),
  MenuItemModel(id:"d10", nameKu:"فانتا",                              nameAr:"فانتا",                       price:500,   cat:"drinks",   img:u("1622483767028-3f66f32aef97"), active:true),
  MenuItemModel(id:"d11", nameKu:"سێڤ ئەپ",                           nameAr:"سفن أب",                      price:500,   cat:"drinks",   img:u("1622483767028-3f66f32aef97"), active:true),
  MenuItemModel(id:"d12", nameKu:"چای",                                nameAr:"شاي",                         price:250,   cat:"drinks",   img:u("1564890369478-c89ca3d9cde4"), active:true),
];

List<Order> generateSampleOrders() {
  final cashiers = ["ئارام احمد", "هەردى كریم", "ساران محمد", "كارزان عبدالله"];
  final pool = [
    {"id": "p01", "nameKu": "پاستای ئەلفریدۆ", "nameAr": "معكرونة الفريدو", "price": 5000.0},
    {"id": "p06", "nameKu": "پاستای موزاریلا", "nameAr": "معكرونة بجبن الموزاريلا", "price": 6000.0},
    {"id": "p12", "nameKu": "بریانی MM House", "nameAr": "برياني MM House", "price": 5000.0},
    {"id": "g01", "nameKu": "یەک شیش کباب", "nameAr": "شيش كباب واحد", "price": 3000.0},
    {"id": "g04", "nameKu": "باڵی مریشک", "nameAr": "أجنحة دجاج", "price": 3500.0},
    {"id": "g06", "nameKu": "تەبسی کباب تێکەڵ MM House", "nameAr": "صينية مشاوي مشكلة MM House", "price": 25000.0},
    {"id": "g09", "nameKu": "مریشکی تاوکراوی سادە", "nameAr": "دجاج مشوي بسيط", "price": 13000.0},
    {"id": "s02", "nameKu": "شاوەرمای مریشک", "nameAr": "شاورما دجاج", "price": 2000.0},
    {"id": "s04", "nameKu": "بێرگەر", "nameAr": "برجر", "price": 3500.0},
    {"id": "s05", "nameKu": "بێرگەری گاوی لەگەڵ پەنیر", "nameAr": "برجر لحم بالجبن", "price": 4000.0},
    {"id": "k01", "nameKu": "مریشکی کینتاکی — ١ پارچە", "nameAr": "دجاج كنتاكي — قطعة", "price": 2000.0},
    {"id": "k03", "nameKu": "مریشکی کینتاکی — ٤-٥ پارچە", "nameAr": "دجاج كنتاكي — ٤-٥ قطع", "price": 7500.0},
    {"id": "a04", "nameKu": "فینگەر فرایز", "nameAr": "بطاطا مقلية", "price": 2000.0},
    {"id": "a08", "nameKu": "فەلافەل", "nameAr": "فلافل", "price": 750.0},
    {"id": "d01", "nameKu": "ئاو", "nameAr": "ماء", "price": 250.0},
    {"id": "d02", "nameKu": "پێپسی", "nameAr": "بيبسي", "price": 500.0},
    {"id": "d12", "nameKu": "چای", "nameAr": "شاي", "price": 250.0},
    {"id": "g02", "nameKu": "جگەر", "nameAr": "كبد", "price": 3000.0},
    {"id": "p09", "nameKu": "کباب لەگەڵ برینج", "nameAr": "كباب مع أرز", "price": 5000.0},
    {"id": "a01", "nameKu": "بەژێی پیاز", "nameAr": "باجي بصل", "price": 3000.0},
  ];

  final orders = <Order>[];
  final statuses = [
    OrderStatus.completed, OrderStatus.completed, OrderStatus.completed,
    OrderStatus.completed, OrderStatus.completed, OrderStatus.completed,
    OrderStatus.completed, OrderStatus.completed, OrderStatus.cancelled, OrderStatus.refunded
  ];
  int num = 1;
  final rnd = Random();

  for (int day = 45; day >= 0; day--) {
    final base = DateTime.now().subtract(Duration(days: day));
    final count = rnd.nextInt(8) + 5;
    
    for (int i = 0; i < count; i++) {
      final hr = 10 + rnd.nextInt(11);
      final mn = rnd.nextInt(60);
      final d = DateTime(base.year, base.month, base.day, hr, mn);
      
      final itemCount = rnd.nextInt(4) + 1;
      final items = <OrderItem>[];
      
      for (int j = 0; j < itemCount; j++) {
        final randomItem = pool[rnd.nextInt(pool.length)];
        final id = randomItem["id"] as String;
        final nameKu = randomItem["nameKu"] as String;
        final nameAr = randomItem["nameAr"] as String;
        final price = randomItem["price"] as double;
        final qty = rnd.nextInt(3) + 1;
        
        final existingIndex = items.indexWhere((x) => x.id == id);
        if (existingIndex != -1) {
          final old = items[existingIndex];
          items[existingIndex] = OrderItem(
            id: old.id,
            nameKu: old.nameKu,
            nameAr: old.nameAr,
            price: old.price,
            qty: old.qty + qty
          );
        } else {
          items.add(OrderItem(id: id, nameKu: nameKu, nameAr: nameAr, price: price, qty: qty));
        }
      }
      
      final subtotal = items.fold<double>(0, (s, x) => s + (x.price * x.qty));
      final discount = rnd.nextDouble() < 0.1 ? ((subtotal * 0.05 / 500).floor() * 500).toDouble() : 0.0;
      final total = subtotal - discount;
      
      final payMethod = rnd.nextDouble() < 0.72 ? PayMethod.cash : PayMethod.card;
      final paid = payMethod == PayMethod.cash ? ((total / 1000).ceil() * 1000).toDouble() : total;
      final status = statuses[rnd.nextInt(statuses.length)];
      
      orders.add(Order(
        id: 'ord_$num',
        numStr: num.toString().padLeft(4, '0'),
        date: d,
        cashier: cashiers[rnd.nextInt(cashiers.length)],
        items: items,
        subtotal: subtotal,
        discount: discount,
        total: total,
        payMethod: payMethod,
        paid: paid,
        change: paid - total,
        status: status,
      ));
      num++;
    }
  }
  orders.sort((a, b) => b.date.compareTo(a.date));
  return orders;
}
