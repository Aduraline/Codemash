import 'dart:io';
import 'package:facemash_clone/main.dart';
import 'package:facemash_clone/models/profile.dart';
import 'package:facemash_clone/util/constant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'api_status.dart';

class ProfileService {
  static Future<Object> getProfiles() async {
    try {
      var event = await profileRef.once();

      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? response = snapshot.value as Map?;

      if (response != null) {
        return Success(response: profileListModelFromMap(response), code: 200);
      }

      return Failure(errorResponse: "Null Response", code: INVALID_RESPONSE);
    } catch (err) {
      return Failure(errorResponse: "Unknown Error", code: UNKNOWN_ERROR);
    }
  }
}
