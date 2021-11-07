import 'package:flutter/material.dart';

class ChatForm extends StatefulWidget {
  final Function callback;
  ChatForm({this.callback});

  @override
  _ChatFormState createState() => _ChatFormState();
}

class _ChatFormState extends State<ChatForm> {
  final msgController = TextEditingController();
  bool isFocused = false;
  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          controller: msgController,
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
              icon: Icon(msgController.text.trim().isNotEmpty
                  ? Icons.send
                  : Icons.insert_emoticon),
              onPressed: () {
                if (msgController.text.trim().isNotEmpty) {
                  widget.callback(msgController.text);
                  msgController.text = '';
                  setState(() {
                    isFocused = !isFocused;
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
}
