// import 'package:flutter/material.dart';

// class UploadProgress extends StatefulWidget {
//   final StorageUploadTask task;
//   final Function onCompleteCallback;
//   UploadProgress(this.task, this.onCompleteCallback);

//   @override
//   _UploadProgressState createState() => _UploadProgressState();
// }

// class _UploadProgressState extends State<UploadProgress> {
//   @override
//   Widget build(BuildContext context) {
//     if (widget.task != null) {
//       return StreamBuilder<StorageTaskEvent>(
//         stream: widget.task.events,
//         builder: (context, snapshot) {
//           var event = snapshot?.data?.snapshot;
//           double progressPercent =
//               event != null ? event.bytesTransferred / event.totalByteCount : 0;
//           // print('Up: $progressPercent');
//           String status = widget.task.isInProgress
//               ? 'Image Uploading....'
//               : widget.task.isComplete
//                   ? 'Upload complete....'
//                   : widget.task.isCanceled ? 'Upload cancelled...' : '';
//           if(widget.task.isComplete){
//             widget.onCompleteCallback();
//           }
//           return SizedBox(
//             height: 100,
//             child: Column(
//               children: <Widget>[
//                 if (widget.task.isPaused)
//                   FlatButton(
//                       onPressed: widget.task.resume,
//                       child: Icon(Icons.play_arrow)),
//                 if (widget.task.isInProgress)
//                   FlatButton(
//                       onPressed: widget.task.pause, child: Icon(Icons.pause)),
//                 LinearProgressIndicator(value: progressPercent),
//                 SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(status),
//                     Text('${(progressPercent * 100).toStringAsFixed(2)} %'),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     } else {
//       return Text('Nothing to upload!');
//     }
//   }
// }
