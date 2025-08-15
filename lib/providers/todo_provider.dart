import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';

part 'todo_provider.g.dart';

/// TODOアイテムの状態を管理するプロバイダー（リアルタイム更新対応）
@riverpod
class TodoNotifier extends _$TodoNotifier {
  @override
  Stream<List<Item>> build() {
    final firebaseService = ref.read(firebaseServiceProvider);
    return firebaseService.watchItems();
  }

  /// 新しいアイテムを追加
  Future<void> addItem(String text) async {
    if (!_isValidText(text)) return;

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.saveItem(text);
      // リアルタイム更新により自動的にUIが更新される
    } catch (error, _) {
      _handleError('アイテムの追加に失敗しました', error);
    }
  }

  /// アイテムの完了状態を切り替え
  Future<void> toggleItem(Item item) async {
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.toggleComplete(item);
      // リアルタイム更新により自動的にUIが更新される
    } catch (error, _) {
      _handleError('アイテムの状態変更に失敗しました', error);
    }
  }

  /// アイテムを削除
  Future<void> deleteItem(String id) async {
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.deleteItem(id);
      // リアルタイム更新により自動的にUIが更新される
    } catch (error, _) {
      _handleError('アイテムの削除に失敗しました', error);
    }
  }

  /// アイテムのテキストを更新
  Future<void> updateItemText(String id, String newText) async {
    if (!_isValidText(newText)) return;

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.updateItemText(id, newText);
      // リアルタイム更新により自動的にUIが更新される
    } catch (error, _) {
      _handleError('アイテムの更新に失敗しました', error);
    }
  }

  /// データを再読み込み
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  // Private methods

  /// テキストの妥当性をチェック
  bool _isValidText(String text) => text.trim().isNotEmpty;

  /// エラーハンドリング
  void _handleError(String message, Object error) {
    debugPrint('$message: $error');
    // TODO: 必要に応じてユーザーにエラーを通知
  }
}

/// 楽観的更新が必要な場合のためのプロバイダー
@riverpod
class TodoNotifierWithOptimistic extends _$TodoNotifierWithOptimistic {
  @override
  Future<List<Item>> build() async {
    final firebaseService = ref.read(firebaseServiceProvider);
    return await firebaseService.getLatestItems();
  }

  /// 新しいアイテムを追加（楽観的更新付き）
  Future<void> addItem(String text) async {
    if (!_isValidText(text)) return;

    final tempItem = _createTempItem(text);
    _updateStateOptimistically([tempItem, ..._getCurrentItems()]);

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final actualId = await firebaseService.saveItem(text);
      _updateItemId(tempItem.id, actualId);
    } catch (error, _) {
      _handleError('アイテムの追加に失敗しました', error);
      // 楽観的更新を維持（エラー時もUIの応答性を保持）
    }
  }

  /// アイテムの完了状態を切り替え（楽観的更新付き）
  Future<void> toggleItem(Item item) async {
    final updatedItems = _getCurrentItems().map((listItem) {
      return listItem.id == item.id
          ? item.copyWith(completed: !item.completed)
          : listItem;
    }).toList();

    _updateStateOptimistically(updatedItems);

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.toggleComplete(item);
    } catch (error, _) {
      _handleError('アイテムの状態変更に失敗しました', error);
      // 楽観的更新を維持
    }
  }

  /// アイテムを削除（楽観的更新付き）
  Future<void> deleteItem(String id) async {
    final updatedItems = _getCurrentItems()
        .where((item) => item.id != id)
        .toList();

    _updateStateOptimistically(updatedItems);

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.deleteItem(id);
    } catch (error, _) {
      _handleError('アイテムの削除に失敗しました', error);
      // 楽観的更新を維持
    }
  }

  /// アイテムのテキストを更新（楽観的更新付き）
  Future<void> updateItemText(String id, String newText) async {
    if (!_isValidText(newText)) return;

    final updatedItems = _getCurrentItems().map((listItem) {
      return listItem.id == id ? listItem.copyWith(text: newText) : listItem;
    }).toList();

    _updateStateOptimistically(updatedItems);

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.updateItemText(id, newText);
    } catch (error, _) {
      _handleError('アイテムの更新に失敗しました', error);
      // 楽観的更新を維持
    }
  }

  /// データを再読み込み
  Future<void> refresh() async {
    state = const AsyncValue.loading();

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final newItems = await firebaseService.getLatestItems();
      state = AsyncValue.data(newItems);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  // Private methods

  /// テキストの妥当性をチェック
  bool _isValidText(String text) => text.trim().isNotEmpty;

  /// 一時的なアイテムを作成
  Item _createTempItem(String text) {
    return Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      completed: false,
      date: DateTime.now(),
    );
  }

  /// 現在のアイテムリストを取得
  List<Item> _getCurrentItems() {
    return state.value ?? [];
  }

  /// 楽観的に状態を更新
  void _updateStateOptimistically(List<Item> items) {
    state = AsyncValue.data(items);
  }

  /// アイテムのIDを更新
  void _updateItemId(String oldId, String newId) {
    final currentItems = _getCurrentItems();
    final updatedItems = currentItems.map((item) {
      return item.id == oldId ? item.copyWith(id: newId) : item;
    }).toList();
    _updateStateOptimistically(updatedItems);
  }

  /// エラーハンドリング
  void _handleError(String message, Object error) {
    debugPrint('$message: $error');
    // TODO: 必要に応じてユーザーにエラーを通知
  }
}
