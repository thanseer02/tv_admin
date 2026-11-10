import '../models/app_error_model.dart';
import '_base.dart';
import '_mixins.dart';

class PaginationController {
  int page = 1;
  int limit = 10;
  bool isAllCompleted = false;
  bool isLoading = false;

  bool get canLoadMore => !isAllCompleted && !isLoading;

  void reset() {
    page = 1;
    isAllCompleted = false;
    isLoading = false;
  }
}

abstract class ViewModel extends BaseProvider
    with MixinProgressProvider, MixinAPIProvider {
  final int _page = 1;
  final bool _isAllCompleted = false;

  int get page => _page;
  bool get canLoadMore => (!_isAllCompleted) && (!super.isLoading);

  Future<void> fetchListData<IM>({
    required final Future<List<IM>> Function() apiService,
    required OnShowError onShowError,
    required Future<void> Function(List<IM>) onSuccess,
    final int customLimit = 10,
    bool initialCall = false,
    required PaginationController controller,
  }) async {
    controller.limit = customLimit;
    if (controller.isLoading) return;

    controller.isLoading = true;
    if (initialCall) {
      notifyListeners();
    }

    try {
      final models = await apiService();
      if (models.length >= controller.limit) {
        controller.page++;
      } else {
        controller.isAllCompleted = true;
      }
      controller.isLoading = false;
      await onSuccess(models);
    } catch (error) {
      onShowError(AppError(message: error.toString()));
    } finally {
      controller.isLoading = false;
      notifyListeners();
    }
  }
}

