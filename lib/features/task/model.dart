class Task {
  int id;
  String description;
  int categoryId;
  int qty;
  bool done;
  int sortedIndex = 999;

  Task(this.id, this.description, this.categoryId, this.qty, this.done);
}

class Category {
  int id;
  String name;
  int sortedIndex = 999;
  Category(this.id, this.name);
}

class CategoryTask {
  Category category;
  List<Task> tasks;

  CategoryTask(this.category, this.tasks);

  bool areAllTasksDone() {
    for (Task task in tasks) {
      if (!task.done) {
        return false;
      }
    }
    return true;
  }
}