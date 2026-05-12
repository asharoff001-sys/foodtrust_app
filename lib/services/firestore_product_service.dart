import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProductService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final snapshot = await firestore.collection('products').get();

      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    } catch (e) {
      print(e);

      return [];
    }
  }
}
