part of 'gen.dart';


@freezed
abstract class LoginInput with _$LoginInput {
  const factory LoginInput({
    required String email,
    required String password,
  }) = _LoginInput;
}

@freezed
abstract class RegisterInput with _$RegisterInput {
  const factory RegisterInput({
    required String name,
    required String email,
    required String password,
  }) = _RegisterInput;
}