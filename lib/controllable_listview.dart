import 'package:flutter/cupertino.dart';

class ControllableListView<T> extends StatefulWidget {
  final CustomListController<T> customListController;
  final ScrollController scrollController;
  final Widget Function(BuildContext context, int index, dynamic item) builder;

  @override
  State<ControllableListView> createState() => _ControllableListViewState<T>();

  const ControllableListView({
    super.key,
    required this.customListController,
    required this.scrollController,
    required this.builder,
  });
}

class _ControllableListViewState<T> extends State<ControllableListView> {
  final List<T> _data = <T>[];

  @override
  void initState() {
    widget.customListController.listen((data) {
      setState(() {
        _data.add(data);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _data.length,
      controller: widget.scrollController,
      itemBuilder: (e, i) {
        return widget.builder.call(e, i, _data[i]);
      },
    );
  }
}

class CustomListController<T> {
  final List<Function(T data)> _listeners = [];

  void load(T data) {
    _invoke(data);
  }

  void _invoke(T data) {
    for (var element in _listeners) {
      element.call(data);
    }
  }

  void listen(Function(T data) onDataLoad) {
    _listeners.add(onDataLoad);
  }
}
