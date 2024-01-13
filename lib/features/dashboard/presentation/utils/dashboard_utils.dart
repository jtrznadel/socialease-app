import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_ease_app/core/services/injection_container.dart';
import 'package:social_ease_app/features/activity/data/models/activity_model.dart';
import 'package:social_ease_app/features/activity/data/models/comment_model.dart';
import 'package:social_ease_app/features/auth/data/models/user_model.dart';

class DashboardUtils {
  const DashboardUtils._();

  static Stream<LocalUserModel> get userDataStream => sl<FirebaseFirestore>()
      .collection('users')
      .doc(sl<FirebaseAuth>().currentUser!.uid)
      .snapshots()
      .map((event) => LocalUserModel.fromMap(event.data()!));

  static Stream<List<ActivityModel>> get activitiesStream =>
      sl<FirebaseFirestore>()
          .collection('activities')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return ActivityModel.fromMap(doc.data());
        }).toList();
      });

  static Stream<List<CommentModel>> commentsStream(String activityId) =>
      sl<FirebaseFirestore>()
          .collection('activities')
          .doc(activityId)
          .collection('comments')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return CommentModel.fromMap(doc.data());
        }).toList();
      });
}
