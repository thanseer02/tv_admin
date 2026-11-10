import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_error_model.dart';
import '../utils/enums.dart';
import '../utils/exceptions.dart';
import '_base.dart';

typedef HandleAPIException = void Function({
  required APIException ex,
  required OnShowError onShowError,
  VoidCallback? onInvalidToken,
});

mixin MixinProgressProvider on BaseProvider {
  Completer<bool>? _completer;
  Completer<bool>? get progressCompleter => _completer;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();

    try {
      if (value) {
        _completer ??= Completer<bool>();
        if (_completer!.isCompleted) {
          _completer = Completer<bool>();
        }
      } else {
        if (_completer != null && !_completer!.isCompleted) {
          _completer!.complete(true);
        }
      }
    } catch (ex) {
      debugPrint('Error updating progress completer: $ex');
    }
  }

  void showLoading() => isLoading = true;
  void hideLoading() => isLoading = false;

  Future<T> callWithInProgress<T>({required Future<T> methodToCall}) async {
    showLoading();
    try {
      return await methodToCall;
    } finally {
      hideLoading();
    }
  }
}

mixin MixinAPIProvider {
  void handleAPIException({
    required APIException ex,
    required OnShowError onShowError,
    VoidCallback? onInvalidToken,
  }) {
    onShowError(
      AppError<APIException>(
        message: ex.message.isNotEmpty ? ex.message : EnumErrorMessage.serverError.message,
        response: ex,
      ),
    );
  }

  void onInvalidToken() {}
}

