part of 'checkin_attendance_bloc.dart';

@freezed
class CheckinAttendanceState with _$CheckinAttendanceState{
  const factory CheckinAttendanceState.initial() = _Initial;
  const factory CheckinAttendanceState.loading() = _Loading;
  const factory CheckinAttendanceState.success(AttendanceRecordModel attendance) = _Success;
  const factory CheckinAttendanceState.error(String error) = _Error;
}
