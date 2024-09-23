import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/user_data.dart';

final myDataProvider = Provider<UserData>((_) {
  return UserData(
    userId: 'uid',
    authId: 'uid',
    name: 'name',
    image: 'https://picsum.photos/200/300',
    anonymousFlg: false,
    deletedFlg: false,
    rejectedFlg: false,
    creAt: DateTime.now(),
    updAt: DateTime.now(),
  );
});
