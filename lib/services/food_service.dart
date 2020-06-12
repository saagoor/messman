import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'food_service.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Food {
  int id;
  String title;
  String imageUrl;
  String category;
  int likesCount;
  int dislikesCount;

  Food({
    this.id,
    this.title,
    this.imageUrl,
    this.category,
    this.likesCount,
    this.dislikesCount,
  });

  factory Food.fromJson(Map<String, dynamic> json) => _$FoodFromJson(json);
  Map<String, dynamic> toJson() => _$FoodToJson(this);

}

class FoodsService {
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

@JsonSerializable(fieldRename: FieldRename.snake)

class DailyFoodsService with ChangeNotifier {
  int id;
  int messId;
  DateTime dateTime;
  String breakfast;
  String lunch;
  String dinner;
  int breakfastReact = 0;
  int lunchReact = 0;
  int dinnerReact = 0;

  DailyFoodsService({
    this.dateTime,
    this.breakfast,
    this.lunch,
    this.dinner,
  });

  factory DailyFoodsService.fromJson(Map<String, dynamic> json) => _$DailyFoodsServiceFromJson(json);
  Map<String, dynamic> toJson() => _$DailyFoodsServiceToJson(this);


  void setMenu(DateTime dateTime, String type, String food) {
    switch (type.toLowerCase()) {
      case 'breakfast':
        breakfast = food;
        break;
      case 'lunch':
        lunch = food;
        break;
      case 'dinner':
        dinner = food;
        break;
    }
    notifyListeners();
  }
  void setReact(String type, int react){
    switch (type.toLowerCase()) {
      case 'breakfast':
        breakfastReact = react;
        break;
      case 'lunch':
        lunchReact = react;
        break;
      case 'dinner':
        dinnerReact = react;
        break;
    }
    notifyListeners();
  }
  int react(String type){
    switch (type.toLowerCase()) {
      case 'breakfast':
        return breakfastReact;
      case 'lunch':
        return lunchReact;
      case 'dinner':
        return dinnerReact;
    }
    return 0;
  }
}
