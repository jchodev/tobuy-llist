class Task {
  int id;
  String description;
  int categoryId;
  bool done;

  Task(this.id, this.description, this.categoryId, this.done);
}

class Category {
  int id;
  String name;
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