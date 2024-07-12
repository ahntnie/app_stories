import 'dart:io';

import 'package:flutter/material.dart';

import '../view_image.page.dart';

class ImageCard extends StatelessWidget {
  final String? urlImage;
  final File? fileImage;
  const ImageCard({
    super.key,
    required this.urlImage,
    this.fileImage,
  });

  @override
  Widget build(BuildContext context) {
    String urlImageWithTimestamp =
        '$urlImage?timestamp=${DateTime.now().millisecondsSinceEpoch}';
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
                  // isLoad ? urlImageWithTimestamp : urlImage!,
                  urlImageWithTimestamp,
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
                        child: const Center(
                          child: CircularProgressIndicator(),
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
