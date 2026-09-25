import 'package:cloud_firestore/cloud_firestore.dart';

enum ScreenType { pos, history, reports, menu, settings }
enum Lang { ku, ar }
enum PayMethod { cash, card }
enum OrderStatus { completed, cancelled, refunded }
enum ReportTab { daily, monthly, yearly }

class MenuItemModel {
  String id;
  String categoryId;
  String nameKu;
  String nameAr;
  String nameEn;
  double priceIQD;
  String imageSearchQuery;
  String imageUrl;
  bool isAvailable;

  MenuItemModel({
    required this.id,
    required this.categoryId,
    required this.nameKu,
    required this.nameAr,
    required this.nameEn,
    required this.priceIQD,
    required this.imageSearchQuery,
    required this.imageUrl,
    required this.isAvailable,
  });

  MenuItemModel copyWith({
    String? id,
    String? categoryId,
    String? nameKu,
    String? nameAr,
    String? nameEn,
    double? priceIQD,
    String? imageSearchQuery,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      nameKu: nameKu ?? this.nameKu,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      priceIQD: priceIQD ?? this.priceIQD,
      imageSearchQuery: imageSearchQuery ?? this.imageSearchQuery,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String? ?? json['cat'] as String? ?? '',
      nameKu: json['nameKu'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String? ?? '',
      priceIQD: (json['priceIQD'] ?? json['price'] as num).toDouble(),
      imageSearchQuery: json['imageSearchQuery'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? json['img'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'nameKu': nameKu,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'priceIQD': priceIQD,
      'imageSearchQuery': imageSearchQuery,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}

class CartItem {
  final MenuItemModel item;
  int qty;

  CartItem({required this.item, required this.qty});
}

class OrderItem {
  final String id;
  final String nameKu;
  final String nameAr;
  final double price;
  final int qty;

  OrderItem({
    required this.id,
    required this.nameKu,
    required this.nameAr,
    required this.price,
    required this.qty,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      nameKu: json['nameKu'] as String,
      nameAr: json['nameAr'] as String,
      price: (json['price'] as num).toDouble(),
      qty: json['qty'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKu': nameKu,
      'nameAr': nameAr,
      'price': price,
      'qty': qty,
    };
  }
}

class Order {
  final String id;
  final String numStr;
  final DateTime date;
  final String cashier;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final PayMethod payMethod;
  final double paid;
  final double change;
  final OrderStatus status;

  Order({
    required this.id,
    required this.numStr,
    required this.date,
    required this.cashier,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.payMethod,
    required this.paid,
    required this.change,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    if (json['date'] is Timestamp) {
      parsedDate = (json['date'] as Timestamp).toDate();
    } else {
      parsedDate = DateTime.parse(json['date'].toString());
    }

    return Order(
      id: json['id'] as String,
      numStr: json['numStr'] as String,
      date: parsedDate,
      cashier: json['cashier'] as String? ?? '',
      items: (json['items'] as List<dynamic>).map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      payMethod: json['payMethod'] == 'card' ? PayMethod.card : PayMethod.cash,
      paid: (json['paid'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      status: json['status'] == 'cancelled' ? OrderStatus.cancelled : json['status'] == 'refunded' ? OrderStatus.refunded : OrderStatus.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numStr': numStr,
      'date': Timestamp.fromDate(date),
      'cashier': cashier,
      'items': items.map((i) => i.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'payMethod': payMethod == PayMethod.card ? 'card' : 'cash',
      'paid': paid,
      'change': change,
      'status': status == OrderStatus.cancelled ? 'cancelled' : status == OrderStatus.refunded ? 'refunded' : 'completed',
    };
  }
}
