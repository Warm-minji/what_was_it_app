import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:what_was_it_app/view/component/scroll_list_view_controller.dart';

class ScrollListView extends StatefulWidget {
  const ScrollListView({Key? key, required this.controller, required this.item}) : super(key: key);

  final ScrollListViewController controller;
  final List<String> item;

  @override
  State<ScrollListView> createState() => _ScrollListViewState();
}

class _ScrollListViewState extends State<ScrollListView> {
  final ScrollController _controller = FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.setCurrentIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    const itemHeight = 42.0;
    final itemCount = widget.item.length;

    return ClickableListWheelScrollView(
      scrollController: _controller,
      itemHeight: itemHeight,
      itemCount: itemCount,
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: itemHeight,
        physics: const FixedExtentScrollPhysics(),
        overAndUnderCenterOpacity: 0.6,
        diameterRatio: 1.5,
        perspective: 0.01,
        onSelectedItemChanged: (idx) => widget.controller.setCurrentIndex(idx),
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, idx) {
            return ScrollListItem(content: widget.item[idx]);
          },
        ),
      ),
    );
  }
}

class ScrollListItem extends StatelessWidget {
  const ScrollListItem({Key? key, required this.content}) : super(key: key);

  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Text(
          content,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
