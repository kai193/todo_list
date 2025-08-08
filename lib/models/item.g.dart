// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemImpl _$$ItemImplFromJson(Map<String, dynamic> json) => _$ItemImpl(
  id: json['id'] as String,
  text: json['text'] as String,
  completed: json['completed'] as bool? ?? false,
  date: DateTime.parse(json['date'] as String),
);

Map<String, dynamic> _$$ItemImplToJson(_$ItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'completed': instance.completed,
      'date': instance.date.toIso8601String(),
    };
