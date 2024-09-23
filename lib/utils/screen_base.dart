import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class ScreenBase extends HookConsumerWidget {
  const ScreenBase({super.key});

  @protected
  String get title;

  Widget textTemp({
    required Widget Function(BoxConstraints constraints) childBuilder,
  }) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 19),
        title: Text(title),
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: constraints.maxWidth * 0.8,
                    constraints: const BoxConstraints(maxWidth: 600),
                    margin: EdgeInsets.only(
                      top: constraints.maxHeight * 0.07,
                      bottom: constraints.maxHeight * 0.07 + 20,
                    ),
                    child: childBuilder(constraints),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listTemp({
    required int itemCount,
    required Widget Function(BoxConstraints constraints, int index)
        childrenBuilder,
  }) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 19),
        title: Text(title),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: Container(
                  width: constraints.maxWidth * 0.94,
                  constraints: const BoxConstraints(maxWidth: 800),
                  margin: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.03,
                  ),
                  alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 40),
                    itemCount: itemCount,
                    itemBuilder: (context, index) {
                      return childrenBuilder(constraints, index);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget dispTemp({required String msg}) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 19),
        title: Text(title),
      ),
      body: SafeArea(
        child: Center(
          child: Text(msg),
        ),
      ),
    );
  }

  Widget loadingTemp() {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(size: 19),
        title: Text(title),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              color: Colors.black.withOpacity(0.5),
              strokeWidth: 2.5,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      ),
    );
  }
}
