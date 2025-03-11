import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/user_info_service.dart';
import 'package:which/services/user_service.dart';

final StreamProvider<User?> _asyncUserProvider = StreamProvider<User?>(
  (_) => FirebaseAuth.instance.userChanges(),
);

final StreamProvider<UserData> userStreamProvider = StreamProvider<UserData>(
  (ref) async* {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final AsyncValue<User?> asyncUser = ref.watch(_asyncUserProvider);
    print('user: ${asyncUser.value?.uid}');
    if (asyncUser.hasError) {
      await auth.signOut();
      // throw asyncUser.error!;
    } else if (asyncUser.hasValue) {
      final User? user = asyncUser.value;
      if (user == null) {
        await auth.signInAnonymously();
      } else {
        final DocumentReference userRef = UserService.doc(user.uid);
        final UserService userService = UserService();
        final UserInfoService userInfoService = UserInfoService();
        final Stream<DocumentSnapshot> stream = userRef.snapshots();
        await for (final DocumentSnapshot snapshot in stream) {
          if (!snapshot.exists || snapshot.data() is! Map<String, dynamic>) {
            await userService.set(
              authId: user.uid,
              isAnonymous: user.isAnonymous,
            );
          } else {
            final Map<String, dynamic> data =
                snapshot.data() as Map<String, dynamic>;
            final UserData myData = UserData.fromFirestore(data);
            if (user.isAnonymous != myData.anonymousFlg) {
              await userService.update(
                myData,
                anonymousFlg: user.isAnonymous,
              );
            } else {
              await userInfoService.login(userData: myData);
              yield myData;
            }
          }
        }
      }
    }
  },
);
