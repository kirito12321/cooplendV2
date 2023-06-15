import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'An error occured',
            style: alertDialogTtl,
          ),
          content: Text(
            text,
            style: alertDialogContent,
          ),
          actions: [
            ElevatedButton(
                style: ForTealButton,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'OK',
                  style: alertDialogBtn,
                ))
          ],
        );
      });
}
