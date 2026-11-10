enum UrlStatus {
  active('Active'),
  inactive('Inactive');

  final String label;
  const UrlStatus(this.label);

  static UrlStatus fromString(String? value) {
    return UrlStatus.values.firstWhere(
      (s) => s.name.toLowerCase() == (value ?? '').toLowerCase() ||
             s.label.toLowerCase() == (value ?? '').toLowerCase(),
      orElse: () => UrlStatus.active,
    );
  }
}

