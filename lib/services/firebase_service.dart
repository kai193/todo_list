import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import '../models/item.dart';

part 'firebase_service.g.dart';

/// Firebaseコレクション名
class FirebaseConstants {
  static const String todoCollection = 'your_todo';
  static const int maxItems = 10;
}

/// FirebaseServiceのプロバイダー
@riverpod
FirebaseService firebaseService(Ref ref) {
  return FirebaseService();
}

/// リアルタイムでTODOアイテムを監視するプロバイダー
@riverpod
Stream<List<Item>> todoItemsStream(Ref ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.watchItems();
}

/// 最新10件を取得するプロバイダー（一回限り）
@riverpod
Future<List<Item>> latestItems(Ref ref) async {
  final firebaseService = ref.read(firebaseServiceProvider);
  return await firebaseService.getLatestItems();
}

/// Firebaseとの通信を担当するサービスクラス
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// リアルタイムでアイテムを監視
  ///
  /// [FirebaseConstants.maxItems]件の最新アイテムを日付順で監視します
  Stream<List<Item>> watchItems() {
    return _firestore
        .collection(FirebaseConstants.todoCollection)
        .orderBy('date', descending: true)
        .limit(FirebaseConstants.maxItems)
        .snapshots()
        .map(_convertSnapshotToItems);
  }

  /// 最新アイテムを取得（監視なし）
  ///
  /// [FirebaseConstants.maxItems]件の最新アイテムを日付順で取得します
  Future<List<Item>> getLatestItems() async {
    final querySnapshot = await _firestore
        .collection(FirebaseConstants.todoCollection)
        .orderBy('date', descending: true)
        .limit(FirebaseConstants.maxItems)
        .get();

    return _convertSnapshotToItems(querySnapshot);
  }

  /// 新しいアイテムを保存
  ///
  /// [text] 保存するテキスト
  /// 戻り値: 生成されたドキュメントID
  Future<String> saveItem(String text) async {
    final collection = _firestore.collection(FirebaseConstants.todoCollection);
    final now = DateTime.now();
    final docId = _generateDocumentId(now);

    await collection.doc(docId).set({
      "date": now,
      "text": text,
      "completed": false,
    });

    return docId;
  }

  /// アイテムの完了状態を切り替え
  ///
  /// [item] 切り替えるアイテム
  Future<void> toggleComplete(Item item) async {
    final collection = _firestore.collection(FirebaseConstants.todoCollection);
    await collection.doc(item.id).update({"completed": !item.completed});
  }

  /// アイテムを削除
  ///
  /// [id] 削除するアイテムのID
  Future<void> deleteItem(String id) async {
    final collection = _firestore.collection(FirebaseConstants.todoCollection);
    await collection.doc(id).delete();
  }

  /// アイテムのテキストを更新
  ///
  /// [id] 更新するアイテムのID
  /// [newText] 新しいテキスト
  Future<void> updateItemText(String id, String newText) async {
    final collection = _firestore.collection(FirebaseConstants.todoCollection);
    await collection.doc(id).update({"text": newText});
  }

  // Private methods

  /// FirestoreスナップショットをItemリストに変換
  List<Item> _convertSnapshotToItems(QuerySnapshot snapshot) {
    return snapshot.docs
        .map(
          (document) => Item.fromSnapshot(
            document.id,
            document.data() as Map<String, dynamic>,
          ),
        )
        .toList(growable: false);
  }

  /// ドキュメントIDを生成
  String _generateDocumentId(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch.toString();
  }
}
