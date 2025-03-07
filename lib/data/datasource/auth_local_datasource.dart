import 'package:shared_preferences/shared_preferences.dart';

import '../../core/core.dart';
import '../model/auth_response_model.dart';
import '../model/user_response_model.dart';

class AuthLocalDatasource {
  Future<void> saveAuthData(AuthResponseModel auth) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(authKey, auth.toRawJson());
  }

  Future<void> updateAuthData(UserResponseModel data) async {
    final pref = await SharedPreferences.getInstance();
    final authData = await getAuthData();
    if (authData != null) {
      final updatedData = authData.copyWith(user: data);
      await pref.setString(authKey, updatedData.toRawJson());
    }
  }

  Future<void> removeAuthData() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(authKey);
  }

  Future<AuthResponseModel?> getAuthData() async {
    final pref = await SharedPreferences.getInstance();
    final authData = pref.getString(authKey);
    if (authData == null) {
      return null;
    } else {
      return AuthResponseModel.fromJson(authData);
    }
  }

  Future<bool> isAuth() async {
    final pref = await SharedPreferences.getInstance();
    final data = pref.getString(authKey);
    return data != null;
  }
}
