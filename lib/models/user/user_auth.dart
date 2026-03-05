import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_auth.freezed.dart';
part 'user_auth.g.dart';


/// This email is private from decoding JWT from login auth method and should not be shared
@freezed
abstract class UserAuth with _$UserAuth {
  const factory UserAuth({
    required String userName,
    required String userId,
    required  String userToken,
    required String email,
    required String accountLevel,
    required bool purchaseEver,
      }) = _UserAuth;

  factory UserAuth.fromJson(Map<String, dynamic> json) => _$UserAuthFromJson(json);


}