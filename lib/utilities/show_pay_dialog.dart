import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/services/database/data_service.dart';

import 'package:flutter/material.dart';

class ShowPayDialog {
  final BuildContext context;
  final DataLoanTenure tenure;
  final TextEditingController _payment = TextEditingController();
  ShowPayDialog({required this.context, required this.tenure});

  Future<bool?> showPaymentDialog() async {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _payment,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                  hintText: '0.00',
                  label: Text('Amount'),
                  border: OutlineInputBorder(),
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(Icons.add_outlined),
                  ),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8)),
            ),
            const SizedBox(
              width: 12,
            ),
            ElevatedButton(
                onPressed: () {
                  double amount = double.parse(_payment.text);
                  try {
                    DataService.database()
                        .payLoan(tenure: tenure, amount: amount)
                        .then((value) => Navigator.of(context).pop(true));
                  } catch (e) {
                    Navigator.of(context).pop(false);
                  }
                },
                child: const Text('Pay')),
          ],
        ),
      ),
    );
  }
}
// class PayDialog extends StatefulWidget {
//   const PayDialog({super.key});

//   @override
//   State<PayDialog> createState() => _PayDialogState();
// }

// class _PayDialogState extends State<PayDialog> {
//   late final TextEditingController _payment;

//   @override
//   void initState() {
//     _payment = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _payment.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final arguments = (ModalRoute.of(context)?.settings.arguments ??
//         <String, dynamic>{}) as Map;

//     DataLoanTenure tenure = arguments['tenure'] as DataLoanTenure;
//     return Dialog(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Center(
//             child: Wrap(
//               alignment: WrapAlignment.center,
//               spacing: 32,
//               children: [
//                 TextFormField(
//                   controller: _payment,
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.right,
//                   decoration: const InputDecoration(
//                       hintText: '0.00',
//                       label: Text('Amount'),
//                       border: OutlineInputBorder(),
//                       prefixIcon: Align(
//                         widthFactor: 1.0,
//                         heightFactor: 1.0,
//                         child: Icon(Icons.add_outlined),
//                       ),
//                       isDense: true,
//                       contentPadding: EdgeInsets.all(8)),
//                 ),
//                 const SizedBox(
//                   width: 12,
//                 ),
//                 ElevatedButton(
//                     onPressed: () {
//                       double amount = double.parse(_payment.text);
//                       try {
//                         DataService.database()
//                             .payLoan(tenure: tenure, amount: amount)
//                             .then((value) => Navigator.of(context).pop(true));
//                       } catch (e) {
//                         Navigator.of(context).pop(false);
//                       }
//                     },
//                     child: const Text('Pay')),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
