import 'package:flutter/cupertino.dart';

class ControllableListView<T> extends StatefulWidget {
  final CustomListController<T> customListController;
  final ScrollController scrollController;
  final Widget Function(BuildContext context, int index, T item) builder;

  @override
  State<ControllableListView> createState() => _ControllableListViewState<T>();

  const ControllableListView({
    super.key,
    required this.customListController,
    required this.scrollController,
    required this.builder,
  });
}

class _ControllableListViewState<T> extends State<ControllableListView<T>> {
  List<T> _data = <T>[];

  @override
  void initState() {
    widget.customListController.onLoad((data) {
      setState(() {
        _data.add(data);
      });
    });
    widget.customListController.onRemoveAt((int index) {
      setState(() {
        _data.removeAt(index);
      });
    });

    widget.customListController.onReverse(() {
      setState(() {
        _data = _data.reversed.toList();
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
        return widget.builder(e, i, _data[i]);
      },
    );
  }
}

class CustomListController<T> {
  final List<Function(T data)> _onAddListeners = [];
  final List<Function(int index)> _onRemoveListeners = [];
  final List<Function()> _onReverseListeners = [];

  //load
  void loadData(T data) {
    _invokeAdded(data);
  }

  void _invokeAdded(T data) {
    for (var element in _onAddListeners) {
      element.call(data);
    }
  }

  void onLoad(Function(T data) onDataLoad) {
    _onAddListeners.add(onDataLoad);
  }

  //remove
  void _invokeRemoved(int index) {
    for (var element in _onRemoveListeners) {
      element.call(index);
    }
  }

  void removeAt(int index) {
    _invokeRemoved(index);
  }

  void onRemoveAt(Function(int index) onDataRemoved) {
    _onRemoveListeners.add(onDataRemoved);
  }

  void _invokeReverse() {
    for (var element in _onReverseListeners) {
      element.call();
    }
  }

  void reverse() {
    _invokeReverse();
  }

  void onReverse(Function() onReverse) {
    _onReverseListeners.add(onReverse);
  }
}
