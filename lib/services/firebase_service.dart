import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirebaseService {
  static const String collectionKey = 'your_todo';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 最新10件を取得（監視なし）
  Future<List<Item>> getLatestItems() async {
    final querySnapshot = await _firestore
        .collection(collectionKey)
        .orderBy('date', descending: true) // 最新順でソート
        .limit(10) // 最新10件に制限
        .get();

    return querySnapshot.docs
        .map((document) => Item.fromSnapshot(document.id, document.data()))
        .toList(growable: false);
  }

  // 保存する
  Future<String> saveItem(String text) async {
    final collection = _firestore.collection(collectionKey);
    final now = DateTime.now();
    final docId = now.millisecondsSinceEpoch.toString();
    await collection.doc(docId).set({
      "date": now,
      "text": text,
      "completed": false,
    });
    return docId;
  }

  // 完了・未完了に変更する
  Future<void> toggleComplete(Item item) async {
    final collection = _firestore.collection(collectionKey);
    await collection.doc(item.id).update({"completed": !item.completed});
  }

  // 削除する
  Future<void> deleteItem(String id) async {
    final collection = _firestore.collection(collectionKey);
    await collection.doc(id).delete();
  }

  // テキストを更新する
  Future<void> updateItemText(String id, String newText) async {
    final collection = _firestore.collection(collectionKey);
    await collection.doc(id).update({"text": newText});
  }
}
