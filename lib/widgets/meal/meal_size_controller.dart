import 'package:flutter/material.dart';

class MealSizeController extends StatefulWidget {
  final double initValue;
  final String labelText;
  final Function onChanged;
  final double figure;
  final double maxSize;
  final double minSize;
  MealSizeController({
    this.initValue,
    @required this.labelText,
    @required this.onChanged,
    this.figure = 0.5,
    this.maxSize = 2,
    this.minSize = 0,
  });

  @override
  _MealSizeControllerState createState() => _MealSizeControllerState();
}

class _MealSizeControllerState extends State<MealSizeController> {
  final sizeController = TextEditingController();

  @override
  void dispose() {
    sizeController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.initValue != null) {
      sizeController.text = widget.initValue.toString();
    }
    return Row(
      children: <Widget>[
        Flexible(
          child: TextField(
            controller: sizeController,
            readOnly: true,
            // maxLength: 3,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: widget.labelText ?? '',
              prefixIcon: Icon(Icons.sort),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        if (double.parse(sizeController.text) > widget.minSize) {
                          sizeController.text =
                              (double.parse(sizeController.text) - widget.figure)
                                  .toString();
                          widget.onChanged(sizeController.text);
                        }
                      },
                      visualDensity: VisualDensity.comfortable,
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () {
                        if (double.parse(sizeController.text) < widget.maxSize) {
                          sizeController.text =
                              (double.parse(sizeController.text) + widget.figure)
                                  .toString();
                          widget.onChanged(sizeController.text);
                        }
                      },
                      visualDensity: VisualDensity.comfortable,
                    ),
                  ],
                ),
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
