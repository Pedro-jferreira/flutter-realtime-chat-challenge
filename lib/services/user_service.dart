import 'package:firebase_database/firebase_database.dart';
import 'package:result_dart/result_dart.dart';

import '../core/failures.dart';
import '../models/gen.dart';

class UserService {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  AsyncResult<Unit> saveUser(ChatUser user) async {
    try {
      await _db.ref('users/${user.id}').set(user.toJson());
      return const Success(unit);
    } catch (e) {
      return Failure(AppFailure('Erro ao salvar no banco'));
    }
  }

  AsyncResult<ChatUser> getUser(String uid) async {
    try {
      final snapshot = await _db.ref('users/$uid').get();
      if (!snapshot.exists || snapshot.value == null) {
        return Failure(UserNotFoundFailure());
      }
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      return Success(ChatUser.fromJson(data));
    } catch (e) {
      return Failure(AppFailure('Erro ao buscar usuário'));
    }
  }
}