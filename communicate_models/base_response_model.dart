abstract class BaseResponseModel {
  late bool success;
  late num statusCode;
  String? code;
  BaseResponseData? data;

  BaseResponseModel(this.success, this.statusCode, this.code, this.data);
  Map<String, dynamic> toJson();
}

abstract class BaseResponseData {
  BaseResponseData();
  BaseResponseData.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

abstract class BaseResponseSubData {
  BaseResponseSubData();
  BaseResponseSubData.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
