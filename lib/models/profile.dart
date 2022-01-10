List<Profile> profileListModelFromMap(Map<dynamic, dynamic> values) =>
    List<Profile>.from(values.entries
        .map(
            (value) => Profile.fromJson(value)));

class Profile {
  late String id;
  late String imageUrl;
  late int rUser;

  Profile(
      {required this.id,
      required this.imageUrl,
      required this.rUser});

  factory Profile.fromJson(MapEntry json) => Profile(
      id: json.key,
      imageUrl: json.value['imageUrl'],
      rUser: json.value['rUser']);
}
