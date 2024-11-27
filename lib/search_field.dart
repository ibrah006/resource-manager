import 'package:flutter/material.dart';
import 'package:resource_manager/add_screen.dart';
import 'package:resource_manager/item.dart';

class SearchField extends StatefulWidget {

  const SearchField({required this.controller, required this.items, this.hint = "Enter name", this.onlyItems = false, required this.onSelected});

  final TextEditingController controller;

  final List<Item> items;

  final String hint;

  final bool onlyItems;

  final Function(String value) onSelected;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  
  List<Item> filteredItems = [];

  bool validate = false;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items.toList();  // Initialize with all items.
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = widget.items.toList();  // If empty, show all items.
      } else {
        filteredItems = widget.items
            .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

        if (widget.onlyItems && filteredItems.isEmpty) {
          validate = true;
        }
      }
    });
  }

  _input() {

    late final Item? selectedItem;
    try {
      selectedItem = widget.items.firstWhere((item)=> item.name.toLowerCase() == widget.controller.text.toLowerCase());
    } catch(e) {
      selectedItem = null;
    }

    return TextField(
      style: TextStyle(color: Colors.white),
      controller: widget.controller,
      decoration: AddEntryScreen.inputDecoration(widget.hint).copyWith(errorText: validate? "item not found" : null).copyWith(
        suffixIcon: selectedItem != null
        ? Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent.shade400, size: 18),
                  SizedBox(width: 6),
                  Text(
                    '${selectedItem.netQuantity()} left',
                    style: TextStyle(color: Colors.greenAccent.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
          )
        : null
      ),
      onChanged: _onSearchChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _input(),
        SizedBox(height: 8),
        if (filteredItems.isNotEmpty && widget.controller.text.isNotEmpty)
          Container(
            height: 150,  // Height of the dropdown-like container
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredItems[index].name, style: TextStyle(color: Colors.white),),
                  onTap: () {
                    // Set the text field to the selected item.
                    widget.controller.text = filteredItems[index].name;
                    widget.onSelected(filteredItems[index].name);
                    setState(() {
                      filteredItems = [];  // Hide suggestions after selection.
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}