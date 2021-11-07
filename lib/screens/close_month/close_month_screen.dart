import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:intl/intl.dart';
import 'package:messman/screens/close_month/members_data_of_month.dart';
import 'package:messman/screens/close_month/months_calculations.dart';
import 'package:messman/services/calc_service.dart';
import 'package:messman/services/mess_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

final _boundaryKey = GlobalKey();

class CloseMonthScreen extends StatelessWidget {
  static const routeName = '/close-month';

  @override
  Widget build(BuildContext context) {
    final messService = Provider.of<MessService>(context, listen: false);
    final currentMonth = messService.mess?.currentMonth;
    return Scaffold(
      appBar: AppBar(
        title: Text('Close Month - ${DateFormat.yMMMM().format(currentMonth)}'),
      ),
      body: ChangeNotifierProvider.value(
        value: CalcService(context),
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            RepaintBoundary(
              key: _boundaryKey,
              child: Column(
                children: [
                  MonthsCalculations(),
                  SizedBox(height: 20),
                  MembersDataOfMonth(),
                ],
              ),
            ),
            SizedBox(height: 20),
            CloseMonthActions(),
          ],
        ),
      ),
    );
  }
}

class CloseMonthActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MessService messService =
        Provider.of<MessService>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: OutlineButton.icon(
            onPressed: () => captureImage(context),
            icon: Icon(Icons.image),
            label: Text('Save Screenshot'),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: FlatButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              messService.mess.closeMonth(context);
            },
            icon: Icon(Icons.calendar_today_outlined),
            label: Text('Close Month & Start New'),
          ),
        ),
      ],
    );
  }

  captureImage(BuildContext context) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary =
        _boundaryKey.currentContext.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = data.buffer.asUint8List();
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = new File('$directory/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
  }
}
