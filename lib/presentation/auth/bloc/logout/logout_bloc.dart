import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/auth_remote_datasource.dart';

part 'logout_event.dart';
part 'logout_state.dart';
part 'logout_bloc.freezed.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {


  LogoutBloc(AuthRemoteDatasource datasource) : super(const _Initial()) {
    on<_Logout>((event, emit) async {
      emit(const _Loading());
      final response = await datasource.logout();
      response.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(const _Success());
      });
    });
  }
}
