import 'package:ck_console/ck_console.dart';

class APIRequestException implements Exception {
  final String message;

  APIRequestException(this.message);

  void printToConsole() {
    CkConsole.log(APIRequestException, message, logError: true);
  }
}
