import 'dart:async';

import 'package:flutter/material.dart';

class ChatForm extends StatefulWidget {
  final ScrollController controller;
  ChatForm({this.controller});

  @override
  _ChatFormState createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    print('build');
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
            )
          ],
        ),
        child: TextField(
          maxLines: 3,
          minLines: 1,
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: 'Write a message....',
            contentPadding: const EdgeInsets.all(14),
            prefixIcon: SizedBox(
              width: 20,
              height: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlatButton(
                  child: Icon(
                    Icons.add,
                    size: 20,
                  ),
                  textColor: Colors.white,
                  onPressed: () {},
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusDirectional.circular(10),
                  ),
                  padding: const EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ),
            suffixIcon: IconButton(
              iconSize: 30,
              icon: Icon(isFocused ? Icons.send : Icons.insert_emoticon),
              onPressed: () {
                if (isFocused) {
                  _sendMessage().catchError((error) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString())),
                    );
                  });
                } else {
                  // show emojis
                }
              },
              visualDensity: VisualDensity.compact,
            ),
          ),
          onChanged: (val) {
            if (val.trim().isNotEmpty && !isFocused) {
              setState(() {
                isFocused = true;
              });
            } else if (val.trim().isEmpty && isFocused) {
              setState(() {
                isFocused = false;
              });
            }
          },
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    if ((widget.controller.position.maxScrollExtent -
            widget.controller.position.pixels) <
        (300)) {
      Timer(Duration(milliseconds: 200), () => _scrollToBottom());
    }
  }

  void _scrollToBottom() {
    widget.controller.animateTo(
      widget.controller.position.maxScrollExtent + 60,
      duration: Duration(milliseconds: 300),
      curve: Curves.bounceIn,
    );
  }

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 50),
      () => widget.controller.jumpTo(
        widget.controller.position.maxScrollExtent + 50,
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
