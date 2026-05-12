class Product {
  final String id;

  final String name;

  final String brand;

  final String expiryDate;

  final double safetyScore;

  final String image;

  final String barcode;

  final bool isSafe;

  Product({
    required this.id,

    required this.name,

    required this.brand,

    required this.expiryDate,

    required this.safetyScore,

    required this.image,

    required this.barcode,

    required this.isSafe,
  });

  factory Product.fromMap(Map<String, dynamic> map, String documentId) {
    return Product(
      id: documentId,

      name: map['name'] ?? '',

      brand: map['brand'] ?? '',

      expiryDate: map['expiryDate'] ?? '',

      safetyScore: (map['safetyScore'] ?? 0).toDouble(),

      image: map['image'] ?? '',

      barcode: map['barcode'] ?? '',

      isSafe: map['isSafe'] ?? false,
    );
  }
}
