import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/permission_remote_data_source.dart';
import '../../../../data/model/request/permission_request.dart';

part 'create_permission_bloc.freezed.dart';
part 'create_permission_state.dart';
part 'create_permission_event.dart';

class CreatePermissionBloc
    extends Bloc<CreatePermissionEvent, CreatePermissionState> {
  CreatePermissionBloc(PermissionRemoteDataSource dataSource)
      : super(const _Initial()) {
        
    on<_Create>((event, emit) async {
      emit(const _Loading());
      final response = await dataSource.createPermission(PermissionRequest(
          date: event.date, reason: event.reason, image: event.image));
      response.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(const _Success());
      });
    });
  }
}
