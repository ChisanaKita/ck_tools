import 'dart:async';
import 'dart:convert';

import 'package:ck_console/ck_console.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../candy_bar.dart';
import '../communicate_models/base_request_model.dart';
import '../communicate_models/base_response_model.dart';
import '../communicate_models/generic_model_parser.dart';
import '../exceptions/api_request_exception.dart';
import 'api_provider.dart';
import 'network_wrapper.dart';

class Server {
//region Singleton Pattern
  static late Server _instance;

  static Server instance() {
    _instance = Server._();
    return _instance;
  }

  Server._();

//endregion

  Future<T> request<T extends BaseResponseModel>({
    BuildContext? context,
    required EndPoints apiPath,
    required Methods methods,
    required BaseRequestModel requestData,
  }) async {
    String apiFullPath = apiPath.path;

    String printOut = "";

    requestData.toJson().forEach((key, value) {
      printOut += ('$key: $value ');
    });
    CkConsole.log(runtimeType, "Server request data print-out\n$printOut");

    late Response response;
    try {
      response = await NetworkWrapper.instance().submitRequest(
        url: apiFullPath,
        method: methods,
        data: requestData.toJson(),
      );
      debugPrint(response.data);
    } catch (e) {
      if (e is DioException) {
        CkConsole.log(runtimeType, "A Dio error ${e.type.name} is encountered.", logError: true);
        if (e.type == DioExceptionType.receiveTimeout) {
          CkConsole.log(runtimeType, "Handling error: ${e.type.name}..", logWarning: true);
          CkConsole.log(runtimeType, "Waiting 10 second before retry", logWarning: true);
          if (context != null && context.mounted) {
            CandyBar.instance.showBar(
              context,
              flavor: CandyFlavor.error,
              text: "Time out",
            );
          }
          await Future.delayed(const Duration(seconds: 10));
          CkConsole.log(runtimeType, "Retry..", logWarning: true);
          if (context != null) {
            if (context.mounted) {
              return await request(context: context, apiPath: apiPath, methods: methods, requestData: requestData);
            } else {
              CkConsole.log(runtimeType, "Retry is canceled due to page is not mounted", logWarning: true);
              throw "This request is canceled due to caller is no longer active.";
            }
          } else {
            return await request(context: null, apiPath: apiPath, methods: methods, requestData: requestData);
          }
        } else {
          throw (e).message ?? "";
        }
      }
    }

    //  Error handling
    try {
      if (response.statusCode != 200) {
        throw 'HTTP error. (Status ${response.statusCode})';
      }

      if (response.data.toString().compareTo("[]") == 0) {
        throw "There is no data returned.";
      }
      if (response.data.toString().startsWith('[')) {
        throw "The response is not a valid JSON.";
      }
      return GenericModelParser.fromJson<T>(jsonDecode(response.data));
    } catch (e, s) {
      CkConsole.log(Server, e.toString(), logError: true);
      debugPrintStack(stackTrace: s, label: 'Server.request<$T>');
      throw APIRequestException(e.toString());
    }
  }
}
