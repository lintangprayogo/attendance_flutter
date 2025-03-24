import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

import '../../core/constants/constants.dart';
import '../model/request/permission_request.dart';
import '../model/response/permission_response_model.dart';
import 'auth_local_datasource.dart';

class PermissionRemoteDataSource {
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  final dio = Dio();

  Future<Either<String, List<PermissionResponseModel>>> getPermissions() async {
    try {
      final response = await dio.post(
        '${baseUrl}permission',
      );

      return right((response.data as List<dynamic>)
          .map((e) => PermissionResponseModel.fromMap(e))
          .toList());
    } catch (e) {
      return left(e.toString());
    }
  }

  Future<Either<String, PermissionResponseModel>> createPermission(
      PermissionRequest request) async {
    try {
      final auth = await _authLocalDatasource.getAuthData();

      final formData = FormData.fromMap({
        'date': request.date,
        'reason': request.reason,
        'image': request.image != null
            ? await MultipartFile.fromFile(
                request.image!,
              )
            : null,
      });
      final response = await dio.post('${baseUrl}permission',
          data: formData,
          options: Options(headers: {
            'accept': 'application/json',
            'authorization': 'Bearer ${auth?.token}',
            'Content-Type': 'multipart/form-data'
          }));

      return right(PermissionResponseModel.fromMap(response.data['data']));
    } catch (e) {
      return left(e.toString());
    }
  }
}
