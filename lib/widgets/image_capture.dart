import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  final Function callback;
  final int maxHeight;
  final int maxWidth;
  ImageCapture({this.callback, this.maxHeight, this.maxWidth});

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    if (selected != null) _cropImage(selected);
  }

  Future<void> _cropImage(File selectedImage) async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: selectedImage.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: widget.maxHeight ?? 150,
      maxWidth: widget.maxWidth ?? 150,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop Image',
      ),
    );
    if (cropped == null) return;
    setState(() {
      _imageFile = cropped;
    });
    widget.callback(_imageFile);
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        if (_imageFile != null)
          ClipOval(
            child: SizedBox(
              height: 100,
              width: 100,
              child: Image.file(_imageFile, fit: BoxFit.contain),
            ),
          ),
        Expanded(
          child: Column(
            children: <Widget>[
              if (_imageFile != null)
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton.icon(
                        onPressed: () => _cropImage(_imageFile),
                        icon: Icon(Icons.crop),
                        label: Text('Crop'),
                      ),
                      FlatButton.icon(
                        onPressed: _clear,
                        icon: Icon(Icons.refresh),
                        label: Text('Clear'),
                      ),
                    ],
                  ),
                ),
              if (_imageFile == null)
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton.icon(
                        label: Text('Camera'),
                        icon: Icon(Icons.photo_camera),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      FlatButton.icon(
                        label: Text('Gallery'),
                        icon: Icon(Icons.photo_library),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
