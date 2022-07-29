
import 'dart:convert';

class UserCredentials{
  late String email;
  late String password;
  late bool isSelected=false;
  UserCredentials({required this.email,required this.password});

factory UserCredentials.fromJson(Map<String, dynamic> jsonData) {
  return UserCredentials(
    email: jsonData['email'],
    password: jsonData['password'],
  );
}

static Map<String, dynamic> toMap(UserCredentials userCredentials) => {
  'email': userCredentials.email,
  'password': userCredentials.password,
};

static String encode(List<UserCredentials> userCredentialsList) => json.encode(
  userCredentialsList
      .map<Map<String, dynamic>>((userCredentials) => UserCredentials.toMap(userCredentials))
      .toList(),
);

static List<UserCredentials> decode(String userCredentialsList) =>
    (json.decode(userCredentialsList) as List<dynamic>)
        .map<UserCredentials>((item) => UserCredentials.fromJson(item))
        .toList();

}

class SingletonUser{
  late UserCredentials userCredentials=UserCredentials(email: '', password: '');
}