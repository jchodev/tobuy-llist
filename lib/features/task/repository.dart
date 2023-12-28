import 'model.dart';


abstract class TaskRepository {
  void addCategory(String name);
  void removeCategory(int id);

  void addTask(String categoryName, String task);
  void removeTask(int id);
  void updateTask(int id, String description, bool done);

  Future<List<CategoryTask>> loadCategoryTasks();
}


class TaskRepositoryImpl implements TaskRepository{
  List<Task> _taskList = [
    Task(
        1,
        "Task 1-1",
        1,
        false
    ),
    Task(
        1,
        "Task 1-2",
        1,
        false
    ),
  ];

  List<Category> _categoryList = [
    Category(1, "Category1")
  ];

  Future<List<Task>> loadTasks() async {
    // Simulate a http request
    await Future.delayed(const Duration(seconds: 2));
    return Future.value(_taskList);
  }

  @override
  void addCategory(String name) {
    _categoryList.add(
      Category(
        _categoryList.reduce((curr, next) => curr.id > next.id ? curr : next).id + 1,
        name
      )
    );
  }

  @override
  void removeCategory(int id) {
    // TODO: implement removeCategory
  }

  @override
  void addTask(String categoryName, String task) {
    // TODO: implement addTask
  }

  @override
  void removeTask(int id) {
    // TODO: implement removeTask
  }

  @override
  void updateTask(int id, String description, bool done) {
    // TODO: implement updateTask
  }

  @override
  Future<List<CategoryTask>> loadCategoryTasks() async {
    // Simulate a http request
    await Future.delayed(const Duration(seconds: 2));

    List<CategoryTask> categoryTasks = [];
    for (Category category in _categoryList) {
      List<Task> tasks = _taskList.where((task) => task.categoryId == category.id).toList();
      categoryTasks.add(CategoryTask(category, tasks));
    }

    return categoryTasks;
  }
}