import 'dart:async';

import 'package:flutter/material.dart';

const durationSeconds = 5;
const transitionDuration = Duration(milliseconds: 250);

class PopupDialog {
  final Widget child;

  PopupDialog({
    required this.child,
  });

  Future<bool> _onWillPop(Timer timer) async {
    timer.cancel();

    return true;
  }

  Future<void> showToast(BuildContext context) {
    // AutoClose modal after 5 sec.
    final timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (timer.tick == durationSeconds) {
          timer.cancel();
          Navigator.of(context).pop();
        }
      },
    );

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: transitionDuration,
      barrierLabel: '',
      pageBuilder: (ctx, a1, a2) {
        return child;
      },
      transitionBuilder: (ctx, a1, a2, child) {
        return WillPopScope(
          onWillPop: () => _onWillPop(timer),
          child: Transform.scale(
            scale: Curves.easeIn.transform(a1.value),
            child: Dialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
