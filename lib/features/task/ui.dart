import 'package:flutter/material.dart';
import 'package:to_buy_list/features/task/di/task_module.dart';
import 'package:to_buy_list/features/task/viewmodel/category_task_viewmodel.dart';
import 'package:to_buy_list/features/task/widget/detail_page.dart';

import '../../mvvm/observer.dart';
import 'model.dart';
import 'repository.dart';
import 'widget//item_category_view.dart';
import 'package:need_resume/need_resume.dart';


class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TaskWidgetState();
  }
}

class _TaskWidgetState extends ResumableState<TaskWidget> implements EventObserver {

  final CategoryTaskViewModel _viewModel = CategoryTaskViewModel();

  bool _isLoading = false;
  List<CategoryTask> _categories = [];

  @override
  void initState() {
    super.initState();
    _viewModel.subscribe(this);
  }

  @override
  void onReady() {
    // Implement your code inside here

    print('TaskWidget is ready!');
  }

  @override
  void onResume() {
    // Implement your code inside here

    print('TaskWidget is resumed!');
  }

  @override
  void onPause() {
    // Implement your code inside here

    print('TaskWidget is paused!');
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
        floatingActionButton: Column (
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //1
            FloatingActionButton(
                onPressed: () {
                  _viewModel.loadCategoryTasks();
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
          itemCount: _categories.length,
          itemBuilder: (context, index) {

            return ItemCategory(
                categoryTask: _categories[index],
                onClicked:(CategoryTask value) {
                  // 跳轉到另一個畫面，使用自定義動畫
                  gotoDetailPage(true, value);
                  print("Button clicked with value: ${value.category.name}");
                },
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
      case CategoryTasksLoadedEvent:
        setState(() {
          _categories = (event as CategoryTasksLoadedEvent).tasks;
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
                                fontSize: 36.0
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

  void gotoDetailPage(bool enterFromBottom, CategoryTask categoryTask){
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailPage(categoryTask : categoryTask)));
  }

  void gotoDetailPage2(bool enterFromBottom, CategoryTask categoryTask){
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return DetailPage(categoryTask : categoryTask);
        },
        transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          if (enterFromBottom) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: Offset(0.0, 1.0), end: Offset.zero),
              ),
              child: child,
            );
          }
          else {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          }
        },
      ),
    );
  }
}