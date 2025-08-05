import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 好きな名前に設定しましょう
const collectionKey = 'your_todo';

class _MyHomePageState extends State<MyHomePage> {
  List<Item> items = [];
  final TextEditingController textEditingController = TextEditingController();
  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    watch();
  }

  // データ更新監視
  Future<void> watch() async {
    firestore.collection(collectionKey).snapshots().listen((event) {
      setState(() {
        items = event.docs.reversed
            .map((document) => Item.fromSnapshot(document.id, document.data()))
            .toList(growable: false);
      });
    });
  }

  // 保存する
  Future<void> save() async {
    final collection = firestore.collection(collectionKey);
    final now = DateTime.now();
    await collection.doc(now.millisecondsSinceEpoch.toString()).set({
      "date": now,
      "text": textEditingController.text,
    });
    textEditingController.text = "";
  }

  // 完了・未完了に変更する
  Future<void> complete(Item item) async {
    final collection = firestore.collection(collectionKey);
    await collection.doc(item.id).set({
      "completed": !item.completed,
    }, SetOptions(merge: true));
  }

  // 削除する
  Future<void> delete(String id) async {
    final collection = firestore.collection(collectionKey);
    await collection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
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
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: () {
                    save();
                  },
                  icon: Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            );
          }
          final item = items[index - 1];
          return Dismissible(
            key: Key(item.id),
            onDismissed: (direction) {
              delete(item.id);
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
                complete(item);
              },
              title: Text(item.text),
              subtitle: Text(
                item.date.toString().replaceAll('-', '/').substring(0, 19),
              ),
              trailing: Icon(
                item.completed
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Colors.blue,
              ),
            ),
          );
        },
        itemCount: items.length + 1,
      ),
    );
  }
}

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
      text: document['text'].toString() ?? '',
      completed: document['completed'] ?? false,
      date: (document['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
