part of 'create_permission_bloc.dart';

@freezed
class CreatePermissionState with _$CreatePermissionState {
  const factory CreatePermissionState.initial() = _Initial;
  const factory CreatePermissionState.loading() = _Loading;
  const factory CreatePermissionState.error(String msg) = _Error;
  const factory CreatePermissionState.success() = _Success;
}
