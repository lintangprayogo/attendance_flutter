import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/auth_remote_datasource.dart';
import '../../../../data/model/user_response_model.dart';

part 'update_user_register_face_event.dart';
part 'update_user_register_face_state.dart';
part 'update_user_register_face_bloc.freezed.dart';

class UpdateUserRegisterFaceBloc
    extends Bloc<UpdateUserRegisterFaceEvent, UpdateUserRegisterFaceState> {

 
    
  UpdateUserRegisterFaceBloc(AuthRemoteDatasource dataSource) : super(const _Initial()) {

    on<_UpdateProfileRegisterFace>((event, emit) async {
      emit(const _Loading());

      final result = await dataSource.updateProfileRegisterFace(
          embedding: event.embedding);
          
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Success(r));
      });
    });
  }
}
