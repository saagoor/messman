import 'package:flutter/material.dart';
import 'package:messman/models/food.dart';
import 'package:messman/services/foods_service.dart';
import 'package:messman/widgets/network_circle_avatar.dart';
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
      leading: NetworkCircleAvatar(imageUrl: food.imageUrl),
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
