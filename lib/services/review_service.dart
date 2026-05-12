import '../models/review_model.dart';

class ReviewService {
  static final List<Review> reviews = [
    Review(
      id: '1',

      userName: 'Yasin',

      rating: 4.5,

      comment: 'Very safe and fresh product.',

      date: '10 May 2026',
    ),

    Review(
      id: '2',

      userName: 'Imran',

      rating: 5.0,

      comment: 'Excellent quality and authentic.',

      date: '11 May 2026',
    ),

    Review(
      id: '3',

      userName: 'Habib',

      rating: 3.5,

      comment: 'Packaging was slightly damaged.',

      date: '12 May 2026',
    ),
  ];

  static void addReview(Review review) {
    reviews.insert(0, review);
  }

  static double calculateAverageRating() {
    if (reviews.isEmpty) {
      return 0;
    }

    double total = 0;

    for (var review in reviews) {
      total += review.rating;
    }

    return total / reviews.length;
  }
}
