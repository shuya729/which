import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:which/models/user_data.dart';
import 'package:which/providers/my_data_provider.dart';
import 'package:which/utils/screen_base.dart';

class ProfileScreen extends ScreenBase {
  const ProfileScreen({super.key});

  @override
  String get title => 'プロフィール';

  Future<void> _pickImage(
      ValueNotifier<Uint8List?> imageData, BuildContext context) async {
    try {
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserData myData = ref.watch(myDataProvider);

    final GlobalKey<FormState> formKey = useState(GlobalKey<FormState>()).value;
    final ValueNotifier<String> name = useState(myData.name);
    final TextEditingController nameController =
        useTextEditingController(text: myData.name);
    final ValueNotifier<Uint8List?> imageData = useState(null);

    return textTemp(
      childBuilder: (constraints) {
        return Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: IconButton(
                  onPressed: () => _pickImage(imageData, context),
                  icon: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    foregroundImage: imageData.value == null
                        ? myData.image.isEmpty
                            ? null
                            : NetworkImage(myData.image)
                        : MemoryImage(imageData.value!),
                  ),
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(4),
                    backgroundColor: Colors.black.withOpacity(0.3),
                    foregroundColor: Colors.black.withOpacity(1),
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
                cursorHeight: 20,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  hintText: '名前',
                  errorBorder: UnderlineInputBorder(),
                  focusedErrorBorder: UnderlineInputBorder(),
                ),
                onChanged: (value) => name.value = value,
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
                  onPressed:
                      imageData.value == null && name.value == myData.name
                          ? null
                          : () {
                              if (formKey.currentState?.validate() ?? false) {}
                            },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black.withOpacity(0.8),
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
