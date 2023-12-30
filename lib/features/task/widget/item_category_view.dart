import 'package:flutter/material.dart';
import 'package:to_buy_list/features/task/model.dart';

typedef OnItemClicked = void Function(CategoryTask value);

class ItemCategory extends StatefulWidget {
  final CategoryTask categoryTask;
  final OnItemClicked onClicked;

  const ItemCategory(
      { Key? key, required this.categoryTask, required this.onClicked }
      ) : super(key: key);

  @override
  _ItemCategoryState createState() => _ItemCategoryState();

}

class _ItemCategoryState extends State<ItemCategory> {

  late CategoryTask _categoryTask;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _categoryTask = widget.categoryTask;
    _isChecked = widget.categoryTask.areAllTasksDone();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: InkWell (
          onTap: () {
            widget.onClicked(_categoryTask);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            child:  Row(
              children: [
                Text(
                  _categoryTask.category.name,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.grey, // Set a background color
                  radius: 16.0, // Adjust the circle size
                  child: Text(
                    _categoryTask.tasks.length.toString(), // Number to display
                    style: const TextStyle(
                      color: Colors.white, // Set text color
                      fontSize: 10.0, // Adjust text size
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                    _isChecked ? Icons.done : Icons.remove_done
                ),
              ],
            ),
          )
        ),
    );
  }
}