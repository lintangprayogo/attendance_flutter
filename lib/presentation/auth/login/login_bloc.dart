import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/datasource/auth_remote_datasource.dart';
part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDatasource _authRemoteDatasource = AuthRemoteDatasource();
  LoginBloc() : super(_Initial()) {
    on<_Login>((event, emit) async {
      emit(_Loading());
      final response = await _authRemoteDatasource.login(
          email: event.email, password: event.password);

      response.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Success());
      });
    });
  }
}


