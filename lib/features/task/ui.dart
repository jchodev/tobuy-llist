import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


import '../../mvvm/observer.dart';
import 'model.dart';
import 'repository.dart';
import 'ui/new_category_view.dart';
import 'viewmodel.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TaskWidgetState();
  }
}

class _TaskWidgetState extends State<TaskWidget> implements EventObserver {
  final TaskViewModel _viewModel = TaskViewModel(TaskRepositoryImpl());
  bool _isLoading = false;
  List<CategoryTask> _tasks = [];

  @override
  void initState() {
    super.initState();
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
          title: const Text("TO-Buy-List"),
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _viewModel.loadTasks();
        //   },
        //   child: const Icon(Icons.refresh),
        // ),
        floatingActionButton: Column (
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //1
            FloatingActionButton(
                onPressed: () {
                  _viewModel.loadTasks();
                },
                child: const Icon(Icons.refresh),
            ),
            const SizedBox(height: 10),
            //2
            FloatingActionButton(
              onPressed: () {
                //_viewModel.loadTasks();
                showBottomSheet();
              },
              child: const Icon(Icons.add),
            )
          ],
        ),
        body: _isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {

            return ItemCategory(
                categoryTask: _tasks[index],
                onClicked:(bool value) {
                  print("Button clicked with value: $value");
                },
            );


            return ListTile(
              title: Text(_tasks[index].category.name),
              subtitle: Text(_tasks[index].tasks.length.toString()),
            );
          },
        )
    );
  }


  @override
  void emit(ViewEvent event) {
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

  void showBottomSheet(){
    showModalBottomSheet(context: context,
      builder: (BuildContext context) {

        TextEditingController _textFieldController = TextEditingController();

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
                          child: Text("NEW LIST",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 40.0
                            ),
                          )
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _textFieldController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'New List',
                            prefixIcon: Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Icon(
                                  Icons.category
                              ),
                            )
                        ),
                      ),
                      const SizedBox(height: 16),
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
                            _viewModel.loadTasks();
                            _viewModel.createCategory(_textFieldController.text);
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
      },
    );
  }
}