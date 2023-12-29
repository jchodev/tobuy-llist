import 'package:get_it/get_it.dart';

import '../repository.dart';

final getIt = GetIt.instance;

void setupTaskLocator() {
  getIt.registerSingleton<TaskRepository>(TaskRepositoryImpl());

  // Register a factory for services with multiple instances
//  getIt.registerFactory<DatabaseService>(() => DatabaseServiceImpl());
}