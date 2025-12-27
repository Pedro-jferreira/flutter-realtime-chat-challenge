import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../models/gen.dart';
import '../../../../repositories/auth_repository.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  RegisterViewModel({required AuthRepository repository})
    : _repository = repository {
    registerCommand = Command1<Unit, RegisterInput>(_register);
  }

  late final Command1<Unit, RegisterInput> registerCommand;

  AsyncResult<Unit> _register(RegisterInput input) async =>
      _repository.register(input);
}
