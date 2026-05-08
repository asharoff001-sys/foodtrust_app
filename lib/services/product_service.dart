import '../models/product_model.dart';

class ProductService {
  static List<Product> products = [
    Product(
      name: 'Fresh Milk',
      barcode: '123456',
      expiryDate: '2026-06-15',
      isSafe: true,
    ),
    Product(
      name: 'Chicken Sausage',
      barcode: '789012',
      expiryDate: '2026-05-01',
      isSafe: false,
    ),
    Product(
      name: 'Orange Juice',
      barcode: '345678',
      expiryDate: '2026-07-20',
      isSafe: true,
    ),
  ];
}
