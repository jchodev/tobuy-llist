import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

void setupAppModule(GetIt getIt) {
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Register a factory for services with multiple instances
//  getIt.registerFactory<DatabaseService>(() => DatabaseServiceImpl());
}