part of 'create_permission_bloc.dart';

@freezed
class CreatePermissionEvent with _$CreatePermissionEvent {
  const factory CreatePermissionEvent.started() = _Started;
  const factory CreatePermissionEvent.create({
    required String date,
    required String reason,
    required String? image,
  }) = _Create;
}
