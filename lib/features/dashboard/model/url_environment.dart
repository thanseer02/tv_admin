enum UrlEnvironment {
  production('Production'),
  staging('Staging'),
  testing('Testing'),
  other('Other');

  final String label;
  const UrlEnvironment(this.label);

  static UrlEnvironment fromString(String? value) {
    return UrlEnvironment.values.firstWhere(
      (e) => e.name.toLowerCase() == (value ?? '').toLowerCase() ||
             e.label.toLowerCase() == (value ?? '').toLowerCase(),
      orElse: () => UrlEnvironment.production,
    );
  }
}

