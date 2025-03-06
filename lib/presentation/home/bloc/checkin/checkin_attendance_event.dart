part of 'checkin_attendance_bloc.dart';

@freezed
class CheckinAttendanceEvent with _$CheckinAttendanceEvent {
  const factory CheckinAttendanceEvent.started() = _Started;
  const factory CheckinAttendanceEvent.fecth() = _Fetch;
  const factory CheckinAttendanceEvent.checkin(CheckinRequest request) =
      _Checkin;
  const factory CheckinAttendanceEvent.checkout(CheckoutRequest request) =
      _Checkout;
}
