import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

class ControllableListView<T> extends StatefulWidget {
  final CustomListController<T> customListController;
  final ScrollController scrollController;
  final Widget Function(BuildContext context, int index, T item) builder;

  final Axis scrollDirection;
  final bool reverse;
  final bool? primary;
  final ScrollPhysics scrollPhysics;
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final Widget? prototypeItem;
  final double? itemExtent;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final int? semanticChildCount;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;

  @override
  State<ControllableListView> createState() => _ControllableListViewState<T>();

  const ControllableListView({
    super.key,
    required this.customListController,
    required this.scrollController,
    required this.builder,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.padding,
    this.prototypeItem,
    this.shrinkWrap = false,
    this.itemExtent,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.scrollPhysics = const BouncingScrollPhysics(),
    this.cacheExtent,
    this.semanticChildCount,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
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

    widget.customListController._onMoveIndex((int from, int to) {
      if (from != to &&
          from > -1 &&
          from < _data.length &&
          to < _data.length &&
          to > -1) {
        setState(() {
          final item = _data[from];
          _data.removeAt(from);
          final sublist = _data.sublist(0, to);
          sublist.add(item);
          sublist.addAll(_data.sublist(to, _data.length));
          _data = sublist;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: widget.key,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      reverse: widget.reverse,
      primary: widget.primary,
      itemExtent: widget.itemExtent,
      prototypeItem: widget.prototypeItem,
      scrollDirection: widget.scrollDirection,
      physics: widget.scrollPhysics,
      itemCount: _data.length,
      controller: widget.scrollController,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
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
  final List<Function(int from, int to)> _onMoveIndexListeners = [];

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

  //reverse
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

  //move item
  void _invokeMoveIndex(int from, int to) {
    for (var element in _onMoveIndexListeners) {
      element.call(from, to);
    }
  }

  void moveFromTo(int from, int to) {
    _invokeMoveIndex(from, to);
  }

  void _onMoveIndex(Function(int from, int to) onMove) {
    _onMoveIndexListeners.add(onMove);
  }
}
