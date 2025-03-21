import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/services/contact_service.dart';
import 'package:which/utils/screen_base.dart';

class ContactScreen extends ScreenBase {
  const ContactScreen({super.key});

  @override
  String get title => 'お問い合わせ';
  static const String absolutePath = '/contact';
  static const String relativePath = 'contact';

  Future<void> _addContact({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required ValueNotifier<int> subjectValue,
    required TextEditingController contentController,
    required ValueNotifier<String> asyncMsg,
  }) async {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    await ContactService().set(
      uid: uid,
      name: nameController.text,
      email: emailController.text,
      subject: subjectValue.value,
      content: contentController.text,
    );
    nameController.clear();
    emailController.clear();
    contentController.clear();
    subjectValue.value = 0;
    asyncMsg.value = 'お問い合わせを受け付けました。';
  }

  @override
  Widget baseBuild(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> loading,
    ValueNotifier<String> asyncPath,
    ValueNotifier<String> asyncMsg,
  ) {
    final GlobalKey<FormState> formKey = useState(GlobalKey<FormState>()).value;
    final TextEditingController nameController = useTextEditingController();
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController contentController = useTextEditingController();
    final ValueNotifier<int> subjectValue = useState(0);
    return textTemp(
      context: context,
      loading: loading.value,
      builder: (BuildContext context, BoxConstraints constraints) {
        return Form(
          key: formKey,
          child: Column(
            children: [
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
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
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
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text('メールアドレス'),
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                cursorHeight: 18,
                cursorColor: Colors.grey.shade800,
                style: const TextStyle(fontSize: 15, height: 1.5),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(),
                  hintText: 'メールアドレス',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
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
                    return 'メールアドレスを入力してください。';
                  } else if (!RegExp(
                          r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$')
                      .hasMatch(value)) {
                    return '形式が正しくありません。';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text('件名'),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: constraints.maxWidth * 0.8 < 420 ? 1 : 2,
                childAspectRatio: constraints.maxWidth * 0.8 < 420
                    ? min(680, constraints.maxWidth * 0.8) / 40
                    : min(680, constraints.maxWidth * 0.8) / 80,
                children: [
                  RadioListTile(
                    value: 0,
                    groupValue: subjectValue.value,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: const Text(
                      'ご意見',
                      style: TextStyle(fontSize: 16),
                    ),
                    fillColor: const WidgetStatePropertyAll(Colors.grey),
                    onChanged: (_) => subjectValue.value = 0,
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: subjectValue.value,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: const Text(
                      '不具合報告',
                      style: TextStyle(fontSize: 16),
                    ),
                    fillColor: const WidgetStatePropertyAll(Colors.grey),
                    onChanged: (_) => subjectValue.value = 1,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: subjectValue.value,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: const Text(
                      'アカウント削除申請',
                      style: TextStyle(fontSize: 16),
                    ),
                    fillColor: const WidgetStatePropertyAll(Colors.grey),
                    onChanged: (_) => subjectValue.value = 2,
                  ),
                  RadioListTile(
                    value: 3,
                    groupValue: subjectValue.value,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: const Text(
                      'その他',
                      style: TextStyle(fontSize: 16),
                    ),
                    fillColor: const WidgetStatePropertyAll(Colors.grey),
                    onChanged: (_) => subjectValue.value = 3,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Text('お問い合わせ内容'),
              ),
              const SizedBox(height: 5),
              TextFormField(
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                controller: contentController,
                cursorHeight: 18,
                cursorColor: Colors.grey.shade800,
                style: const TextStyle(fontSize: 15, height: 1.5),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(5),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  hintText: 'お問い合わせ内容',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                  errorBorder: OutlineInputBorder(),
                  focusedErrorBorder: OutlineInputBorder(),
                ),
                validator: (value) {
                  value = value?.trim();
                  if (value == null || value.isEmpty) {
                    return 'お問い合わせ内容を入力してください。';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      showFutureLoading(
                        loading,
                        asyncMsg,
                        _addContact(
                          nameController: nameController,
                          emailController: emailController,
                          subjectValue: subjectValue,
                          contentController: contentController,
                          asyncMsg: asyncMsg,
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
                  child: const Text('送信'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
