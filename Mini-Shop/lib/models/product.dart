// lib/models/product.dart
// Product veri modeli - fromJson/toJson ile JSON simülasyonu

class Product {
  final int id;
  final String name;
  final String subtitle;
  final String description;
  final double price;
  final String imageAsset;
  final String spec1Label;
  final String spec1Value;
  final String spec2Label;
  final String spec2Value;
  final String spec3Label;
  final String spec3Value;

  Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.spec1Label,
    required this.spec1Value,
    required this.spec2Label,
    required this.spec2Value,
    required this.spec3Label,
    required this.spec3Value,
  });

  // JSON'dan model oluşturma (Gün 4: fromJson mantığı)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageAsset: json['imageAsset'] as String,
      spec1Label: json['spec1Label'] as String,
      spec1Value: json['spec1Value'] as String,
      spec2Label: json['spec2Label'] as String,
      spec2Value: json['spec2Value'] as String,
      spec3Label: json['spec3Label'] as String,
      spec3Value: json['spec3Value'] as String,
    );
  }

  // Modeli JSON'a dönüştürme (Gün 4: toJson mantığı)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'description': description,
      'price': price,
      'imageAsset': imageAsset,
      'spec1Label': spec1Label,
      'spec1Value': spec1Value,
      'spec2Label': spec2Label,
      'spec2Value': spec2Value,
      'spec3Label': spec3Label,
      'spec3Value': spec3Value,
    };
  }
}
