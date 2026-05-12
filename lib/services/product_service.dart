import '../models/product_model.dart';

class ProductService {
  static final List<Product> products = [
    Product(
      id: '1',

      name: 'Fresh Milk',

      brand: 'Farm Fresh',

      expiryDate: '12 May 2026',

      safetyScore: 4.8,

      image: 'https://images.unsplash.com/photo-1563636619-e9143da7973b',

      barcode: '123456789',

      isSafe: true,
    ),

    Product(
      id: '2',

      name: 'Chicken Sausage',

      brand: 'Golden Foods',

      expiryDate: '20 May 2026',

      safetyScore: 4.1,

      image: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f',

      barcode: '987654321',

      isSafe: false,
    ),

    Product(
      id: '3',

      name: 'Orange Juice',

      brand: 'Minute Juice',

      expiryDate: '02 June 2026',

      safetyScore: 4.6,

      image: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b',

      barcode: '555555555',

      isSafe: true,
    ),
  ];

  static Product? getProductByBarcode(String barcode) {
    try {
      return products.firstWhere((product) => product.barcode == barcode);
    } catch (e) {
      return null;
    }
  }

  static List<Product> getSafeProducts() {
    return products.where((product) => product.isSafe).toList();
  }
}
