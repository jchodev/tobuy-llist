import 'package:to_buy_list/features/task/repository.dart';

import '../../../di/app_module.dart';
import '../../../mvvm/observer.dart';
import '../../../mvvm/viewmodel.dart';
import '../model/models.dart';
import '../repository/category_repository.dart';

class TaskViewModel extends EventViewModel {

  //inject
  final CategoryRepository _repository = getIt<CategoryRepository>();
  late FirestoreCategory _category;

  TaskViewModel(this._category);

  void reloadTasks() {
    //emit
    emit(LoadingEvent(isLoading: true));
    _repository.getCategoryById(_category.id).then((value) {
      if (value != null){
        emit(TasksLoadedEvent(tasks: value.tasks));
      }
      emit(LoadingEvent(isLoading: false));
    });
  }

  void addTask(String description, int qty){
    emit(DismissBottomViewEvent());
    emit(LoadingEvent(isLoading: true));
    _repository.addTask(
        FirestoreTask(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            description: description,
            done: false,
            qty: qty,
            sortedIndex: 999
        ),
        _category
    ).then((value) {
        emit(TasksLoadedEvent(tasks: value.tasks));
        emit(LoadingEvent(isLoading: false));
    }) ;

  }

  void updateTask(FirestoreTask task, bool fromBottomSheet){
    if (fromBottomSheet) {
      emit(DismissBottomViewEvent());
    }
    emit(LoadingEvent(isLoading: true));
    _repository.updateTask(task, _category).then((value) {
      emit(TasksLoadedEvent(tasks: value.tasks));
      emit(LoadingEvent(isLoading: false));
    });
  }

  void updateTasks(List<FirestoreTask> tasks){
    emit(LoadingEvent(isLoading: true));
    _repository.updateTasks(tasks, _category).then((value) {
      emit(TasksLoadedEvent(tasks: value.tasks));
      emit(LoadingEvent(isLoading: false));
    });
  }
}


class LoadingEvent extends ViewEvent {
  bool isLoading;

  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class TasksLoadedEvent extends ViewEvent {
  final List<FirestoreTask> tasks;

  TasksLoadedEvent({required this.tasks}) : super("TasksLoadedEvent");
}

// should be emitted when
class TaskCreatedEvent extends ViewEvent {
  final FirestoreTask task;

  TaskCreatedEvent(this.task) : super("TaskCreatedEvent");
}

class DismissBottomViewEvent extends ViewEvent {
  DismissBottomViewEvent() : super("DismissBottomViewEvent");
}
