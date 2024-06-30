import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/category_model.dart';
import 'chapter_model.dart';

class Story {
  int? storyId;
  String? title;
  String? authorId;
  String? summary;
  int? active;
  List<Chapter>? chapters;
  List<String>? licenseImage;
  List<String>? coverImage;
  int? chapterCount;
  List<Category>? categories;

  Story({
    this.storyId,
    this.title,
    this.authorId,
    this.summary,
    this.chapterCount,
    this.active,
    this.chapters,
    this.licenseImage,
    this.coverImage,
    this.categories,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      storyId: json['story_id'],
      title: json['title'],
      authorId: json['author_id'],
      summary: json['summary'],
      chapterCount: json['chapters_count'],
      active: json['active'],
      chapters:
          List<Chapter>.from(json['chapters'].map((x) => Chapter.fromJson(x))),
      licenseImage: List<String>.from(
          json['license_image'].map((x) => "${Api.hostImage}$x")),
      coverImage: List<String>.from(
          json['cover_image'].map((x) => "${Api.hostImage}$x")),
      categories: List<Category>.from(
          json['categories'].map((x) => Category.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'story_id': storyId,
      'title': title,
      'author_id': authorId,
      'summary': summary,
      'active': active,
      'chapters_count': chapterCount,
      'chapters': List<dynamic>.from(chapters!.map((x) => x.toJson())),
      'license_image': List<dynamic>.from(licenseImage!.map((x) => x)),
      'cover_image': List<dynamic>.from(coverImage!.map((x) => x)),
      'categories': List<dynamic>.from(categories!.map((x) => x)),
    };
  }
}
