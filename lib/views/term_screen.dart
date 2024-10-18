import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:which/models/terms.dart';
import 'package:which/models/user_data.dart';
import 'package:which/utils/screen_base.dart';

class TermScreen extends ScreenBase {
  const TermScreen({super.key});

  @override
  String get title => '利用規約';
  static const String absolutePath = '/term';
  static const String relativePath = 'term';

  Future<List<Terms>> _getTerms() async {
    final String data = await rootBundle.loadString('assets/terms/term.json');
    final Map<String, dynamic> jsonData =
        jsonDecode(data) as Map<String, dynamic>;
    final List<dynamic> jsonList = jsonData['contents'] as List<dynamic>;
    return jsonList
        .map<Terms>((v) => Terms.fromJson(v as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget userBuild(BuildContext context, WidgetRef ref, UserData myData) {
    final future = useMemoized(
      () => showFutureLoading<List<Terms>>(
        context,
        _getTerms(),
        errorValue: List<Terms>.empty(growable: true),
        errorMsg: '利用規約の取得に失敗しました.',
      ),
    );
    final AsyncSnapshot<List<Terms>> asyncSnapshot = useFuture(future);

    final List<Terms> terms = asyncSnapshot.data ?? [];
    return textTemp(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: terms.length,
          itemBuilder: (context, index) {
            final Terms term = terms[index];
            return Padding(
              padding: EdgeInsets.only(
                top: term.type == 'content' ? 5 : 30,
                bottom: term.type == 'content' ? 5 : 10,
                left: 10 * term.indent.toDouble(),
              ),
              child: Text(
                term.text,
                textAlign: (term.type == 'signature')
                    ? TextAlign.right
                    : (term.type == 'title')
                        ? TextAlign.center
                        : TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: term.type == 'title' ? 20 : 14,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
