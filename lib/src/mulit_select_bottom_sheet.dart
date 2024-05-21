import 'package:flutter/material.dart';
import '../multi_select_bottom_sheet_item.dart';
import 'multi_selection_list_card.dart';

class MultiSelectBottomSheetWidget extends StatefulWidget {
  final String title;
  final List<MultiSelectionBottomSheetItem> items;
  final List<bool> selectedItems;
  final bool? isLoading;
  final void Function()? onTap;
  final void Function(List<bool>?) onChanged;
  final bool? showError;
  final String? errorText;
  final TextStyle? clearButtonStyle;
  final double maxChildWidth;
  //This message will be displayed when the list is empty
  final String? emptyListMessage;

  const MultiSelectBottomSheetWidget(
      {super.key,
      this.items = const [],
      required this.title,
      this.selectedItems = const [],
      this.onTap,
      required this.onChanged,
      this.isLoading,
      this.showError,
      this.errorText,
      this.clearButtonStyle,
      required this.maxChildWidth,
      this.emptyListMessage});

  @override
  State<MultiSelectBottomSheetWidget> createState() =>
      _MultiSelectBottomSheetWidgetState();
}

class _MultiSelectBottomSheetWidgetState<T>
    extends State<MultiSelectBottomSheetWidget> {
  List<bool> selections = [];
  final ScrollController _scrollController = ScrollController();
  ValueNotifier<bool> selectAll = ValueNotifier(false);
  int totalSelections = 0;

  @override
  void initState() {
    selections = [];
    super.initState();
  }

  String getWidgetDisplayText({required int index}) {
    if (widget.isLoading == true) {
      return 'Loading...';
    } else if (widget.items.isEmpty) {
      return 'Select ${widget.title}';
    } else {
      int firstItem = -1;
      for (int i = 0; i < widget.selectedItems.length; i++) {
        if (widget.selectedItems[i] == true) {
          firstItem = i;
          break;
        }
      }

      if (firstItem == -1) {
        return "Select ${widget.title}";
      } else {
        return widget.items[firstItem].text;
      }
    }
  }

  int getSelectedItemsCount() {
    int count = 0;
    for (var v in widget.selectedItems) {
      if (v == true) {
        count++;
      }
    }

    return count - 1;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.onTap != null) {
          widget.onTap!();
          return;
        }

        if (widget.isLoading == true) {
          return;
        }

        if (widget.items.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  widget.emptyListMessage ?? 'No data available',
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        totalSelections = 0;
        for (var v in widget.selectedItems) {
          if (v == true) {
            totalSelections++;
          }
        }
        if (totalSelections == widget.items.length) {
          selectAll.value = true;
        } else {
          selectAll.value = false;
        }
        setState(() {
          selections = List.from(widget.selectedItems);
        });
        List<bool>? val = await showModalBottomSheet(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, sheetSetState) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select ${widget.title}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              sheetSetState(() {
                                selections =
                                    List.filled(widget.items.length, false);
                              });
                              selectAll.value = false;
                            },
                            child: Text(
                              'Clear',
                              style: widget.clearButtonStyle ??
                                  const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: selectAll,
                        builder: (BuildContext context, bool value, Widget? child) {
                          return MultiSelectionListCard(
                            onChanged: (val) {
                              selectAll.value = val;
                              sheetSetState(() {
                                selections =
                                    List.filled(widget.items.length, val);
                              });
                            },
                            isSelected: value,
                            title: 'Select All',
                            childMaxWidth: widget.maxChildWidth,
                          );
                        },
                      ),
                      if (widget.items.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Center(
                            child: Text(
                              'No Data Available',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: selections.length,
                              itemBuilder: (context, index) {
                                return MultiSelectionListCard(
                                  title: widget.items[index].text,
                                  childMaxWidth: widget.maxChildWidth,
                                  onChanged: (val) {
                                    setState(() {
                                      selections[index] = val;
                                    });
                                    if (val == false) {
                                      sheetSetState(() {
                                        totalSelections--;
                                      });
                                      selectAll.value = false;
                                    } else {
                                      sheetSetState(() {
                                        totalSelections++;
                                      });
                                    }
                                    if (totalSelections ==
                                        widget.items.length) {
                                      selectAll.value = true;
                                    }
                                  },
                                  isSelected: selections[index],
                                );
                              },
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, selections);
                              },
                              child: const Text(
                                'Confirm',
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
            });
        widget.onChanged(val);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.title,
          errorText: widget.showError == true
              ? widget.errorText ??
                  'Please select a ${widget.title.toLowerCase()}'
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                getWidgetDisplayText(index: 0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (getSelectedItemsCount() > 0)
              Text(' +${getSelectedItemsCount()}')
            else
              const Text(' '),
          ],
        ),
      ),
    );
  }
}
