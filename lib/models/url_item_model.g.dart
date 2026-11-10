// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'url_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UrlItemModel _$UrlItemModelFromJson(Map<String, dynamic> json) => UrlItemModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      description: json['description'] as String? ?? '',
      environment: UrlEnvironment.fromString(json['environment'] as String?),
      status: UrlStatus.fromString(json['status'] as String?),
      createdAt: UrlItemModel._dateTimeFromJson(json['createdAt']),
      updatedAt: UrlItemModel._dateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$UrlItemModelToJson(UrlItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'description': instance.description,
      'environment': UrlItemModel._envToJson(instance.environment),
      'status': UrlItemModel._statusToJson(instance.status),
      'createdAt': UrlItemModel._dateTimeToJson(instance.createdAt),
      'updatedAt': UrlItemModel._dateTimeToJson(instance.updatedAt),
    };
