import 'package:flutter/material.dart';

class MultiSelectionListCard extends StatefulWidget {
  final bool isSelected;
  final void Function(bool) onChanged;
  final double? width;
  final double? height;
  final String title;
  final Color? color;
  final Color? fillColorWhenSelected;
  final double childMaxWidth;
  final Widget? child;

  const MultiSelectionListCard(
      {super.key,
      required this.onChanged,
      required this.isSelected,
      this.width,
      required this.title,
      this.color,
      this.height,
      this.fillColorWhenSelected,
      required this.childMaxWidth,
      this.child});

  @override
  State<MultiSelectionListCard> createState() => _MultiSelectionListCardState();
}

class _MultiSelectionListCardState extends State<MultiSelectionListCard> {
  bool isSelected = false;

  Color getButtonPrimaryColor(Set<MaterialState> states) {
    return widget.fillColorWhenSelected ?? Colors.blue;
  }

  Color getWhiteColor(Set<MaterialState> states) {
    return Colors.white;
  }

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  void didUpdateWidget(covariant MultiSelectionListCard oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        isSelected = widget.isSelected;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.color,
      ),
      width: widget.width ?? double.infinity,
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SizedBox(
              width: widget.childMaxWidth-8,
              child: widget.child ??
                  Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
            ),
          ),
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              setState(() {
                isSelected = value ?? false;
              });
              widget.onChanged(value ?? false);
            },
            fillColor: MaterialStateColor.resolveWith((states) {
              if (isSelected == true) {
                return getButtonPrimaryColor(states);
              } else {
                return getWhiteColor(states);
              }
            }),
          ),
        ],
      ),
    );
  }
}
