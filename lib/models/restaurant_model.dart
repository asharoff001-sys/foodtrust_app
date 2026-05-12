class Restaurant {
  final String id;

  final String name;

  final String location;

  final double rating;

  final String hygieneStatus;

  final List<String> reviews;

  final String image;

  final bool halal;

  Restaurant({
    required this.id,

    required this.name,

    required this.location,

    required this.rating,

    required this.hygieneStatus,

    required this.reviews,

    required this.image,

    required this.halal,
  });

  factory Restaurant.fromMap(Map<String, dynamic> map, String documentId) {
    return Restaurant(
      id: documentId,

      name: map['name'] ?? '',

      location: map['location'] ?? '',

      rating: (map['rating'] ?? 0).toDouble(),

      hygieneStatus: map['hygieneStatus'] ?? '',

      reviews: List<String>.from(map['reviews'] ?? []),

      image: map['image'] ?? '',

      halal: map['halal'] ?? false,
    );
  }
}
