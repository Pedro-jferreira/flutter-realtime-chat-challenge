import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

import '../core/failures.dart';
import '../models/gen.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  AsyncResult<User> signUp(RegisterInput input) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: input.email,
        password: input.password,
      );

      if (cred.user != null) {
        await cred.user!.updateDisplayName(input.name);
        await cred.user!.reload();
        final updatedUser = _auth.currentUser;
        return Success(updatedUser!);
      }

      return Failure(AppFailure('Falha ao criar usuário'));
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthErrors.translate(e.code);
      return Failure(AppFailure(errorMessage));
    }
  }

  AsyncResult<User> login(LoginInput input) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: input.email,
          password: input.password
      );
      return cred.user != null
          ? Success(cred.user!)
          : Failure(AppFailure('Usuário nulo'));
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthErrors.translate(e.code);
      return Failure(AppFailure(errorMessage));
    }
  }
  AsyncResult<Unit> updateDisplayName(String name) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Failure(AppFailure('Usuário não autenticado'));
      }

      await user.updateDisplayName(name);
      await user.reload();

      return const Success(unit);
    } on FirebaseAuthException catch (e) {
      final errorMessage = AuthErrors.translate(e.code);
      return Failure(AppFailure(errorMessage));
    } catch (e) {
      return Failure(AppFailure('Erro desconhecido ao atualizar perfil'));
    }
  }

  AsyncResult<Unit> logout() async {
    await _auth.signOut();
    return const Success(unit);
  }
}