import 'package:flutter/material.dart';
import 'package:messman/screens/meals/foods_search_result.dart';
import 'package:messman/services/foods_service.dart';
import 'package:messman/includes/helpers.dart';
import 'package:provider/provider.dart';

class SetMealScreen extends StatefulWidget {
  static const routeName = '/meals/set';

  @override
  _SetMealScreenState createState() => _SetMealScreenState();
}

class _SetMealScreenState extends State<SetMealScreen> {
  String mealType = 'Lunch';

  TextEditingController _searchQueryController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  FoodsService foodsService;

  Future<void> loadFoods() async {
    await foodsService.fetchAndSet().catchError((error) {
      showHttpError(context, error);
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final passedMealType = ModalRoute.of(context).settings.arguments as String;
    if (passedMealType != null) mealType = passedMealType;

    foodsService = Provider.of<FoodsService>(context);
    if (!foodsService.isLoaded) {
      loadFoods();
    }

    return Scaffold(
      appBar: AppBar(
        // leading: _isSearching ? const BackButton() : Container(),
        title: _isSearching ? _buildSearchField() : Text('Set $mealType'),
        actions: _buildActions(),
      ),
      body: RefreshIndicator(
        onRefresh: loadFoods,
        child: FoodSearchResult(_searchQuery),
      ),
      backgroundColor: Theme.of(context).cardColor,
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchQueryController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Chicken Polao...",
        border: InputBorder.none,
      ),
      onChanged: updateSearchQuery,
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: _startSearch,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
