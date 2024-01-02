import 'package:flutter/material.dart';
import 'package:to_buy_list/features/task/model.dart';

import '../../model/models.dart';

typedef OnItemClicked = void Function(FirestoreCategory value);

class CategoryListItem extends StatefulWidget {
  final FirestoreCategory category;
  final OnItemClicked onClicked;

  const CategoryListItem(
      { Key? key, required this.category, required this.onClicked }
      ) : super(key: key);

  @override
  _CategoryListItemState createState() => _CategoryListItemState();

}

class _CategoryListItemState extends State<CategoryListItem> {

  late FirestoreCategory _category;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _category = widget.category;
    _isChecked = widget.category.areAllTasksDone();
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
            widget.onClicked(_category);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
            child:  Row(
              children: [
                Text(
                  _category.name,
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
                const Spacer(),
                CircleAvatar(
                  backgroundColor: Colors.grey, // Set a background color
                  radius: 16.0, // Adjust the circle size
                  child: Text(
                    _category.tasks.length.toString(), // Number to display
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