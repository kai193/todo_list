import 'package:flutter/material.dart';
import '../models/item.dart';

class TodoItemWidget extends StatefulWidget {
  final Item item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onEdit;

  const TodoItemWidget({
    super.key,
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<TodoItemWidget> createState() => _TodoItemWidgetState();
}

class _TodoItemWidgetState extends State<TodoItemWidget> {
  bool isEditing = false;
  late TextEditingController textController;
  late FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.item.text);
    focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(TodoItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.text != widget.item.text) {
      textController.text = widget.item.text;
    }
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.item.id),
      onDismissed: (direction) {
        widget.onDelete();
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
          if (!isEditing) {
            setState(() {
              isEditing = true;
            });
            Future.delayed(const Duration(milliseconds: 100), () {
              focusNode.requestFocus();
            });
          }
        },
        title: isEditing
            ? TextField(
                controller: textController,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 16),
                onSubmitted: (value) {
                  _saveEdit();
                },
                onEditingComplete: () {
                  _saveEdit();
                },
              )
            : Text(widget.item.text),
        subtitle: Text(
          widget.item.date.toString().replaceAll('-', '/').substring(0, 19),
        ),
        trailing: IconButton(
          icon: Icon(
            widget.item.completed
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: Colors.blue,
          ),
          onPressed: () {
            widget.onToggle();
          },
        ),
      ),
    );
  }

  void _saveEdit() {
    final newText = textController.text.trim();
    if (newText.isNotEmpty && newText != widget.item.text) {
      widget.onEdit(newText);
    }
    setState(() {
      isEditing = false;
    });
    focusNode.unfocus();
  }

  void _cancelEdit() {
    textController.text = widget.item.text;
    setState(() {
      isEditing = false;
    });
    focusNode.unfocus();
  }
}
