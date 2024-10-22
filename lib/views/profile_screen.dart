import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/firestore_service.dart';
import 'package:which/services/storage_service.dart';
import 'package:which/utils/screen_base.dart';

class ProfileScreen extends ScreenBase {
  const ProfileScreen({super.key});

  @override
  String get title => 'プロフィール';
  @override
  bool? get allowAnonymous => false;
  static const String absolutePath = '/profile';
  static const String relativePath = 'profile';

  bool screenValidate(UserData myData) =>
      myData.name.isEmpty && myData.image.isEmpty;

  bool disabled(ValueNotifier<Uint8List?> imageData, bool sameName) =>
      imageData.value == null && sameName;

  Future<void> save({
    required ValueNotifier<String> asyncPath,
    required ValueNotifier<String> asyncMsg,
    required UserData myData,
    required TextEditingController nameController,
    required ValueNotifier<Uint8List?> imageData,
  }) async {
    final StorageService storageService = StorageService();
    final FirestoreService firestoreService = FirestoreService();
    final String? name = nameController.text.trim() == myData.name
        ? null
        : nameController.text.trim();
    final Uint8List? image = imageData.value;
    final String? imageUrl = image == null
        ? null
        : await storageService.putIcon(myData.authId, image);
    await firestoreService.updateProfile(myData, name, imageUrl);
    imageData.value = null;
    asyncMsg.value = 'プロフィールを更新しました。';
  }

  Future<void> _pickImage({
    required BuildContext context,
    required ValueNotifier<Uint8List?> imageData,
  }) async {
    final XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 600,
      maxWidth: 600,
    );
    if (pickedImage == null || context.mounted == false) return;
    final CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      maxHeight: 160,
      maxWidth: 160,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '画像を編集',
          hideBottomControls: true,
          cropStyle: CropStyle.circle,
        ),
        IOSUiSettings(
          cropStyle: CropStyle.circle,
        ),
        WebUiSettings(
          context: context,
          viewwMode: WebViewMode.mode_1,
          presentStyle: WebPresentStyle.page,
          translations: const WebTranslations(
            title: '画像を編集',
            rotateLeftTooltip: '左に回転',
            rotateRightTooltip: '右に回転',
            cancelButton: 'キャンセル',
            cropButton: '切り取り',
          ),
        ),
      ],
    );
    if (croppedImage == null) return;
    final Uint8List imageBytes = await croppedImage.readAsBytes();
    imageData.value = imageBytes;
  }

  @override
  Widget userBuild(
    BuildContext context,
    WidgetRef ref,
    UserData myData,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  ) {
    final GlobalKey<FormState> formKey = useState(GlobalKey<FormState>()).value;
    final TextEditingController nameController =
        useTextEditingController(text: myData.name);
    final ValueNotifier<Uint8List?> imageData = useState(null);
    final bool sameName =
        useValueListenable(nameController).text == myData.name;

    if (screenValidate(myData)) return dispTemp(msg: '不正な画面遷移です。');

    return textTemp(
      loading: loading.value,
      builder: (BuildContext context, BoxConstraints constraints) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: IconButton(
                  onPressed: () => showFutureLoading(
                    loading,
                    asyncMsg,
                    _pickImage(context: context, imageData: imageData),
                    message: '画像の取得に失敗しました。',
                  ),
                  icon: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    foregroundImage: imageData.value == null
                        ? myData.image.isEmpty
                            ? const AssetImage('assets/system/person.png')
                            : NetworkImage(myData.image)
                        : MemoryImage(imageData.value!),
                  ),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    backgroundColor: Colors.black12,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text('名前'),
              ),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                cursorHeight: 18,
                cursorColor: Colors.grey.shade800,
                style: const TextStyle(fontSize: 15, height: 1.5),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  hintText: '名前',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                  errorBorder: UnderlineInputBorder(),
                  focusedErrorBorder: UnderlineInputBorder(),
                ),
                validator: (value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return '名前を入力してください。';
                  } else if (value.length > 20) {
                    return '名前は20文字以内で入力してください。';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: disabled(imageData, sameName)
                      ? null
                      : () {
                          if (formKey.currentState?.validate() ?? false) {
                            showFutureLoading(
                              loading,
                              asyncMsg,
                              save(
                                asyncPath: asyncPath,
                                asyncMsg: asyncMsg,
                                myData: myData,
                                nameController: nameController,
                                imageData: imageData,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('完了'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
