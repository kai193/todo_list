import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirebaseService {
  static const String collectionKey = 'your_todo';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // データ更新監視
  Stream<List<Item>> watchItems() {
    return _firestore.collection(collectionKey).snapshots().map((event) {
      return event.docs.reversed
          .map((document) => Item.fromSnapshot(document.id, document.data()))
          .toList(growable: false);
    });
  }

  // 保存する
  Future<void> saveItem(String text) async {
    final collection = _firestore.collection(collectionKey);
    final now = DateTime.now();
    await collection.doc(now.millisecondsSinceEpoch.toString()).set({
      "date": now,
      "text": text,
    });
  }

  // 完了・未完了に変更する
  Future<void> toggleComplete(Item item) async {
    final collection = _firestore.collection(collectionKey);
    await collection.doc(item.id).set({
      "completed": !item.completed,
    }, SetOptions(merge: true));
  }

  // 削除する
  Future<void> deleteItem(String id) async {
    final collection = _firestore.collection(collectionKey);
    await collection.doc(id).delete();
  }
}
