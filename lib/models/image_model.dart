class ImageModel {
  int id;
  String pageURL;
  String type;
  String tags;
  String previewURL;
  int previewWidth;
  int previewHeight;
  String webformatURL;
  int webformatWidth;
  int webformatHeight;
  String largeImageURL;
  int imageWidth;
  int imageHeight;
  int imageSize;
  int views;
  int downloads;
  int collections;
  int likes;
  int comments;
  int userId;
  String user;
  String userImageURL;

  ImageModel({
    this.id = 0,
    this.pageURL = '',
    this.type = '',
    this.tags = '',
    this.previewURL = '',
    this.previewWidth = 0,
    this.previewHeight = 0,
    this.webformatURL = '',
    this.webformatWidth = 0,
    this.webformatHeight = 0,
    this.largeImageURL = '',
    this.imageWidth = 0,
    this.imageHeight = 0,
    this.imageSize = 0,
    this.views = 0,
    this.downloads = 0,
    this.collections = 0,
    this.likes = 0,
    this.comments = 0,
    this.userId = 0,
    this.user = '',
    this.userImageURL = '',
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      pageURL: json['pageURL'],
      type: json['type'],
      tags: json['tags'],
      previewURL: json['previewURL'],
      previewWidth: json['previewWidth'],
      previewHeight: json['previewHeight'],
      webformatURL: json['webformatURL'],
      webformatWidth: json['webformatWidth'],
      webformatHeight: json['webformatHeight'],
      largeImageURL: json['largeImageURL'],
      imageWidth: json['imageWidth'],
      imageHeight: json['imageHeight'],
      imageSize: json['imageSize'],
      views: json['views'],
      downloads: json['downloads'],
      collections: json['collections'],
      likes: json['likes'],
      comments: json['comments'],
      userId: json['user_id'],
      user: json['user'],
      userImageURL: json['userImageURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageURL': pageURL,
      'type': type,
      'tags': tags,
      'previewURL': previewURL,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
      'webformatURL': webformatURL,
      'webformatWidth': webformatWidth,
      'webformatHeight': webformatHeight,
      'largeImageURL': largeImageURL,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'imageSize': imageSize,
      'views': views,
      'downloads': downloads,
      'collections': collections,
      'likes': likes,
      'comments': comments,
      'user_id': userId,
      'user': user,
      'userImageURL': userImageURL,
    };
  }
}
