abstract class BaseRequestModel {
  BaseRequestModel(this.section);

  /// TODO: uncomment when in production
  // String key = "ck_1515985f54f992e733df2ae9956786762d8c9a43";
  // String secret = "cs_2c6c34f0fbc462f231093f6db34cc0f4b9824bfd";
  String key = "ck_6a95fca025df3abbf358c24732bae451c24313c3";
  String secret = "cs_86b729b0215bcb2b8f4e5536b39002068d6ea75d";
  late String section;

  Map<String, dynamic> toJson();
}
