import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

import '../core/failures.dart';
import '../models/gen.dart';
import '../services/firebase_auth_service.dart';
import '../services/realtime_db_service.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final RealtimeDbService _dbService;

  AuthRepository({
    required FirebaseAuthService authService,
    required RealtimeDbService dbService,
  }) : _authService = authService,
       _dbService = dbService;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  AsyncResult<ChatUser> login(LoginInput input) {
    return _authService.login(input).flatMap((firebaseUser) {
      return _dbService.getUser(firebaseUser.uid);
    });
  }

  AsyncResult<Unit> register(RegisterInput input) {
    return _authService.signUp(input).flatMap((firebaseUser) {
      final newUser = ChatUser(
        id: firebaseUser.uid,
        name: input.name,
        email: input.email,
      );

      return _dbService.saveUser(newUser);
    });
  }

  AsyncResult<ChatUser> getUserProfile(String uid) {
    return _dbService.getUser(uid);
  }

  AsyncResult<Unit> logout() => _authService.logout();

  AsyncResult<Unit> completeProfile(String name) {
    return _authService.updateDisplayName(name).flatMap((_) {
      final user = _authService.currentUser;

      if (user == null) {
        return Failure(AppFailure('Erro de sessão durante o cadastro'));
      }
      final newChatUser = ChatUser(
        id: user.uid,
        name: name,
        email: user.email ?? '',
      );
      return _dbService.saveUser(newChatUser);
    });
  }
}
