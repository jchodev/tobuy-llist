import 'package:to_buy_list/features/task/repository.dart';

import '../../../mvvm/observer.dart';
import '../../../mvvm/viewmodel.dart';
import '../di/task_module.dart';
import '../model.dart';


class TaskViewModel extends EventViewModel {

  //inject
  final TaskRepository _repository = getIt<TaskRepository>();

  late Category _category;

  TaskViewModel(this._category);

  void reloadTasks() {
    //emit
    emit(LoadingEvent(isLoading: true));
    _repository.loadTasksByCategory(_category).then((value) {
      emit(TasksLoadedEvent(tasks: value));
      emit(LoadingEvent(isLoading: false));
    });
  }

  void addTask(String description, int qty){
    emit(DismissBottomViewEvent());
    emit(LoadingEvent(isLoading: true));
    _repository.addTask(_category, description, qty);
    _repository.loadTasksByCategory(_category).then((value) {
      emit(TasksLoadedEvent(tasks: value));
      emit(LoadingEvent(isLoading: false));
    });
  }

  void updateTask(Task task, bool fromBottomSheet){
    if (fromBottomSheet) {
      emit(DismissBottomViewEvent());
    }
    emit(LoadingEvent(isLoading: true));
    _repository.updateTask(task);
    _repository.loadTasksByCategory(_category).then((value) {
      emit(TasksLoadedEvent(tasks: value));
      emit(LoadingEvent(isLoading: false));
    });
  }
}


class LoadingEvent extends ViewEvent {
  bool isLoading;

  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class TasksLoadedEvent extends ViewEvent {
  final List<Task> tasks;

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
