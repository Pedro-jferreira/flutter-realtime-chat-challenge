import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

import '../core/failures.dart';
import '../models/gen.dart';
import '../services/firebase_auth_service.dart';
import '../services/realtime_db_service.dart';

class AuthRepository extends ChangeNotifier {
  final FirebaseAuthService _authService;
  final RealtimeDbService _dbService;

  late final StreamSubscription<User?> _authSubscription;

  AuthRepository({
    required FirebaseAuthService authService,
    required RealtimeDbService dbService,
  }) : _authService = authService,
       _dbService = dbService {
    _currentUser = _authService.currentUser;
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  User? _currentUser;

  User? get currentUser => _currentUser;
  AsyncResult<ChatUser> login(LoginInput input) {
    return _authService.login(input).flatMap((firebaseUser) {
      _currentUser = firebaseUser;
      notifyListeners();
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

      return _dbService.saveUser(newUser).onSuccess((_) {
        _currentUser = firebaseUser;
        notifyListeners();
      });
    });
  }

  AsyncResult<ChatUser> getUserProfile(String uid) {
    return _dbService.getUser(uid);
  }

  AsyncResult<Unit> logout() => _authService.logout().onSuccess((_) {
    _currentUser = null;
    notifyListeners();
  });

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
      return _dbService.saveUser(newChatUser).onSuccess((_) {
        _currentUser = _authService.currentUser;
        notifyListeners();
      });
    });
  }
}
