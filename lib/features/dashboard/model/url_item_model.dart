import 'package:json_annotation/json_annotation.dart';
import 'url_environment.dart';
import 'url_status.dart';

export 'url_environment.dart';
export 'url_status.dart';

part 'url_item_model.g.dart';

@JsonSerializable()
class UrlItemModel {
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  @JsonKey(name: 'address', defaultValue: '')
  final String address;

  @JsonKey(name: 'description', defaultValue: '')
  final String description;

  @JsonKey(
    name: 'environment',
    fromJson: UrlEnvironment.fromString,
    toJson: _envToJson,
  )
  final UrlEnvironment environment;

  @JsonKey(
    name: 'status',
    fromJson: UrlStatus.fromString,
    toJson: _statusToJson,
  )
  final UrlStatus status;

  @JsonKey(name: 'createdAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime createdAt;

  @JsonKey(name: 'updatedAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  const UrlItemModel({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.environment,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UrlItemModel.fromJson(Map<String, dynamic> json) {
    // Gracefully handle backend variations where 'title' maps to 'name' and 'url' maps to 'address'
    final map = Map<String, dynamic>.from(json);
    if (!map.containsKey('name') || map['name'] == null) {
      map['name'] = map['title'] ?? '';
    }
    if (!map.containsKey('address') || map['address'] == null) {
      map['address'] = map['url'] ?? '';
    }
    if (!map.containsKey('description') || map['description'] == null) {
      map['description'] = map['notes'] ?? '';
    }
    return _$UrlItemModelFromJson(map);
  }

  Map<String, dynamic> toJson() => _$UrlItemModelToJson(this);

  UrlItemModel copyWith({
    String? id,
    String? name,
    String? address,
    String? description,
    UrlEnvironment? environment,
    UrlStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UrlItemModel(
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

  static String _envToJson(UrlEnvironment env) => env.name;
  static String _statusToJson(UrlStatus st) => st.name;

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  static String _dateTimeToJson(DateTime dt) => dt.toIso8601String();
}
