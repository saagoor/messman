import 'package:flutter/widgets.dart';
import 'package:mess/models/food.dart';


class FoodsService with ChangeNotifier {
  List<Food> _items = [
    Food(
      id: 1,
      title: 'Beef',
      imageUrl:
          'https://www.edamam.com/food-img/bab/bab88ab3ea40d34e4c8ae35d6b30344a.jpg',
      category: 'Generic foods',
    ),
    Food(
      id: 2,
      title: 'Chicken',
      imageUrl:
          'https://www.edamam.com/food-img/bab/bab88ab3ea40d34e4c8ae35d6b30344a.jpg',
      category: 'Generic foods',
    ),
  ];

  List<Food> get items {
    return [..._items];
  }

  List<Food> search(String queryString) {
    return _items.where((item) => item.title.contains(queryString)).toList();
  }

  
}


