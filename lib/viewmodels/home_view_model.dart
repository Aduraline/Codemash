import 'package:facemash_clone/main.dart';
import 'package:facemash_clone/models/error_response.dart';
import 'package:facemash_clone/models/profile.dart';
import 'package:facemash_clone/repository/api_status.dart';
import 'package:facemash_clone/repository/profile_service.dart';
import 'package:flutter/cupertino.dart';

class HomeViewModel extends ChangeNotifier {
  bool _loading = false;
  List<Profile> _profileListModel = [];
  ErrorResponse? _profileError;

  bool get loading => _loading;
  List<Profile> get profileListModel => _profileListModel;
  ErrorResponse? get profileError => _profileError;

  HomeViewModel() {
    getProfiles();
  }

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setProfileList(List<Profile> walletListModel) async {
    _profileListModel = walletListModel;
  }

  setProfileError(ErrorResponse walletError) {
    _profileError = walletError;
  }

  updateProfileRating(String keyA, int indexA, int ratingA, String keyB,
      int indexB, int ratingB) async {
    await profileRef.child(keyA).update({"rUser": ratingA});
    _profileListModel[indexA].rUser = ratingA;
    await profileRef.child(keyB).update({"rUser": ratingB});
    _profileListModel[indexB].rUser = ratingB;
  }

  getProfiles() async {
    setLoading(true);
    var response = await ProfileService.getProfiles();
    if (response is Success) {
      setProfileList(response.response as List<Profile>);
    }
    if (response is Failure) {
      ErrorResponse profileError =
          ErrorResponse(code: response.code, message: response.errorResponse);
      setProfileError(profileError);
    }
    setLoading(false);
  }
}
