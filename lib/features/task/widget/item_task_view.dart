import 'package:flutter/material.dart';
import 'package:to_buy_list/features/task/model.dart';

typedef OnItemClicked = void Function(Task value);
typedef OnCheckboxClicked = void Function(bool value);

class ItemTask extends StatefulWidget {
  final Task task;
  final OnItemClicked onClicked;
  final OnCheckboxClicked onCheckboxClicked;

  const ItemTask(
      { Key? key, required this.task, required this.onClicked, required this.onCheckboxClicked }
      ) : super(key: key);

  @override
  _ItemTaskState createState() => _ItemTaskState();

}

class _ItemTaskState extends State<ItemTask> {

  late Task _task;
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _isChecked = _task.done;
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
          widget.onClicked(_task);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
          child:  Center(
              child: GestureDetector(
                child: Row(
                  children: [
                    Text(
                      _task.description,
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    const Spacer(),
                    Text(
                      "x ${_task.qty}",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(width: 16),
                    Checkbox(value: _isChecked, onChanged: (newValue) {
                      setState(() {
                        _isChecked = newValue!;
                      });
                      _task.done = _isChecked;
                      widget.onCheckboxClicked(_isChecked);
                    }),
                    const SizedBox(width: 16),
                  ],
                ),
              )
          ),
        ),
      )
    );
  }
}