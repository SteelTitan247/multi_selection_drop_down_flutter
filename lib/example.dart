import 'package:flutter/material.dart';
import 'package:multi_select_bottom_sheet/multi_select_bottom_sheet_item.dart';
import 'package:multi_select_bottom_sheet/src/mulit_select_bottom_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<bool> selectedItems = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Custom Dropdown Example'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: MultiSelectBottomSheetWidget(
              title: 'Items',
              onChanged: (value) {
                debugPrint('Selected item: $value');
                if(value!=null) {
                  setState(() {
                    selectedItems = value;
                  });
                }
              },
              maxChildWidth: MediaQuery.of(context).size.width - 32 - 48,
              items: const [
                MultiSelectionBottomSheetItem(
                  id: 1,
                  text: 'Item 1',
                ),
                MultiSelectionBottomSheetItem(
                  id: 2,
                  text: 'Item 2',
                ),
                MultiSelectionBottomSheetItem(
                  id: 3,
                  text: 'Item 3',
                ),
              ],
              selectedItems: selectedItems,
            ),
          ),
        ),
      ),
    );
  }
}
