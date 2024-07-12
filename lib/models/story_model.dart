import 'package:app_stories/constants/api.dart';
import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/models/user_model.dart';
import 'chapter_model.dart';

class Story {
  int? storyId;
  String? title;
  String? summary;
  int? active;
  List<Chapter>? chapters;
  List<String>? licenseImage;
  List<String>? coverImage;
  int? chapterCount;
  List<Category>? categories;
  Users? author;
  List<Users>? favouriteUser;
  List<Users>? viewUsers;
  int? totalView;
  int? totalComment;
  Story({
    this.storyId,
    this.title,
    this.summary,
    this.chapterCount,
    this.active,
    this.chapters,
    this.licenseImage,
    this.coverImage,
    this.categories,
    this.author,
    this.favouriteUser,
    this.totalView,
    this.totalComment,
    this.viewUsers,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      storyId: json['story_id'],
      title: json['title'],
      summary: json['summary'],
      chapterCount: json['chapters_count'],
      active: json['active'],
      chapters: json['chapters'] == null
          ? []
          : List<Chapter>.from(
              json['chapters'].map((x) => Chapter.fromJson(x))),
      licenseImage: List<String>.from(
          json['license_image'].map((x) => "${Api.hostImage}$x")),
      coverImage: List<String>.from(
          json['cover_image'].map((x) => "${Api.hostImage}$x")),
      categories: json['categories'] != null
          ? List<Category>.from(
              json['categories'].map((x) => Category.fromJson(x)))
          : [],
      author: Users.fromJson(json['author']),
      favouriteUser: json['favourited_users'] == null
          ? []
          : List<Users>.from(
              json['favourited_users'].map((x) => Users.fromJson(x))),
      totalView: json["total_view"],
      totalComment: json["total_comment"],
      viewUsers: json['favourited_users'] == null
          ? []
          : List<Users>.from(
              json['view_users'].map((x) => Users.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'story_id': storyId,
      'title': title,
      'summary': summary,
      'active': active,
      'chapters_count': chapterCount,
      'chapters': List<dynamic>.from(chapters!.map((x) => x.toJson())),
      'license_image': List<dynamic>.from(licenseImage!.map((x) => x)),
      'cover_image': List<dynamic>.from(coverImage!.map((x) => x)),
      'categories': List<dynamic>.from(categories!.map((x) => x)),
      'favourited_users': List<dynamic>.from(favouriteUser!.map((x) => x)),
      'author': author!.toJson(),
    };
  }
}
