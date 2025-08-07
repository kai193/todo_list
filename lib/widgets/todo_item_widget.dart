import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firebase_service.dart';

class TodoItemWidget extends StatelessWidget {
  final Item item;
  final FirebaseService firebaseService;

  const TodoItemWidget({
    super.key,
    required this.item,
    required this.firebaseService,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      onDismissed: (direction) {
        firebaseService.deleteItem(item.id);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: ListTile(
        onTap: () {
          firebaseService.toggleComplete(item);
        },
        title: Text(item.text),
        subtitle: Text(
          item.date.toString().replaceAll('-', '/').substring(0, 19),
        ),
        trailing: Icon(
          item.completed ? Icons.check_box : Icons.check_box_outline_blank,
          color: Colors.blue,
        ),
      ),
    );
  }
}
