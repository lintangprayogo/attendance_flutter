import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/constants/constants.dart';
import '../model/request/check_in_check_out_request.dart';
import '../model/response/attendance_response_model.dart';
import '../model/response/company_response_model.dart';
import 'auth_local_datasource.dart';

class AttendanceRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  final _dio = Dio();

  Future<Either<String, AttendanceRecordModel?>> getAttendance(
      String date) async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final response = await _dio.get('${baseUrl}attendances?date=$date',
          options: Options(headers: {
            'accept': 'application/json',
            'authorization': 'Bearer ${auth?.token}'
          }));

      final data =    response.data['data'] as List<dynamic>;

      if (data.isEmpty) {
        return right(null);
      }
      return right(AttendanceRecordModel.fromMap(data.first));
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }

  Future<Either<String, AttendanceRecordModel>> checkin(
      CheckinCheckOutRequest request) async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final response = await _dio.post('${baseUrl}checkin',
          data: request.toJson(),
          options: Options(headers: {
            'accept': 'application/json',
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
      CheckinCheckOutRequest request) async {
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

      final response = await _dio.get('${baseUrl}is-checkin',
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
