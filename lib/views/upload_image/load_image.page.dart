import 'package:app_stories/constants/api.dart';
import 'package:app_stories/widget/loading_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ImageListScreen extends StatefulWidget {
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  final Dio _dio = Dio();
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      Response response = await _dio.get('${Api.hostApi}/images');
      if (response.statusCode == 200) {
        setState(() {
          _images =
              List<String>.from(response.data.map((image) => image['path']));
        });
      } else {
        print('Failed to load images');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image List'),
      ),
      body: _images.isEmpty
          ? const Center(child: GradientLoadingWidget())
          : ListView.builder(
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Image.network(
                    '${Api.hostImage}/${_images[index]}',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}
