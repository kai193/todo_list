import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';

part 'todo_provider.g.dart';

// FirebaseServiceのプロバイダー
@riverpod
FirebaseService firebaseService(FirebaseServiceRef ref) {
  return FirebaseService();
}

// TODOアイテムの状態を管理するプロバイダー
@riverpod
class TodoNotifier extends _$TodoNotifier {
  @override
  Future<List<Item>> build() async {
    final firebaseService = ref.read(firebaseServiceProvider);
    return await firebaseService.getLatestItems();
  }

  // 新しいアイテムを追加
  Future<void> addItem(String text) async {
    if (text.trim().isEmpty) return;

    // 楽観的更新: UIを即座に更新
    final currentState = state.value;
    Item? tempItem;
    if (currentState != null) {
      tempItem = Item(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: text,
        completed: false,
        date: DateTime.now(),
      );
      final updatedItems = [tempItem, ...currentState];
      state = AsyncValue.data(updatedItems);
    }

    // バックエンドに保存（エラー時も楽観的更新を維持）
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final actualId = await firebaseService.saveItem(text);

      // 実際のIDで楽観的更新を更新
      if (tempItem != null && currentState != null) {
        final updatedItems = currentState.map((item) {
          if (item.id == tempItem!.id) {
            return item.copyWith(id: actualId);
          }
          return item;
        }).toList();
        state = AsyncValue.data(updatedItems);
      }
    } catch (error, stackTrace) {
      // エラーが発生しても楽観的更新を維持
      print('Error saving item: $error');
    }
  }

  // アイテムの完了状態を切り替え
  Future<void> toggleItem(Item item) async {
    // 楽観的更新: UIを即座に更新
    final currentState = state.value;
    if (currentState != null) {
      final updatedItems = currentState.map((listItem) {
        if (listItem.id == item.id) {
          return item.copyWith(completed: !item.completed);
        }
        return listItem;
      }).toList();
      state = AsyncValue.data(updatedItems);
    }

    // バックエンドに保存（エラー時も楽観的更新を維持）
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.toggleComplete(item);
    } catch (error, stackTrace) {
      // エラーが発生しても楽観的更新を維持
      print('Error toggling item: $error');
    }
  }

  // アイテムを削除
  Future<void> deleteItem(String id) async {
    // 楽観的更新: UIを即座に更新
    final currentState = state.value;
    if (currentState != null) {
      final updatedItems = currentState.where((item) => item.id != id).toList();
      state = AsyncValue.data(updatedItems);
    }

    // バックエンドに保存（エラー時も楽観的更新を維持）
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.deleteItem(id);
    } catch (error, stackTrace) {
      // エラーが発生しても楽観的更新を維持
      print('Error deleting item: $error');
    }
  }

  // アイテムのテキストを更新
  Future<void> updateItemText(String id, String newText) async {
    if (newText.trim().isEmpty) return;

    // 楽観的更新: UIを即座に更新
    final currentState = state.value;
    if (currentState != null) {
      final updatedItems = currentState.map((listItem) {
        if (listItem.id == id) {
          return listItem.copyWith(text: newText);
        }
        return listItem;
      }).toList();
      state = AsyncValue.data(updatedItems);
    }

    // バックエンドに保存（エラー時も楽観的更新を維持）
    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      await firebaseService.updateItemText(id, newText);
    } catch (error, stackTrace) {
      // エラーが発生しても楽観的更新を維持
      print('Error updating item text: $error');
    }
  }

  // データを再読み込み
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
}
