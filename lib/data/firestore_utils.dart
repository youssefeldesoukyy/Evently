import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/model/event_dm.dart';
import 'package:evently/model/user_dm.dart';
import 'package:firebase_core/firebase_core.dart';

// Add a user to Firestore
Future<void> addUserToFirestore(UserDM user) async {
  var userCollection =
  FirebaseFirestore.instance.collection(UserDM.collectionName);
  var userDoc = userCollection.doc(user.id);
  await userDoc.set(user.toJson());
}

// Get a user from Firestore
Future<UserDM?> getFromUserFirestore(String userId) async {
  var userDoc = FirebaseFirestore.instance
      .collection(UserDM.collectionName)
      .doc(userId);
  var snapshot = await userDoc.get();

  if (!snapshot.exists || snapshot.data() == null) return null;

  Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
  return UserDM.fromJson(json);
}

// Add an event to Firestore
Future<void> addEventToFirestore(EventDM event) async {
  var eventsCollection =
  FirebaseFirestore.instance.collection(EventDM.collectionName);
  var newDoc = eventsCollection.doc();
  event.id = newDoc.id;
  await newDoc.set(event.toJson());
}

// Stream all events from Firestore
Stream<List<EventDM>> getAllEventsFromFirestore() {
  var eventsCollection =
  FirebaseFirestore.instance.collection(EventDM.collectionName);
  return eventsCollection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return EventDM.fromJson(doc.data());
    }).toList();
  });
}

// Get favorite events of the current user
Future<List<EventDM>> getFavoriteEvents() async {
  final currentUser = UserDM.currentUser;

  if (currentUser == null || currentUser.favoriteEvents.isEmpty) {
    return [];
  }

  var eventsCollection =
  FirebaseFirestore.instance.collection(EventDM.collectionName);

  var querySnapshot = await eventsCollection
      .where("id", whereIn: currentUser.favoriteEvents)
      .get();

  return querySnapshot.docs.map((doc) {
    return EventDM.fromJson(doc.data());
  }).toList();
}

// Add an event to the user's favorite list
Future<void> addEventToFavorite(String eventId) async {
  final currentUser = UserDM.currentUser;

  if (currentUser == null) return;

  var userDoc = FirebaseFirestore.instance
      .collection(UserDM.collectionName)
      .doc(currentUser.id);

  await userDoc.update({
    "favoriteEvents": FieldValue.arrayUnion([eventId])
  });

  if (!currentUser.favoriteEvents.contains(eventId)) {
    currentUser.favoriteEvents.add(eventId);
  }
}

// Remove an event from the user's favorite list
Future<void> removeEventFromFavorite(String eventId) async {
  final currentUser = UserDM.currentUser;
  if (currentUser == null) return;

  final userDoc = FirebaseFirestore.instance
      .collection(UserDM.collectionName)
      .doc(currentUser.id);

  await userDoc.update({
    "favoriteEvents": FieldValue.arrayRemove([eventId])
  });

  currentUser.favoriteEvents.remove(eventId);
}

final eventsCol =
FirebaseFirestore.instance.collection(EventDM.collectionName);

Future<void> updateEventInFirestore(EventDM event) async {
  await eventsCol.doc(event.id).update(event.toJson());
}

Future<void> deleteEventFromFirestore(String eventId) async {
  await eventsCol.doc(eventId).delete();
}