class Review {
  final String id;

  final String userName;

  final double rating;

  final String comment;

  final String date;

  Review({
    required this.id,

    required this.userName,

    required this.rating,

    required this.comment,

    required this.date,
  });

  factory Review.fromMap(Map<String, dynamic> map, String documentId) {
    return Review(
      id: documentId,

      userName: map['userName'] ?? '',

      rating: (map['rating'] ?? 0).toDouble(),

      comment: map['comment'] ?? '',

      date: map['date'] ?? '',
    );
  }
}
