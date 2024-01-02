import 'package:flutter/material.dart';
import 'package:need_resume/need_resume.dart';
import 'package:to_buy_list/features/firebase_task/model/models.dart';
import 'package:to_buy_list/features/firebase_task/view/screen/task_list_screen.dart';
import 'package:to_buy_list/features/firebase_task/viewmodel/category_list_viewmodel.dart';
import 'package:to_buy_list/mvvm/observer.dart';

import '../widegets/category_list_item.dart';

class FirestoreCategoryListScreen extends StatefulWidget {
  const FirestoreCategoryListScreen({super.key});

  @override
  State<FirestoreCategoryListScreen> createState() {
    return FirestoreCategoryListScreenState();
  }
}

class FirestoreCategoryListScreenState extends ResumableState<FirestoreCategoryListScreen> implements EventObserver{

  final CategoryListViewModel _viewModel = CategoryListViewModel();

  bool _isLoading = false;
  List<FirestoreCategory> _categories = [];

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
  void onReady() {
    // Implement your code inside here

    print('CategoryListScreen is ready!');
    _viewModel.loadCategories();
  }

  @override
  void onResume() {
    // Implement your code inside here
    _viewModel.loadCategories();
    print('CategoryListScreen is resumed!');
  }

  @override
  void onPause() {
    // Implement your code inside here

    print('CategoryListScreen is paused!');
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
                _viewModel.loadCategories();
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
        ) : listView()
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
      case CategoriesLoadedEvent:
        setState(() {
          _categories = (event as CategoriesLoadedEvent).categories;
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

  void gotoDetailPage(bool enterFromBottom, FirestoreCategory category){
    push(context, MaterialPageRoute(builder: (context) => FirestoreTaskListScreen(category : category)));
  }


  Widget listView() {
    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return CategoryListItem(
          category: _categories[index],
          onClicked:(FirestoreCategory value) {
            // 跳轉到另一個畫面，使用自定義動畫
            gotoDetailPage(true, value);
            print("Button clicked with value: ${value.name}");
          },
        );
      },
    );
  }
}