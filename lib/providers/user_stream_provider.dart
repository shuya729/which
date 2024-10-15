import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/firestore_service.dart';

final StreamProvider<User?> _asyncUserProvider = StreamProvider<User?>(
  (_) => FirebaseAuth.instance.userChanges().handleError((e) => throw e),
);

final StreamProvider<UserData> userStreamProvider = StreamProvider<UserData>(
  (ref) async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final AsyncValue<User?> asyncUser = ref.watch(_asyncUserProvider);
    if (asyncUser.hasError) {
      throw asyncUser.error!;
    } else if (asyncUser.hasValue) {
      final User? user = asyncUser.value;
      if (user == null) {
        await auth.signInAnonymously();
      } else {
        final FirestoreService firestoreService = FirestoreService();
        final DocumentReference userRef = firestoreService.userRef(user.uid);
        final Stream<DocumentSnapshot> stream =
            userRef.snapshots().handleError((e) => throw e);
        await for (final DocumentSnapshot snapshot in stream) {
          if (!snapshot.exists || snapshot.data() is! Map<String, dynamic>) {
            await firestoreService.setUser(
              UserData.init(authId: user.uid, isAnonymous: user.isAnonymous),
            );
          } else {
            final Map<String, dynamic> data =
                snapshot.data() as Map<String, dynamic>;
            final UserData myData = UserData.fromFirestore(data);
            if (user.isAnonymous != myData.anonymousFlg) {
              await firestoreService.updateUser(
                myData.copyWith(anonymousFlg: user.isAnonymous),
              );
            } else {
              yield myData;
            }
          }
        }
      }
    }
  },
);
