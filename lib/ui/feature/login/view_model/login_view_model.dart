import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../models/gen.dart';
import '../../../../repositories/auth_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  LoginViewModel({required AuthRepository repository})
    : _repository = repository;

  late final loginCommand = Command1<Unit, LoginInput>(_login);

  late final completeProfileCommand = Command1<Unit, String>(_completeProfile);

  AsyncResult<Unit> _login(LoginInput input) async {
    return _repository
        .login(input)
        .mapFold((onSuccess) => unit, (onError) => onError);
  }

  AsyncResult<Unit> _completeProfile(String name) async {
    return _repository.completeProfile(name);
  }
}
