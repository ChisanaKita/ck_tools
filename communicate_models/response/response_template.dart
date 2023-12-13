part of 'response_library.dart';

class ResponseTemplate extends BaseResponseModel {
  ResponseTemplate(super.success, super.statusCode, super.code, super.data);

  ResponseTemplate.fromJson(Map<String, dynamic> json)
      : super(
          json['success'],
          json['statusCode'],
          json['code'],
          null,
        );

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
