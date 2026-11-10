/// Environments supported by LinkDesk URLs
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

/// Status of the URL entry
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

/// URL Data Model
class UrlItem {
  final String id;
  final String name;
  final String address;
  final String description;
  final UrlEnvironment environment;
  final UrlStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UrlItem({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.environment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory from Map / JSON (prepared for future API)
  factory UrlItem.fromJson(Map<String, dynamic> json) {
    return UrlItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String? ?? '',
      environment: UrlEnvironment.fromString(json['environment'] as String?),
      status: UrlStatus.fromString(json['status'] as String?),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// Serialization to Map / JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'description': description,
      'environment': environment.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Copy with helper
  UrlItem copyWith({
    String? id,
    String? name,
    String? address,
    String? description,
    UrlEnvironment? environment,
    UrlStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UrlItem(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      description: description ?? this.description,
      environment: environment ?? this.environment,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

