import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewImagePage extends StatelessWidget {
  final String? urlImage;
  final File? fileImage;
  const ViewImagePage({super.key, this.urlImage, this.fileImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
            child: urlImage != null
                ? Image.network(
                    urlImage!,
                    fit: BoxFit.cover,
                  )
                : Image.file(fileImage!)),
        Positioned(
            right: 10,
            top: 30,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ))
      ],
    );
  }
}
