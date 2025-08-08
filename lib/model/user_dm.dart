import 'package:evently/model/event_dm.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDM {
  static const String collectionName = "users";
  static UserDM? currentUser;

  late String id;
  late String name;
  late String email;
  late List<String> favoriteEvents;

  UserDM({
    required this.id,
    required this.name,
    required this.email,
    required this.favoriteEvents,
  });

  UserDM.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';

    List<dynamic> favList = json['favoriteEvents'] ?? [];
    favoriteEvents = favList.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "favoriteEvents": favoriteEvents,
    };
  }
}
