import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/constants/constants.dart';
import '../model/request/check_in_request.dart';
import '../model/request/check_out_request.dart';
import '../model/response/attendance_response_model.dart';
import 'auth_local_datasource.dart';

class AttendanceRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  final _dio = Dio();

  Future<Either<String, AttendanceRecordModel>> checkin(
      CheckinRequest request) async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final response = await _dio.post('${baseUrl}checkin',
          data: request.toJson(),
          options: Options(headers: {
            'accept': 'application',
            'authorization': 'Bearer ${auth?.token}'
          }));

      return right(AttendanceRecordModel.fromMap(response.data['attendance']));
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }

  Future<Either<String, AttendanceRecordModel>> checkout(
      CheckoutRequest request) async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final response = await _dio.post('${baseUrl}checkout',
          data: request.toJson(),
          options: Options(headers: {
            'accept': 'application',
            'authorization': 'Bearer ${auth?.token}'
          }));

      return right(AttendanceRecordModel.fromMap(response.data['attendance']));
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }

  Future<Either<String, AttendanceRecordModel>> isCheckin() async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final response = await _dio.post('${baseUrl}is-checkin',
          options: Options(headers: {
            'accept': 'application',
            'authorization': 'Bearer ${auth?.token}'
          }));

      return right(AttendanceRecordModel.fromMap(response.data['attendance']));
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }
}
