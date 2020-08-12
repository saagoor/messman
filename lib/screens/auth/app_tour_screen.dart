import 'package:flutter/material.dart';
import 'package:messman/services/settings_service.dart';
import 'package:provider/provider.dart';

class AppTourScreen extends StatefulWidget {
  @override
  _AppTourScreenState createState() => _AppTourScreenState();
}

class _AppTourScreenState extends State<AppTourScreen> {
  int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (var i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: 8,
      width: isActive ? 24 : 16,
      decoration: BoxDecoration(
        color: isActive ? Colors.black : Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   stops: [0.1, 0.4, 0.7, 0.9],
            //   colors: [
            //     Color(0xFF3594DD),
            //     Color(0xFF4563DB),
            //     Color(0xFF5036D5),
            //     Color(0xFF5B16D0),
            //   ],
            // ),
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                child: FlatButton(
                  onPressed: () {
                    _pageController.animateToPage(_numPages - 1,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.easeIn);
                  },
                  child: Text(
                    (_currentPage < _numPages - 1) ? 'Skip' : '',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      AppTourItem(
                        imageName: 'dinner.png',
                        title: 'Member wise meal on off!',
                        description:
                            'Members or manager can on/off specific meal of a specific member.',
                      ),
                      AppTourItem(
                        imageName: 'lunch.png',
                        title: 'Like or Dislike todays meals!',
                        description:
                            'Whats on todays meal menu. Like or dislike particular meal!',
                      ),
                      AppTourItem(
                        imageName: 'chat.png',
                        title: 'Instant text messaging!',
                        description: 'Members can group chat with each other!',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Let\'s Get Started',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(Icons.arrow_forward)
                                ],
                              ),
                              textColor: Theme.of(context).primaryColorDark,
                              onPressed: () async {
                                await Provider.of<SettingsService>(context,
                                        listen: false)
                                    .completeAppTour();
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildPageIndicator(),
              ),
              // if(_currentPage < _numPages - 1)
              Align(
                alignment: Alignment.centerRight,
                child: (_currentPage < _numPages - 1)
                    ? FlatButton(
                        onPressed: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 600),
                              curve: Curves.easeIn);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('Next'),
                            SizedBox(width: 10),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      )
                    : FlatButton(
                        onPressed: () {
                          _pageController.previousPage(
                              duration: Duration(milliseconds: 600),
                              curve: Curves.easeIn);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.arrow_back),
                            SizedBox(width: 10),
                            Text('Previous'),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppTourItem extends StatelessWidget {
  final String imageName;
  final String title;
  final String description;
  const AppTourItem({
    Key key,
    @required this.imageName,
    @required this.title,
    @required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/$imageName',
            height: 150,
            width: 150,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 30),
          Text(
            title ?? '',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 15),
          Text(description ?? '', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
