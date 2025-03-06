part of 'checkout_attendance_bloc.dart';

@freezed
class CheckoutAttendanceState with _$CheckoutAttendanceState {
  const factory CheckoutAttendanceState .initial() = _Initial;
  const factory CheckoutAttendanceState .loading() = _Loading;
  const factory CheckoutAttendanceState .success(AttendanceRecordModel attendance) = _Success;
  const factory CheckoutAttendanceState .error(String error) = _Error;
}
