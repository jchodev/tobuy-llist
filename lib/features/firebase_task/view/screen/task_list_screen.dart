import 'package:flutter/material.dart';
import 'package:to_buy_list/features/firebase_task/model/models.dart';
import 'package:to_buy_list/features/firebase_task/view/widegets/edit_task_bottom_widget.dart';
import 'package:to_buy_list/features/firebase_task/view/widegets/task_list_item.dart';

import '../../../../mvvm/observer.dart';
import '../../../firebase_task/viewmodel/task_viewmodel.dart';

class FirestoreTaskListScreen extends StatefulWidget {

  final FirestoreCategory category;
  const FirestoreTaskListScreen(
      { Key? key, required this.category }
      ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FirestoreTaskListScreenState();
  }
}

class _FirestoreTaskListScreenState extends State<FirestoreTaskListScreen> implements EventObserver {

  late FirestoreCategory _category;
  late TaskViewModel _viewModel;

  bool _isLoading = false;
  List<FirestoreTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _category = widget.category;
    _viewModel = TaskViewModel(
        _category
    );
    _tasks = _category.tasks;
    _viewModel.subscribe(this);
  }

  @override
  void deactivate() {
    super.deactivate();
    _viewModel.unsubscribe(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(_category.name)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomSheet(
                FirestoreTask(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  description: "",
                  done: false,
                  qty: 1,
                  sortedIndex: 999
                ),
                (FirestoreTask task) {
                  _viewModel.addTask(task.description, task.qty);
                }
            );
          },
          child: const Icon(Icons.add),
        ),
        body: _isLoading ?
        const Center(child: CircularProgressIndicator())
            :  listView()
    );

  }

  @override
  void emit(ViewEvent event) {
    print("event:${event}");
    switch (event.runtimeType) {
      case LoadingEvent:
        setState(() {
          _isLoading = (event as LoadingEvent).isLoading;
        });
        break;
      case TasksLoadedEvent:
        setState(() {
          _tasks = (event as TasksLoadedEvent).tasks;
        });
        break;
      case DismissBottomViewEvent:
        Navigator.pop(context);
        break;
      default:
      // Handle unknown event type if needed
        break;
    }
  }

  Widget listView() {
    return ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            FirestoreTask item = _tasks.removeAt(oldIndex);
            item.sortedIndex = newIndex;
            _tasks.insert(newIndex, item);
          });
          _viewModel.updateTasks(_tasks);

          // Update tasks in database
          //updateTasksInDatabase(tasks);
        },
        children: _tasks.map((item) {
          return FirestoreTaskListItem(
            key: Key('${item.id}'),
            task: item,
            onClicked:(FirestoreTask task) {
              showBottomSheet(
                  task, (FirestoreTask task) {
                _viewModel.updateTask(task, true);
              }
              );
            },
            onCheckboxClicked: (bool value) {
              item.done = value;
              _viewModel.updateTask(item, false);
            },
          );
        }).toList()
    );
  }

  void showBottomSheet(FirestoreTask task, OnSaveClicked onSaveClicked ){
    showModalBottomSheet(context: context,
      builder: (BuildContext context) {
        return EditTaskBottomWidget(
            task: task,
            onSaveClicked: onSaveClicked
        );
      },
    );
  }
}

