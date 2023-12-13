import 'package:flutter/material.dart';

class CandyBar {
//region Singleton Pattern
  static late CandyBar _instance;

  static CandyBar get instance {
    _instance = CandyBar._();
    return _instance;
  }

  CandyBar._();

//endregion

  SnackBarAction createAction(String label, VoidCallback onPressed, Color color) {
    return SnackBarAction(
      label: label,
      onPressed: onPressed,
      textColor: color,
    );
  }

  void showBar(
    BuildContext context, {
    GlobalKey<ScaffoldMessengerState>? scaffoldKey,
    required CandyFlavor flavor,
    required String text,
    SnackBarAction? snackBarAction,
  }) {
    double calculatedHeightDelta = scaffoldKey == null ? 362 : context.size!.height / 2;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    SnackBar snack = SnackBar(
      //width: text.length * 18,
      action: snackBarAction,
      behavior: SnackBarBehavior.floating,
      content: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          softWrap: true,
          maxLines: 4,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: flavor.color,
            fontSize: 16,
          ),
        ),
      ),
      showCloseIcon: false,
      //closeIconColor: Theme.of(context).scaffoldBackgroundColor,
      duration: Duration(seconds: flavor.delay),
      elevation: 8.0,
      margin: EdgeInsets.only(left: 30, right: 30, bottom: calculatedHeightDelta),
      dismissDirection: DismissDirection.none,
    );
    if (scaffoldKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        snack,
      );
    } else {
      scaffoldKey.currentState?.showSnackBar(snack);
    }
  }
}

enum CandyFlavor {
  vanilla(null, 3),
  error(Colors.white, 5);

  const CandyFlavor(this.color, this.delay);

  final Color? color;
  final int delay;
}
