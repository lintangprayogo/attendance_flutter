import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/core.dart';
import '../model/auth_response_model.dart';
import '../model/user_response_model.dart';
import 'auth_local_datasource.dart';

class AuthRemoteDatasource {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  final dio = Dio();

  Future<Either<String, AuthResponseModel>> login(
      {required String email, required String password}) async {
    try {
      final authResponse = await dio.post('${baseUrl}login',
          data: {'email': email, 'password': password},
          options: Options(headers: {'accept': 'application/json'}));

      final authModel = AuthResponseModel.fromMap(authResponse.data);
      _authLocalDatasource.saveAuthData(authModel);
      return right(authModel);
    } catch (e) {
      if (e is DioException) {
        return Left(e.response?.statusMessage ?? '');
      }
      return left(e.toString());
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      await dio.post('${baseUrl}logout',
          options: Options(
            headers: {
              'Authorization': 'Bearer ${auth?.token}',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));

      _authLocalDatasource.removeAuthData();
      return right('Logout Success');
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }

  Future<Either<String, UserResponseModel>> updateProfileRegisterFace(
      {required String embedding}) async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final response = await dio.post('${baseUrl}update-profile',
          data: {
            'face_embedding': embedding,
          },
          options: Options(headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${auth?.token}',
          }));

      final user = UserResponseModel.fromMap(response.data['user']);
      return right(user);
    } catch (e) {
      if (e is DioException) {
        return Left(e.response?.statusMessage ?? '');
      }
      return left(e.toString());
    }
  }

  Future<Either<String, String>> updateFcm(String fcmToken) async {
  try {
      final auth = await _authLocalDatasource.getAuthData();

      await dio.post('${baseUrl}update-fcm-token',
          
          options: Options(
            headers: {
              'Authorization': 'Bearer ${auth?.token}',
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ));

      _authLocalDatasource.removeAuthData();
      return right('Logout Success');
    } catch (e) {
      if (e is DioException) {
        return left(e.response?.data['message'] ?? 'Something went wrong');
      }
      return left(e.toString());
    }
  }
}
