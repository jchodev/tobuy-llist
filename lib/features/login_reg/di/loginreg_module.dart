import 'package:get_it/get_it.dart';
import 'package:to_buy_list/features/firebase_task/repository/category_repository.dart';

import '../repository/firebase_auth_repository.dart';


void setupLoginRegModule(GetIt getIt) {
  getIt.registerSingleton<FirebaseAuthRepository>(FirebaseAuthRepositoryImpl());

}