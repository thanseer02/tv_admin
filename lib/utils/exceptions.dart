enum EnumAPIExceptions {
  apiResultEmpty,
  dataFieldEmpty,
  dataSuccessFalse,
  httpStatusError,
  invalidToken,
  emptyTokenFromServer,
  invalidResultType,
}

class APIException implements Exception {
  final EnumAPIExceptions enumProperty;
  final String message;
  List? otherData;
  dynamic data;
  bool? asToast = false;

  APIException({
    required this.enumProperty,
    required this.message,
    this.otherData,
    this.data,
    this.asToast,
  });

  @override
  String toString() => "$enumProperty:$message:$otherData";
}

