import 'package:flutter/material.dart';
import 'package:to_buy_list/features/task/model.dart';

import '../../../mvvm/observer.dart';
import '../viewmodel/task_viewmodel.dart';
import 'edit_task_bottom_widget.dart';
import 'item_task_view.dart';

class DetailPage extends StatefulWidget {

  final CategoryTask categoryTask;
  const DetailPage(
      { Key? key, required this.categoryTask }
      ) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DetailPageState();
  }
}

class _DetailPageState extends State<DetailPage> implements EventObserver {

  late CategoryTask _categoryTask;
  late TaskViewModel _viewModel;

  bool _isLoading = false;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _categoryTask = widget.categoryTask;
    _viewModel = TaskViewModel(
        _categoryTask.category
    );
    _tasks = _categoryTask.tasks;
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
        title: Text(_categoryTask.category.name)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            Task(
              0,
              "",
              _categoryTask.category.id,
              1,
              false
            ),
            (Task task) {
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
          // Handle item reordering logic here
          if (oldIndex < newIndex) {
            for (int i = oldIndex; i < newIndex; i++) {
              _tasks[i].sortedIndex--;
            }
          } else {
            for (int i = newIndex; i < oldIndex; i++) {
              _tasks[i].sortedIndex++;
            }
          }
          _tasks.forEach((element) {
            print(element.description);
          });
          // Update tasks in database
          //updateTasksInDatabase(tasks);
        },
        children: _tasks.map((item) {
          return ItemTask(
            key: Key('${item.id}'),
            task: item,
            onClicked:(Task task) {
              showBottomSheet(
                  task, (Task task) {
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

  void showBottomSheet(Task task, OnSaveClicked onSaveClicked ){
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

