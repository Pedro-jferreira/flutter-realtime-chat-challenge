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

bool isUserNotFound(Object? failure) {
  return failure is UserNotFoundFailure;
}

class AuthErrors {
  static String translate(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        // Por segurança, o Firebase agora agrupa erros de senha/email
        // no 'invalid-credential' para não revelar se o email existe.
        return 'E-mail ou senha incorretos.';

      case 'invalid-email':
        return 'O formato do e-mail é inválido.';

      case 'user-disabled':
        return 'Este usuário foi desativado.';

      case 'too-many-requests':
        return 'Muitas tentativas. Aguarde uns minutos e tente novamente.';

      case 'operation-not-allowed':
        return 'Login com e-mail e senha não está habilitado no Firebase.';

      case 'network-request-failed':
        return 'Sem conexão com a internet.';

      case 'email-already-in-use':
        return 'Este e-mail já está cadastrado em outra conta.';

      case 'weak-password':
        return 'A senha é muito fraca. Digite pelo menos 6 caracteres.';

      default:
        return 'Erro desconhecido de autenticação ($code)';
    }
  }
}