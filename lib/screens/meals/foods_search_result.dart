import 'package:flutter/material.dart';
import 'package:mess/models/food.dart';
import 'package:mess/services/foods_service.dart';
import 'package:provider/provider.dart';

class FoodSearchResult extends StatelessWidget {
  final String queryString;

  FoodSearchResult(this.queryString);

  @override
  Widget build(BuildContext context) {
    final foodsService = Provider.of<FoodsService>(context);

    if (queryString != null && queryString.isNotEmpty) {
      final searchResult = foodsService.search(queryString);
      if (searchResult == null || searchResult.length <= 0) {
        return Center(child: Text('No meal found based on your search!'));
      }
      return ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 15),
        itemCount: searchResult.length,
        itemBuilder: (ctx, i) => FoodCard(
          food: searchResult[i],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 15),
      itemCount: foodsService.items.length,
      itemBuilder: (ctx, i) => FoodCard(
        food: foodsService.items[i],
      ),
    );
  }
}

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({
    Key key,
    @required this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 60,
        width: 60,
        child: CircleAvatar(
          backgroundImage: food.imageUrl != null ? NetworkImage(food.imageUrl) : AssetImage('assets/images/lunch.png'),
          onBackgroundImageError: (wtf, trace) {
            print('Image error');
            return AssetImage('assets/images/lunch.png');
          },
        ),
      ),
      title: Text(food.title, style: Theme.of(context).textTheme.headline6),
      subtitle: Text(food.category ?? 'Unspecified'),
      trailing: Card(
        elevation: 0,
        shape: CircleBorder(
          side: BorderSide(color: Theme.of(context).buttonColor),
        ),
        child: IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            Navigator.of(context).pop(food);
          },
        ),
      ),
    );
  }
}
