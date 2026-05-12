import '../models/restaurant_model.dart';

class RestaurantService {
  static final List<Restaurant> restaurants = [
    Restaurant(
      id: '1',

      name: 'Arabian Kitchen',

      location: 'Rajshahi',

      rating: 4.5,

      hygieneStatus: 'Excellent',

      reviews: [
        'Best naan & grill in Rajshahi',

        'Very tasty grilled chicken',

        'Clean environment and quick service',
      ],

      image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',

      halal: true,
    ),

    Restaurant(
      id: '2',

      name: 'Burger Town',

      location: 'Dhaka',

      rating: 3.8,

      hygieneStatus: 'Average',

      reviews: ['Food was okay', 'Service was slow'],

      image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38',

      halal: false,
    ),

    Restaurant(
      id: '3',

      name: 'Green Garden',

      location: 'Chittagong',

      rating: 4.9,

      hygieneStatus: 'Excellent',

      reviews: ['Amazing hygiene', 'Friendly staff', 'Healthy food options'],

      image: 'https://images.unsplash.com/photo-1552566626-52f8b828add9',

      halal: true,
    ),
  ];

  static List<Restaurant> getVerifiedRestaurants() {
    return restaurants.where((restaurant) => restaurant.halal).toList();
  }

  static Restaurant? getRestaurantById(String id) {
    try {
      return restaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      return null;
    }
  }
}
