part of 'login_bloc.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState.initial() = _Initial;
  factory LoginState.success() = _Success;
  factory LoginState.loading() = _Loading;
  factory LoginState.error(String message) = _Error;
}
