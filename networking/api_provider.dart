// ignore_for_file: constant_identifier_names

class APIProvider {
  /// TODO: uncomment when in production
  // static const String URL = "https://www.breadsecret.com/api/V2/api_2_0_0.php";
  // static const String WC_URL = "https://www.breadsecret.com/wp-json/wc/v3/";
  static const String URL_LIVE = "https://www.breadsecret.com/api/V2/api_2_0_0.php";
  static const String URL = "https://test.breadsecret.com/api/V2/api_2_0_0.php";
  static const String WC_URL = "https://test.breadsecret.com/wp-json/wc/v3/";
}

enum EndPoints {
  toWingHungLive(APIProvider.URL_LIVE),
  toWingHung(APIProvider.URL),
  toWooCom(APIProvider.WC_URL),
  ;

  const EndPoints(this.path);
  final String path;
}

enum Methods {
  get,
  post,
  update;
}
