import 'package:flutter/material.dart';
import 'package:messman/screens/add_deposit_screen.dart';
import 'package:messman/services/deposits_service.dart';
import 'package:messman/services/helpers.dart';
import 'package:messman/widgets/deposits_list_view.dart';
import 'package:provider/provider.dart';

class DepositsScreen extends StatelessWidget {
  static const routeName = '/deposits';

  @override
  Widget build(BuildContext context) {
    final depositsService = Provider.of<DepositsService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Deposits'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await depositsService.fetchAndSet().catchError((error) {
            showHttpError(context, error);
          });
        },
        child: DepositsListView(depositsService.items),
      ),
      floatingActionButton: DepositsFAB(),
    );
  }
}

class DepositsFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final isSuccess =
            await Navigator.of(context).pushNamed(AddDepositScreen.routeName);
        if (isSuccess == true) {
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Deposit added successfully!')));
        }
      },
      child: Icon(Icons.add),
    );
  }
}
