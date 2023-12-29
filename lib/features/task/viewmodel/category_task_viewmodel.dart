import 'package:to_buy_list/features/task/repository.dart';

import '../../../mvvm/observer.dart';
import '../../../mvvm/viewmodel.dart';
import '../di/task_module.dart';
import '../model.dart';



class CategoryTaskViewModel extends EventViewModel {
  //inject
  final TaskRepository _repository = getIt<TaskRepository>();

  void loadCategoryTasks() {
    print("loadCategoryTasks");
    //emit
    emit(LoadingEvent(isLoading: true));
    _repository.loadCategoryTasks().then((value) {
      emit(CategoryTasksLoadedEvent(tasks: value));
      emit(LoadingEvent(isLoading: false));
    });
  }

  void createCategory(String name){
    emit(DismissBottomViewEvent());
    emit(LoadingEvent(isLoading: true));

    _repository.addCategory(name);
    _repository.loadCategoryTasks().then((value) {
      emit(CategoryTasksLoadedEvent(tasks: value));
      emit(LoadingEvent(isLoading: false));
    });
  }
}

class LoadingEvent extends ViewEvent {
  bool isLoading;

  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class CategoryTasksLoadedEvent extends ViewEvent {
  final List<CategoryTask> tasks;

  CategoryTasksLoadedEvent({required this.tasks}) : super("TasksLoadedEvent");
}

class DismissBottomViewEvent extends ViewEvent {
  DismissBottomViewEvent() : super("DismissBottomViewEvent");
}
