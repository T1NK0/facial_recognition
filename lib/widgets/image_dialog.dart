import 'dart:io';

import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  final File imageFile;
  final Function() onUsePressed;
  final Function() onRetakePressed;

  ImageDialog({
    required this.imageFile,
    required this.onUsePressed,
    required this.onRetakePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Captured Image'),
      content: Column(
        children: <Widget>[
          Image.file(imageFile),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: onUsePressed,
          child: Text('Use This Picture'),
        ),
        TextButton(
          onPressed: onRetakePressed,
          child: Text('Retake'),
        ),
      ],
    );
  }
}
