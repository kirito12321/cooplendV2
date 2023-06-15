import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';

class ShowAlertDialog {
  final BuildContext context;
  final String title;
  final String body;
  final String btnName;

  ShowAlertDialog(
      {required this.context,
      required this.title,
      required this.body,
      required this.btnName});

  Future<bool?> showAlertDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: alertDialogTtl,
        ),
        content: Text(
          body,
          style: alertDialogContent,
        ),
        actions: [
          ElevatedButton(
              style: ForTealButton,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(btnName.toUpperCase()))
        ],
      ),
    );
  }
}
