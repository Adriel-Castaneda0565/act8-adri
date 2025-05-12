import 'package:http/http.dart' as http;

class Github {
  final String userName;
  final String url = 'api.github.com';
  static String token =
      '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'; // Asegúrate de que esté correctamente configurado

  Github(this.userName);

  Future<http.Response> fetchUser() {
    return http.get(
      Uri.https(url, 'users/$userName'), // URL correcta
      headers: {"Authorization": "Bearer $token"}, // Token correcto aquí
    );
  }

  Future<http.Response> fetchFollowing() {
    return http.get(
      Uri.https(url, 'users/$userName/followers'),
      headers: {"Authorization": "Bearer $token"},
    );
  }
}
