import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/item.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_item_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController textEditingController = TextEditingController();
  String? _errorMessage;

  Future<void> _saveItem() async {
    if (textEditingController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = '項目を入力してください';
      });
      return;
    }

    setState(() {
      _errorMessage = null;
    });

    await ref
        .read(todoNotifierProvider.notifier)
        .addItem(textEditingController.text);
    textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // リアルタイムでTODOアイテムを監視
    final todoAsync = ref.watch(todoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(todoNotifierProvider.notifier).refresh(),
          ),
        ],
      ),
      body: todoAsync.when(
        data: (items) => _buildTodoList(items),
        loading: () => _buildLoadingWidget(),
        error: (error, stackTrace) => _buildErrorWidget(error.toString()),
      ),
    );
  }

  // エラー表示ウィジェット
  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.read(todoNotifierProvider.notifier).refresh(),
            child: const Text('再試行'),
          ),
        ],
      ),
    );
  }

  // 読み込み表示ウィジェット
  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('読み込み中...'),
        ],
      ),
    );
  }

  // TODOリスト表示ウィジェット
  Widget _buildTodoList(List<Item> items) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            children: [
              ListTile(
                title: TextField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'TODOを入力してください',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    if (_errorMessage != null && value.trim().isNotEmpty) {
                      setState(() {
                        _errorMessage = null;
                      });
                    }
                  },
                  onSubmitted: (_) => _saveItem(),
                ),
                trailing: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: _saveItem,
                    icon: const Icon(Icons.add, color: Colors.white, size: 24),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
        }
        final item = items[index - 1];
        return TodoItemWidget(
          item: item,
          onToggle: () =>
              ref.read(todoNotifierProvider.notifier).toggleItem(item),
          onDelete: () =>
              ref.read(todoNotifierProvider.notifier).deleteItem(item.id),
          onEdit: (newText) => ref
              .read(todoNotifierProvider.notifier)
              .updateItemText(item.id, newText),
        );
      },
      itemCount: items.length + 1,
    );
  }
}
