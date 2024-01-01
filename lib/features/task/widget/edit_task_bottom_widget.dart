import 'package:flutter/material.dart';

import '../model.dart';

typedef OnSaveClicked = void Function(Task task);

class EditTaskBottomWidget extends StatefulWidget {

  final Task task;
  final OnSaveClicked onSaveClicked;

  const EditTaskBottomWidget(
      { Key? key, required this.task, required this.onSaveClicked }
      ) : super(key: key);

  @override
  State<EditTaskBottomWidget> createState() {
    return _EditTaskBottomWidgetState();
  }
}

class _EditTaskBottomWidgetState extends State<EditTaskBottomWidget>{

  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController _descTextFieldController = TextEditingController();
    _descTextFieldController.text = _task.description;

    return SizedBox(
        height: 400,
        width: double.infinity,
        child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  IconButton(
                    iconSize: 36.0,
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  //title
                  const Align(
                      alignment: Alignment.center,
                      child: Text("New Item",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 36.0
                        ),
                      )
                  ),
                  const SizedBox(height: 16),
                  //desc
                  TextField(
                    controller: _descTextFieldController,
                    decoration: const InputDecoration(
                        border:  OutlineInputBorder(),
                        labelText: 'Description',
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Icon(
                              Icons.description
                          ),
                        )
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15), // Adjust as needed
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Row (
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _task.description = _descTextFieldController.text;
                                _task.qty = _task.qty > 0 ? _task.qty - 1 : 0;
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(_task.qty.toString()),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _task.description = _descTextFieldController.text;
                                _task.qty = _task.qty + 1;
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ]
                    ),
                  ),

                  const Spacer(),
                  MaterialButton(
                      height: 60,
                      minWidth: double.infinity,
                      color: Colors.black ,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(16)
                          )
                      ),
                      onPressed: (){
                        _task.description = _descTextFieldController.text;
                        widget.onSaveClicked(
                          _task
                        );
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                  )
                ]
            )
        )
    );
  }
}