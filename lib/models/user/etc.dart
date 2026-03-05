import 'package:json_annotation/json_annotation.dart';


@JsonEnum()
enum UserType{
  vendor,
  client,
  guest
}