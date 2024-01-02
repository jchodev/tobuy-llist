
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:to_buy_list/data/remote/RepositoryResult.dart';

abstract class FirebaseAuthRepository {
  Future<RepositoryResult<dynamic>> login(String email, String password);
}

class FirebaseAuthRepositoryImpl implements FirebaseAuthRepository {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<RepositoryResult<dynamic>> login(String email, String password) async{
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success("");

    } on FirebaseAuthException catch (e) {
      // Handle errors (e.g., show error message)
      return Failure(e);
    }
  }

}