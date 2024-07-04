import 'package:app_stories/styles/app_img.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatelessWidget {
  final String username;
  final String comment;
  final String chapter;
  final String time;

  const CommentWidget({
    super.key,
    required this.username,
    required this.comment,
    required this.chapter,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                AssetImage(Img.imgAVT // Thay thế bằng URL ảnh avatar thực tế
                    ),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(comment),
                const SizedBox(height: 4),
                Text(chapter),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
