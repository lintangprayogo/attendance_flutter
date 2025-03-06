import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/attendance_remote_datasource.dart';
import '../../../../data/model/request/check_in_request.dart';
import '../../../../data/model/response/attendance_response_model.dart';

part 'checkin_attendance_event.dart';
part 'checkin_attendance_state.dart';
part 'checkin_attendance_bloc.freezed.dart';

class CheckinAttendanceBloc
    extends Bloc<CheckinAttendanceEvent, CheckinAttendanceState> {
  CheckinAttendanceBloc(AttendanceRemoteDatasource datasource) : super(const _Initial()) {
    on<_Checkin>((event, emit) async {
      final result = await datasource.checkin(event.request);
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Success(r));
      });
    });   
  }
}
