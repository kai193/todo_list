import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';
import '../widgets/todo_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Item> items = [];
  final TextEditingController textEditingController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _watchItems();
  }

  void _watchItems() {
    firebaseService.watchItems().listen((newItems) {
      setState(() {
        items = newItems;
      });
    });
  }

  Future<void> _saveItem() async {
    if (textEditingController.text.trim().isNotEmpty) {
      await firebaseService.saveItem(textEditingController.text);
      textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: TextField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
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
            );
          }
          final item = items[index - 1];
          return TodoItemWidget(item: item, firebaseService: firebaseService);
        },
        itemCount: items.length + 1,
      ),
    );
  }
}
