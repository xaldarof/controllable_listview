import 'dart:math';

import 'package:controllable_listview/controllable_listview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CustomListController<String> _customListController =
      CustomListController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ControllableListView<String>(
          customListController: _customListController,
          scrollController: _scrollController,
          builder: (context, index, item) {
            return Text('($index) Item : $item');
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _customListController
              .load("Item : ${Random().nextInt(100000).toString()}");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
