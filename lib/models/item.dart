import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
part 'item.g.dart';

@freezed
class Item with _$Item {
  const factory Item({
    required String id,
    required String text,
    @Default(false) bool completed,
    required DateTime date,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  factory Item.fromSnapshot(String id, Map<String, dynamic> document) {
    return Item(
      id: id,
      text: document['text'].toString(),
      completed: document['completed'] ?? false,
      date: (document['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
