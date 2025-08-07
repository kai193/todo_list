import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  const Item({
    required this.id,
    required this.text,
    required this.completed,
    required this.date,
  });

  final String id;
  final String text;
  final bool completed;
  final DateTime date;

  factory Item.fromSnapshot(String id, Map<String, dynamic> document) {
    return Item(
      id: id,
      text: document['text'].toString(),
      completed: document['completed'] ?? false,
      date: (document['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
