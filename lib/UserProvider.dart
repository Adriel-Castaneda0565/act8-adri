import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'User.dart';
import 'GithubRequest.dart';

class UserProvider with ChangeNotifier {
  User? user;
  String? errorMessage;
  bool loading = false;

  Future<bool> fetchUser(username) async {
    setLoading(true);
    final data = await Github(username).fetchUser();
    setLoading(false);

    if (data.statusCode == 200) {
      setUser(User.fromJson(json.decode(data.body)));
    } else {
      final result = json.decode(data.body);
      setMessage(result['message']);
    }

    return isUser();
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() => loading;

  void setUser(value) {
    user = value;
    notifyListeners();
  }

  User getUSer() => user!;

  void setMessage(value) {
    errorMessage = value;
    notifyListeners();
  }

  String getMessage() => errorMessage ?? "";

  bool isUser() => user != null;
}
