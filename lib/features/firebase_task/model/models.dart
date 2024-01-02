class FirestoreCategory {
  final String id;
  final String name;
  List<FirestoreTask> tasks;

  FirestoreCategory({
    required this.id,
    required this.name,
    required this.tasks,
  });

  bool areAllTasksDone() {
    for (FirestoreTask task in tasks) {
      if (!task.done) {
        return false;
      }
    }
    return true;
  }

  factory FirestoreCategory.fromJson(Map<String, dynamic> json) {
    return FirestoreCategory(
      id: json['id'],
      name: json['name'],
      tasks: (json['tasks'] as List<dynamic>)
          .map((task) => FirestoreTask.fromJson(task))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tasks': tasks.map((task) => task.toJson()).toList(),
  };
}

class FirestoreTask {
  final String id;
  String description;
  bool done;
  int qty;
  int sortedIndex;

  FirestoreTask({
    required this.id,
    required this.description,
    required this.done,
    required this.qty,
    required this.sortedIndex,
  });

  factory FirestoreTask.fromJson(Map<String, dynamic> json) {
    return FirestoreTask(
      id: json['id'],
      description: json['description'],
      done: json['done'],
      qty: json['qty'],
      sortedIndex: json['sortedIndex']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'done': done,
    'qty': qty,
    'sortedIndex': sortedIndex,
  };
}
