/**
 * Contains de necessary info to register in the app.
 */
class AuthInfo {
  String _email;
  String _password;
  static const bool _returnSecureToken = true;

  AuthInfo({required String email, required String password})
      : _email = email,
        _password = password;

  /**
   * GETTERS
   */
  String get email => _email;
  String get password => _password;

  /**
   * SETTERS
   */
  void set email(String email) => _email = email;
  void set password(String password) => _password = password;

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'returnSecureToken': _returnSecureToken
      };
}
