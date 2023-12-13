import 'package:wh_rag_client/ck_tools/communicate_models/response/response_library.dart';

import 'base_response_model.dart';

class GenericModelParser {
  /// Return [T] as any response model
  ///
  /// Throw [Exception] when there is error.
  static T fromJson<T extends BaseResponseModel>(Map<String, dynamic> json) {
    try {
      switch (T) {
        case const (ResponseTemplate):
          return ResponseTemplate.fromJson(json) as T;
        default:
          throw UnsupportedError('Parsing unsupported model type. (${T.toString()})');
      }
    } catch (e) {
      rethrow;
    }
  }
}
