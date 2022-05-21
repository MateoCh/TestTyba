/**
 * Contains current logged user's data.
 */
class User {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  User({String? token, DateTime? expiryDate, String? userId})
      : _token = token,
        _expiryDate = expiryDate,
        _userId = userId;

  Map<String, dynamic> toJson() => {
        'idToken': _token,
        'expiryDate':
            _expiryDate == null ? null : _expiryDate!.toIso8601String(),
        'localId': _userId
      };

  User.fromJson(Map<String, dynamic> json)
      : _token = json['idToken'],
        _userId = json['localId'],
        _expiryDate = json['expiryDate'] != null
            ? DateTime.parse(json['expiryDate'])
            : DateTime.now()
                .add(Duration(seconds: int.parse(json['expiresIn'])));

  /**
   * GETTERS
   */
  String? get token =>
      _expiryDate != null && _expiryDate!.isAfter(DateTime.now())
          ? _token
          : null;

  String? get userId => _userId;

  DateTime? get expiryDate => _expiryDate;

  /**
   * SETTERS
   */
  void set token(String? token) => _token = token;
  void set userId(String? userId) => _userId = userId;
  void set expiryDate(DateTime? expiryDate) => _expiryDate = expiryDate;
}
