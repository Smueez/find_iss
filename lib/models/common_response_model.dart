import 'package:find_iss/utils/enums.dart';

class CommonResponse<T> {
  T? data;
  int? statusCode;
  String responseMessage;
  EventType responseType;

  CommonResponse({
    this.data,
    this.statusCode,
    this.responseMessage = "",
    required this.responseType
  });
}