import 'package:flutter/material.dart';
import '../models/app_error_model.dart';

typedef OnShowError = void Function(AppError msg);

abstract class BaseProvider extends ChangeNotifier {
  final String? _providerName;
  String? get providerName => _providerName;

  BaseProvider({String? name}) : _providerName = name;

  @override
  void notifyListeners() {
    try {
      super.notifyListeners();
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }
}
