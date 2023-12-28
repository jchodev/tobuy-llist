import 'package:to_buy_list/features/task/repository.dart';

import '../../mvvm/observer.dart';
import '../../mvvm/viewmodel.dart';
import 'model.dart';


class TaskViewModel extends EventViewModel {
  TaskRepository _repository;

  TaskViewModel(this._repository);

  void loadTasks() {
    //emit
    emit(LoadingEvent(isLoading: true));
    _repository.loadCategoryTasks().then((value) {
      emit(TasksLoadedEvent(tasks: value));
      emit(LoadingEvent(isLoading: false));
    });
  }

  void createCategory(String name){
    emit(DismissBottomViewEvent());
    emit(LoadingEvent(isLoading: true));

    _repository.addCategory(name);
    _repository.loadCategoryTasks().then((value) {
      emit(TasksLoadedEvent(tasks: value));
      emit(LoadingEvent(isLoading: false));
    });
  }

  // void createTask(String title, String description) {
  //   emit(LoadingEvent(isLoading: true));
  //   // ... code to create the task
  //   emit(TaskCreatedEvent());
  //   emit(LoadingEvent(isLoading: false));
  // }
}

class LoadingEvent extends ViewEvent {
  bool isLoading;

  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class TasksLoadedEvent extends ViewEvent {
  final List<CategoryTask> tasks;

  TasksLoadedEvent({required this.tasks}) : super("TasksLoadedEvent");
}

// should be emitted when
class TaskCreatedEvent extends ViewEvent {
  final Task task;

  TaskCreatedEvent(this.task) : super("TaskCreatedEvent");
}

class DismissBottomViewEvent extends ViewEvent {
  DismissBottomViewEvent() : super("DismissBottomViewEvent");
}
