import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/color_set.dart';
import 'package:which/models/question.dart';
import 'package:which/models/user_data.dart';
import 'package:which/services/firestore_service.dart';
import 'package:which/utils/screen_base.dart';

class CreateScreen extends ScreenBase {
  const CreateScreen({super.key});

  @override
  String get title => '質問を作成';
  static const String absolutePath = '/create';
  static const String relativePath = 'create';

  Future<Question?> _post({
    required BuildContext context,
    required UserData myData,
    required GlobalKey<FormState> formKey,
    required TextEditingController questController,
    required TextEditingController answer1Controller,
    required TextEditingController answer2Controller,
  }) async {
    final questValue = questController.text.trim();
    final answer1Vlaue = answer1Controller.text.trim();
    final answer2Value = answer2Controller.text.trim();
    Question question = Question.crate(
      authId: myData.authId,
      quest: questValue,
      answer1: answer1Vlaue,
      answer2: answer2Value,
    );
    await FirestoreService().addQuestion(question);
    return question;
  }

  @override
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    final formKey = useState(GlobalKey<FormState>()).value;
    final questController = useTextEditingController();
    final answer1Controller = useTextEditingController();
    final answer2Controller = useTextEditingController();
    final colorSet = useState(ColorSet.set());
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 18),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  await showFutureLoading(
                    context,
                    _post(
                      context: context,
                      myData: myData,
                      formKey: formKey,
                      questController: questController,
                      answer1Controller: answer1Controller,
                      answer2Controller: answer2Controller,
                    ),
                    errorValue: null,
                    afterDialog: (context, ret) {
                      if (ret != null && context.mounted) context.pop();
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.compact,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black87,
                minimumSize: const Size(69, 43),
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              child: const Text('投稿'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: Container(
                  width: constraints.maxWidth * 0.94,
                  constraints: const BoxConstraints(maxWidth: 800),
                  margin: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.03,
                  ),
                  alignment: Alignment.center,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(height: max(5, constraints.maxHeight * 0.01)),
                        TextFormField(
                          controller: questController,
                          autofocus: true,
                          maxLength: 80,
                          minLines: constraints.maxWidth > 500 ? 3 : 4,
                          maxLines: 6,
                          keyboardType: TextInputType.multiline,
                          // cursorHeight: 16,
                          cursorHeight: 18,
                          cursorColor: Colors.grey.shade800,
                          // style: const TextStyle(fontSize: 14, height: 1.4),
                          style: TextStyle(fontSize: 15, height: 1.5),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: '質問',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                            contentPadding: EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                            errorBorder: OutlineInputBorder(),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2),
                            ),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(80),
                            FilteringTextInputFormatter.deny(RegExp(r'\n')),
                          ],
                          validator: (value) {
                            value = value?.trim();
                            if (value == null || value.isEmpty) {
                              return '質問を入力してください。';
                            } else if (value.length > 80) {
                              return '質問は80文字以内で入力してください。';
                            } else if (value.contains('\n')) {
                              return '改行は入力できません。';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: max(20, constraints.maxHeight * 0.04)),
                        TextFormField(
                          controller: answer1Controller,
                          maxLength: 60,
                          minLines: 2,
                          maxLines: 6,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 18,
                          cursorColor: Colors.grey.shade800,
                          style: TextStyle(fontSize: 15, height: 1.5),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.all(8),
                            hintText: '選択肢1',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: colorSet.value.rightColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorSet.value.rightColor,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: colorSet.value.rightColor),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorSet.value.rightColor,
                                width: 2,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60),
                            FilteringTextInputFormatter.deny(RegExp(r'\n')),
                          ],
                          validator: (value) {
                            value = value?.trim();
                            if (value == null || value.isEmpty) {
                              return '選択肢1を入力してください。';
                            } else if (value.length > 60) {
                              return '60文字以内で入力してください。';
                            } else if (value.contains('\n')) {
                              return '改行は入力できません。';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: max(10, constraints.maxHeight * 0.02)),
                        TextFormField(
                          controller: answer2Controller,
                          maxLength: 60,
                          minLines: 2,
                          maxLines: 6,
                          keyboardType: TextInputType.multiline,
                          cursorHeight: 18,
                          cursorColor: Colors.grey.shade800,
                          style: TextStyle(fontSize: 15, height: 1.5),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: '選択肢2',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 15,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                            contentPadding: const EdgeInsets.all(8),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: colorSet.value.leftColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorSet.value.leftColor,
                                width: 2,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: colorSet.value.leftColor),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: colorSet.value.leftColor,
                                width: 2,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(60),
                            FilteringTextInputFormatter.deny(RegExp(r'\n')),
                          ],
                          validator: (value) {
                            value = value?.trim();
                            if (value == null || value.isEmpty) {
                              return '選択肢2を入力してください。';
                            } else if (value.length > 60) {
                              return '60文字以内で入力してください。';
                            } else if (value.contains('\n')) {
                              return '改行は入力できません。';
                            } else if (value == answer1Controller.text) {
                              return '選択肢1と同じ内容は入力できません。';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: max(40, constraints.maxHeight * 0.08)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
