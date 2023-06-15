import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:flutter/material.dart';

import '../web_ui/styles/textstyles.dart';

class ShowConfirmationDialog {
  final BuildContext context;
  final String title;
  final String body;
  final String fBtnName;
  final String sBtnName;

  ShowConfirmationDialog({
    required this.context,
    required this.title,
    required this.body,
    required this.fBtnName,
    required this.sBtnName,
  });

  Future<bool?> showConfirmationDialog() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  style: ForRedButton,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    sBtnName.toUpperCase(),
                    style: alertDialogBtn,
                  )),
              const SizedBox(
                width: 12,
              ),
              ElevatedButton(
                  style: ForTealButton,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    fBtnName.toUpperCase(),
                    style: alertDialogBtn,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
