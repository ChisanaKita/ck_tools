import 'package:dio/dio.dart';

import 'api_provider.dart';

class NetworkWrapper {
  //region Singleton Pattern
  static late NetworkWrapper _instance;

  static NetworkWrapper instance() {
    _instance = NetworkWrapper._();
    return _instance;
  }

  NetworkWrapper._();

//endregion

  final int _timeoutSecond = 30;

  Future<Response> submitRequest({
    required String url,
    required Methods method,
    required Map<String, dynamic> data,
    Map<String, String>? authorization,
  }) async {
    //CkConsole.log(runtimeType, "${method.name}ing ${url.replaceFirst("https://", "").split("/")[0]}");
    // for (var element in data.entries) {
    //   debugPrint('${element.key}: ${element.value}');
    // }

    late Response response;
    try {
      switch (method) {
        case Methods.get:
          response = await Dio().get(
            url,
            queryParameters: data,
            options: Options(
              followRedirects: true,
              receiveDataWhenStatusError: true,
              receiveTimeout: Duration(seconds: _timeoutSecond),
              headers: _headerHandler(authorization),
              method: "GET",
            ),
          );
          break;
        case Methods.post:
          response = await Dio().post(
            url,
            data: data,
            options: Options(
              followRedirects: true,
              receiveDataWhenStatusError: true,
              receiveTimeout: Duration(seconds: _timeoutSecond),
              headers: _headerHandler(authorization),
              method: "POST",
              contentType: "application/x-www-form-urlencoded",
            ),
          );
          break;
        case Methods.update:
          response = await Dio().put(
            url,
            data: data,
            options: Options(
              followRedirects: true,
              receiveDataWhenStatusError: true,
              receiveTimeout: Duration(seconds: _timeoutSecond),
              headers: _headerHandler(authorization),
              method: "PUT",
              contentType: "application/json",
            ),
          );
          break;
        default:
          throw UnimplementedError("Unsupported method implementation: ${method.name}");
      }
    } catch (e) {
      rethrow;
    }

    return response;
  }

  Map<String, String> _headerHandler(Map<String, String>? auth) {
    Map<String, String> header = {
      "accept-encoding": "application/json",
    };
    if (auth != null) {
      header.addEntries(auth.entries);
    }
    return header;
  }
}
