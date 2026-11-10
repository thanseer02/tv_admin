import '../providers/_mixins.dart';

extension CoverWithProgress<T> on Future<T> {
  Future<T> setProgress<I extends MixinProgressProvider>(I provider) async {
    try {
      provider.showLoading();
      await this;
    } finally {
      provider.hideLoading();
    }
    return this;
  }
}

