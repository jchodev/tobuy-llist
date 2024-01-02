
import 'package:to_buy_list/features/firebase_task/model/models.dart';

import '../../../mvvm/observer.dart';
import '../../../mvvm/viewmodel.dart';
import '../../task/di/task_module.dart';
import '../repository/category_repository.dart';

class CategoryListViewModel extends EventViewModel {
  //inject
  final CategoryRepository _repository = getIt<CategoryRepository>();

  void loadCategories() {
    print("loadCategories");
    //emit
    emit(LoadingEvent(isLoading: true));
    _repository.fetchCategories().then((value) {
      emit(CategoriesLoadedEvent(categories: value));
      emit(LoadingEvent(isLoading: false));
    });
  }

  void createCategory(String name){
    emit(DismissBottomViewEvent());
    emit(LoadingEvent(isLoading: true));

    _repository.addCategory(
        FirestoreCategory (
          id : DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          tasks: List.empty()
        )
    );
    _repository.fetchCategories().then((value) {
      emit(CategoriesLoadedEvent(categories: value));
      emit(LoadingEvent(isLoading: false));
    });
  }
}

class LoadingEvent extends ViewEvent {
  bool isLoading;

  LoadingEvent({required this.isLoading}) : super("LoadingEvent");
}

class CategoriesLoadedEvent extends ViewEvent {
  final List<FirestoreCategory> categories;

  CategoriesLoadedEvent({required this.categories}) : super("TasksLoadedEvent");
}

class DismissBottomViewEvent extends ViewEvent {
  DismissBottomViewEvent() : super("DismissBottomViewEvent");
}
