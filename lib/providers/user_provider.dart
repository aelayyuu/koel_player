import 'package:koel_player/models/user.dart';
import 'package:koel_player/utils/api_request.dart';
import 'package:koel_player/utils/preferences.dart' as preferences;
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  late User _authUser;

  User get authUser => _authUser;

  void setAuthUser(User user) {
    _authUser = user;
    notifyListeners();
  }

  Future<User?> tryGetAuthUser() async {
    if (preferences.apiToken == null) {
      return null;
    }

    setAuthUser(User.fromJson(await get('me')));

    return authUser;
  }
}
