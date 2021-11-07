import 'package:flutter/material.dart';

import 'package:messman/models/food.dart';
import 'package:messman/models/meal.dart';
import 'package:messman/screens/meals/set_meal_screen.dart';
import 'package:messman/services/auth_service.dart';
import 'package:messman/widgets/amount.dart';
import 'package:messman/widgets/network_circle_avatar.dart';
import 'package:provider/provider.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final bool alwaysShowSetBtn;
  final double mealCount;

  const MealCard({
    Key key,
    @required this.meal,
    @required this.mealCount,
    this.alwaysShowSetBtn = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String accessToken =
        Provider.of<AuthService>(context, listen: false).token;
    return ChangeNotifierProvider<Meal>.value(
      value: meal,
      child: Consumer<Meal>(
        builder: (ctx, meal, child) => Stack(
          alignment: Alignment.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: <Widget>[
                          ((meal?.id != null || meal?.food != null))
                              ? NetworkCircleAvatar(
                                  imageUrl: meal.food.imageUrl,
                                  firstChar: meal.type.substring(0, 1),
                                )
                              : Image.asset(
                                  'assets/images/${meal.type.toLowerCase()}.png',
                                  height: 30,
                                ),
                          SizedBox(height: 8),
                          Text(meal.type ?? ''),
                          SizedBox(height: 4),
                          if (alwaysShowSetBtn || meal != null)
                            Text(
                              meal.food?.title ?? 'Not Set',
                              style: TextStyle(
                                color: meal != null
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).errorColor,
                              ),
                            ),
                          if (alwaysShowSetBtn ||
                              meal == null ||
                              meal.food == null) ...[
                            SizedBox(height: 10),
                            setMealBtn(context, accessToken),
                          ],
                          if (meal?.id != null) SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                if (meal?.id != null) SizedBox(height: 15),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: (meal?.id == null || meal?.food == null)
                  ? Text('')
                  : Row(
                      children: <Widget>[
                        LikeButton(
                          count: meal.dislikes,
                          iconData: Icons.thumb_down,
                          onPressed: () {
                            meal.dislike(accessToken).catchError((error) {
                              Scaffold.of(context).hideCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            });
                          },
                          isActive:
                              meal.likedByUser != null && !meal.likedByUser,
                        ),
                        SizedBox(width: 5),
                        LikeButton(
                          count: meal.likes,
                          iconData: Icons.thumb_up,
                          onPressed: () {
                            meal.like(accessToken).catchError((error) {
                              Scaffold.of(context).hideCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())),
                              );
                            });
                          },
                          isActive:
                              meal.likedByUser != null && meal.likedByUser,
                        ),
                      ],
                    ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: FittedBox(
                    child: Amount(mealCount, showCurrency: false),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget setMealBtn(BuildContext context, String accessToken) {
    return SizedBox(
      height: 25,
      child: OutlineButton(
        onPressed: () async {
          Food food = await Navigator.of(context).pushNamed(
            SetMealScreen.routeName,
            arguments: meal?.type,
          ) as Food;
          if (food != null) {
            print(food.toJson());
            meal
                .setFood(food, accessToken)
                .then((value) => {})
                .catchError((error) {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            });
          }
        },
        child: Text(
          'Set ${meal.type ?? ''}',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final int count;
  final IconData iconData;
  final Function onPressed;
  final bool isActive;
  const LikeButton({
    Key key,
    @required this.count,
    this.iconData,
    this.onPressed,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: IconButton(
        icon: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text('${count ?? 0}'),
              SizedBox(width: 2),
              Icon(iconData),
              SizedBox(width: 8),
            ],
          ),
        ),
        visualDensity: VisualDensity.comfortable,
        onPressed: onPressed,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }
}
