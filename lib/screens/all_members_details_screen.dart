import 'package:flutter/material.dart';
import 'package:messman/screens/close_month/members_data_of_month.dart';
import 'package:messman/screens/close_month/months_calculations.dart';
import 'package:messman/services/calc_service.dart';
import 'package:provider/provider.dart';

class AllMembersDetailsScreen extends StatelessWidget {
  static const routeName = '/months-and-members-details';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Month\'s & Members Details'),
      ),
      body: ChangeNotifierProvider.value(
        value: CalcService(context),
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            MonthsCalculations(),
            SizedBox(height: 20),
            MembersDataOfMonth(),
          ],
        ),
      ),
    );
  }
}
