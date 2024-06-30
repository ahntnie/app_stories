import 'dart:io';

import 'package:flutter/material.dart';

import '../view_image.page.dart';

class ImageCard extends StatelessWidget {
  final String? urlImage;
  final File? fileImage;
  const ImageCard({super.key, required this.urlImage, this.fileImage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const CircularProgressIndicator(),
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewImagePage(
                          urlImage: urlImage,
                          fileImage: fileImage,
                        )));
          },
          child: fileImage != null
              ? Image.file(
                  fileImage!,
                  width: MediaQuery.of(context).size.width / 4,
                  fit: BoxFit.fill,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                )
              : Image.network(
                  urlImage!,
                  width: MediaQuery.of(context).size.width / 4,
                  fit: BoxFit.fill,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: child);
                    } else {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width / 4,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
        ),
      ],
    );
  }
}
