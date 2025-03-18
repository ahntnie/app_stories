class Api {
  static const String hostApi = 'https://dev.gtglobal.id.vn/api';
  static const String hostImage = 'https://dev.gtglobal.id.vn';

  //Story
  static const String postStory = '/stories';
  static const String getMyStories = '/stories';
  static const String approveStory = '/stories/approve';
  static const String disableStory = '/stories/disable';
  static const String noApproveStory = '/stories/noapprove';
  static const String getTotalStories = '/total/stories';
  static const String getCountNewStories = '/new/story';
  static const String completedStory = '/stories/completed';

  //View Story
  static const String addViewStory = '/story/view';
  static const String storyView = '/viewStory/';

  //Favourite
  static const String postLike = '/favourite-story';
  static const String unLike = '/delete-favourite-story';
  static const String getStoryFavourite = '/get-favourite-story';

  //Category
  static const String getCategories = '/categories';
  static const String addCategories = '/categories';
  static const String deleteCategories = '/categories';

  //Chapter
  static const String getChapters = '/chapters';
  static const String postChapters = '/chapters';
  static const String updateChapters = '/chapters';
  static const String updateImages = '/update/images';

  //User
  static const String getUser = '/users';
  static const String approveAuthor = '/author/approve/';
  static const String getCountNewUsers = '/new/users';

  //Notification
  static const String getNotificationByUserId = '/notifications/user';
  static const String markAsReadNotification = '/notifications/read';
  static const String deleNotification = '/notifications/delete';

  //Notification admin
  static const String postNotificationByAdmin = '/notifications/toadmin';
  static const String markAsReadNotificationByAdmin =
      '/notifications/getbyadmin';

  //Comment
  static const String comment = '/comment';
  static const String commentStory = '/comments/bystory';

  //authen-firebase
  static const apiKeyAuth = 'AIzaSyCjkNznq8DoDKDk6q1l5Ebn6oX3xx43rJ4';
  static const String apiAuth =
      'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$apiKeyAuth';
}
