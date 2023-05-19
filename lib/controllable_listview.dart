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
  final Widget? footerWidget;
  final Function()? onBottomReached;

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
    this.footerWidget,
    this.onBottomReached,
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
  @override
  void initState() {
    super.initState();
    widget.customListController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.customListController.data;
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
      itemCount: widget.customListController.data.length,
      controller: widget.scrollController,
      cacheExtent: widget.cacheExtent,
      semanticChildCount: widget.semanticChildCount,
      dragStartBehavior: widget.dragStartBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      itemBuilder: (e, i) {
        if (i == items.length - 1 && widget.footerWidget != null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.builder(e, i, items[i]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.customListController.isFooterVisible)
                    widget.footerWidget!,
                ],
              )
            ],
          );
        }
        return widget.builder(e, i, items[i]);
      },
    );
  }
}

class CustomListController<T> {
  List<T> data = <T>[];
  bool showFooter = false;
  final List<Function()> _onShouldRebuildListeners = [];

  bool get isFooterVisible => showFooter;

  //load
  void loadData(T item) {
    data.add(item);
    notify();
  }

  void removeAt(int index) {
    data.removeAt(index);
    notify();
  }

  void notify() {
    for (var element in _onShouldRebuildListeners) {
      element.call();
    }
  }

  void addListener(Function() listener) {
    _onShouldRebuildListeners.add(listener);
  }

  void moveFromIndexTo(int from, int to) {
    if (from != to &&
        from > -1 &&
        from < data.length &&
        to < data.length &&
        to > -1) {
      final item = data[from];
      data.removeAt(from);
      final sublist = data.sublist(0, to);
      sublist.add(item);
      sublist.addAll(data.sublist(to, data.length));
      data = sublist;
      notify();
    }
  }

  void reverse() {
    data = data.reversed.toList();
    notify();
  }

  void toggleFooter(bool show) {
    showFooter = show;
    notify();
  }
}
