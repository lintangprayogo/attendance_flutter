import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasource/attendance_remote_datasource.dart';
import '../../../../data/model/request/check_in_request.dart';
import '../../../../data/model/request/check_out_request.dart';
import '../../../../data/model/response/attendance_response_model.dart';

part 'checkin_attendance_event.dart';
part 'checkin_attendance_state.dart';
part 'checkin_attendance_bloc.freezed.dart';

class AttendanceBloc
    extends Bloc<CheckinAttendanceEvent, CheckinAttendanceState> {
  final AttendanceRemoteDatasource _attendanceRemoteDatasource =
      AttendanceRemoteDatasource();
  AttendanceBloc() : super(const _Initial()) {
    on<_Fetch>((event, emit) async {
      final result = await _attendanceRemoteDatasource.isCheckin();
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Loaded(r));
      });
    });

    on<_Checkin>((event, emit) async {
      final result = await _attendanceRemoteDatasource.checkin(event.request);
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Loaded(r));
      });
    });

    on<_Checkout>((event, emit) async {
      final result = await _attendanceRemoteDatasource.checkout(event.request);
      result.fold((l) {
        emit(_Error(l));
      }, (r) {
        emit(_Loaded(r));
      });
    });
  }
}
