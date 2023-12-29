import 'model.dart';


abstract class TaskRepository {
  void addCategory(String name);
  void removeCategory(int id);

  void addTask(Category category, String description, int qty);
  void removeTask(int id);
  Future<bool> updateTask(Task task);

  Future<List<CategoryTask>> loadCategoryTasks();
  Future<List<Task>> loadTasksByCategory(Category category);
}


class TaskRepositoryImpl implements TaskRepository{
  List<Task> _taskList = [
    Task(
        1,
        "Task 1-1",
        1,
        1,
        false
    ),
    Task(
        2,
        "Task 1-2",
        1,
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
  void addTask(Category category, String description, int qty) async {
    // Simulate a http request
    await Future.delayed(const Duration(seconds: 1));

    _taskList.add(
      // Task(this.id, this.description, this.categoryId, this.done);
        Task(
            //id
            _taskList.reduce((curr, next) => curr.id > next.id ? curr : next).id + 1,
            description,
            category.id,
            qty,
            //done
            false
        )
    );
  }

  @override
  void removeTask(int id) {
    // TODO: implement removeTask
  }

  @override
  Future<bool> updateTask(Task task) async {
    await Future.delayed(const Duration(seconds: 1));
    final index = _taskList.indexWhere((existingTask) => existingTask.id == task.id);
    if (index != -1) {
      // Found the task, update its properties
      _taskList[index] = task;
      return true;
    }
    // Task not found, handle the error or log a message
    print("Task with ID ${task.id} not found in the list.");
    return false;
  }

  @override
  Future<List<CategoryTask>> loadCategoryTasks() async {
    // Simulate a http request
    await Future.delayed(const Duration(seconds: 1));

    List<CategoryTask> categoryTasks = [];
    for (Category category in _categoryList) {
      List<Task> tasks = _taskList.where((task) => task.categoryId == category.id).toList();
      categoryTasks.add(CategoryTask(category, tasks));
    }

    return categoryTasks;
  }

  @override
  Future<List<Task>> loadTasksByCategory(Category category) async {
    // Simulate a http request
    await Future.delayed(const Duration(seconds: 1));

    return _taskList.where((task) => task.categoryId == category.id).toList();
  }
}