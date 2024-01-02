import 'package:get_it/get_it.dart';
import 'package:to_buy_list/features/firebase_task/repository/category_repository.dart';

import '../repository.dart';


void setupTaskLocator(GetIt getIt) {
  getIt.registerSingleton<TaskRepository>(TaskRepositoryImpl());
  getIt.registerSingleton<CategoryRepository>(CategoryRepositoryImpl());

  // Register a factory for services with multiple instances
//  getIt.registerFactory<DatabaseService>(() => DatabaseServiceImpl());
}