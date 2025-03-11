import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userReroadProvider = FutureProvider<void>((_) async {
  try {
    await FirebaseAuth.instance.currentUser?.reload();
  } catch (e) {
    await FirebaseAuth.instance.signOut();
    rethrow;
  }
});
