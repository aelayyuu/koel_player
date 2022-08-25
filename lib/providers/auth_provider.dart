import 'package:flutter/foundation.dart';
import 'package:koel_player/models/user.dart';
import 'package:koel_player/utils/api_request.dart';
import 'package:koel_player/utils/preferences.dart' as preferences;

class AuthProvider {
  late User _authUser;
  User get authUser => _authUser;

  Future<bool> login({required String email, required String password}) async {
    final Map<String, String> loginData = {
      'email': email,
      'password': password,
    };

    try {
      final responseData = await post('me', data: loginData);
      preferences.apiToken = responseData['token'];
      return true;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
  }

  void setAuthUser(User user) => _authUser = user;

  Future<User?> tryGetAuthUser() async {
    if (preferences.apiToken == null) {
      return null;
    }

    setAuthUser(User.fromJson(await get('me')));

    return authUser;
  }

  Future<void> logout() async {
    try {
      await delete('me');
    } catch (_) {}

    preferences.apiToken = null;
  }
}
