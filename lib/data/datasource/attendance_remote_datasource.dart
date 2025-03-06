import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/constants/constants.dart';
import '../model/company/company_response_model.dart';
import '../model/request/check_in_request.dart';
import '../model/request/check_out_request.dart';
import '../model/response/attendance_response_model.dart';
import 'auth_local_datasource.dart';

class AttendanceRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  final _dio = Dio();

  Future<Either<String, AttendanceRecordModel?>> getAttendance(
      String date) async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final response = await _dio.post('${baseUrl}api-attendances?date=$date',
          options: Options(headers: {
            'accept': 'application',
            'authorization': 'Bearer ${auth?.token}'
          }));

      if (response.data['data'] == null) {
        return right(null);
      }
      return right(AttendanceRecordModel.fromMap(response.data['data']));
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }

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

  Future<Either<String, (bool, bool)>> isCheckedin() async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final response = await _dio.post('${baseUrl}is-checkin',
          options: Options(headers: {
            'accept': 'application',
            'authorization': 'Bearer ${auth?.token}'
          }));

      return Right((
        response.data['checkedin'] as bool,
        response.data['checkedout'] as bool
      ));
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }

  Future<Either<String, CompanyResponseModel>> getCompanyProfile() async {
    try {
      final auth = await _authLocalDatasource.getAuthData();
      final response = await _dio.get('${baseUrl}company',
          options:
              Options(headers: {'authorization': 'Bearer ${auth?.token}'}));
      return right(CompanyResponseModel.fromMap(response.data['company']));
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wronf');
      }
      return left(e.toString());
    }
  }
}
