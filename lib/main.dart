import 'dart:math';

import 'package:controllable_listview/controllable_listview.dart';
import 'package:flutter/material.dart';

import 'item_model.dart';

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
  final CustomListController<ItemModel> _customListController =
      CustomListController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ControllableListView<ItemModel>(
        onBottomReached: () async {
          await Future.delayed(const Duration(seconds: 3));

          _customListController.loadData(const ItemModel(id: 1));
        },
        showFooter: true,
        footerWidget: Container(
          margin: const EdgeInsets.all(12),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        customListController: _customListController,
        scrollController: _scrollController,
        builder: (context, index, model) {
          return GestureDetector(
            onTap: () {
              _customListController.removeAt(index);
            },
            onDoubleTap: () {
              _customListController.moveFromTo(index, index + 1);
            },
            child: Container(
              margin: const EdgeInsets.all(12),
              height: 100,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black12)),
              child: Text('Title : ${model.id}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _customListController
              .loadData(ItemModel(id: Random().nextInt(100000)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
