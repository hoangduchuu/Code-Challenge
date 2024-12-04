import 'dart:developer';

class MyLogger {
  static void d(String? msg, {String? tag}) {
    log(msg ?? '', name: tag ?? 'MyLogger');
  }
}
