class AppFailure implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppFailure(this.message, [this.stackTrace]);

  @override
  String toString() => message;
}

class UserNotFoundFailure extends AppFailure {
  UserNotFoundFailure() : super('Usuário não encontrado no banco de dados');
}