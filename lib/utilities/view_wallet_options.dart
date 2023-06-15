import 'package:ascoop/style.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:math_expressions/math_expressions.dart';

class ShowWalletViewOption {
  final BuildContext context;
  final String coopId;
  final String userId;
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,###.00');
  ShowWalletViewOption(
      {required this.context, required this.coopId, required this.userId});

  Future<bool?> showOptionDialog() async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Please select to view ledger',
                style: alertDialogTtl,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 50,
                width: 160,
                child: ElevatedButton(
                    onPressed: () {
                      // '/user/capitalsharehistory/'
                      Navigator.of(context).pushNamed(
                          // '/coop/loanview/',
                          //  '/coop/loantenureview',
                          '/user/capitalsharehistory/',
                          arguments: {'coopId': coopId, 'userId': userId});
                    },
                    style: ForBorderTeal,
                    child: Text(
                      'Capital Share Ledger',
                      style: TextStyle(
                        fontFamily: FontNamedDef,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: teal8,
                      ),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                width: 160,
                child: ElevatedButton(
                    onPressed: () {
                      // '/user/savingshistory/'
                      Navigator.of(context).pushNamed('/user/savingshistory/',
                          arguments: {'coopId': coopId, 'userId': userId});
                    },
                    style: ForBorderOrange,
                    child: Text(
                      'Savings Ledger',
                      style: TextStyle(
                        fontFamily: FontNamedDef,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: orange8,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
