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
      :   ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, index) {
              return ItemTask(
                task: _tasks[index],
                onClicked:(Task task) {
                  showBottomSheet(
                      task,
                      (Task task) {
                        _viewModel.updateTask(task, true);
                      }
                  );
                },
                onCheckboxClicked: (bool value) {
                  _tasks[index].done = value;
                  _viewModel.updateTask(_tasks[index], false);
                },
              );
            }
          )
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

