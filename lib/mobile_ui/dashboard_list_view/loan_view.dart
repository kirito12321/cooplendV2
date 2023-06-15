import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/widgets/calendar_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanView extends StatefulWidget {
  const LoanView({super.key});

  @override
  State<LoanView> createState() => _LoanViewState();
}

class _LoanViewState extends State<LoanView> {
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: const BackButton(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          actions: [
            Transform.scale(
              scale: 0.8,
              child: IconButton(
                icon: const Image(
                    image: AssetImage('assets/images/cooplendlogo.png')),
                padding: const EdgeInsets.all(2.0),
                iconSize: screenWidth * 0.3,
                onPressed: () {},
              ),
            )
          ],
        ),
        body: buildLoan(size, arguments));
  }

  Widget buildLoan(Size size, Map<dynamic, dynamic> arguments) {
    double screenHeight = size.height;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.all(screenHeight * 0.02),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: grey4,
                          spreadRadius: 0.2,
                          blurStyle: BlurStyle.normal,
                          blurRadius: 1.6),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'LOAN NO.',
                          style: btnForgotTxtStyle,
                        ),
                      ),
                    ),
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: teal8,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: teal8)),
                        child: Text(
                          (arguments['tenureData'] as DataLoanTenure).loanId,
                          style: const TextStyle(
                              fontFamily: FontNameMed,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: teal8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Payment Method:',
                                  style: btnForgotTxtStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Amount Due:',
                                  style: btnForgotTxtStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'Month Interest:',
                                  style: btnForgotTxtStyle,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        (arguments['tenureData']
                                                as DataLoanTenure)
                                            .payMethod!,
                                        style: h6,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        (arguments['tenureData']
                                                        as DataLoanTenure)
                                                    .payment >
                                                0
                                            ? 'PHP ${NumberFormat('###,###,##0.00').format((arguments['tenureData'] as DataLoanTenure).payment)}'
                                            : 'PHP 0',
                                        style: h6,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'PHP ${NumberFormat('###,###,##0.00').format((arguments['tenureData'] as DataLoanTenure).monthInterest)}',
                                        style: h6,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: teal8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Paid:',
                                style: btnForgotTxtStyle,
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3)),
                              Text(
                                'Total Running Balance:',
                                style: btnForgotTxtStyle,
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  'PHP ${NumberFormat('###,###,##0.00').format((arguments['tenureData'] as DataLoanTenure).paidAmount)}',
                                  style: TextStyle(
                                      fontFamily: FontNamedDef,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.teal[800],
                                      letterSpacing: 1)),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3)),
                              Text(
                                  'PHP ${NumberFormat('###,###,##0.00').format((arguments['tenureData'] as DataLoanTenure).payment)}',
                                  style: TextStyle(
                                      fontFamily: FontNamedDef,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red[800],
                                      letterSpacing: 1)),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: teal8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Status:'.toUpperCase(),
                                  style: btnForgotTxtStyle,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  'Month:'.toUpperCase(),
                                  style: btnForgotTxtStyle,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                (arguments['tenureData'] as DataLoanTenure)
                                            .status !=
                                        'paid'
                                    ? Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 5, 12, 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(color: orange8)),
                                        child: Text(
                                          (arguments['tenureData']
                                                  as DataLoanTenure)
                                              .status
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: FontNamedDef,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.8,
                                              color: Colors.orange[800]),
                                        ))
                                    : Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 5, 12, 5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(color: red8)),
                                        child: Text(
                                          (arguments['tenureData']
                                                  as DataLoanTenure)
                                              .status
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontFamily: FontNamedDef,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.8,
                                              color: Colors.red[800]),
                                        )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 5, 12, 5),
                                    decoration: BoxDecoration(
                                      color: Colors.teal[800],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Month ${(arguments['tenureData'] as DataLoanTenure).month}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontFamily: FontNamedDef,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.8,
                                          color: Colors.white),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        // decoration: BoxDecoration(
                        //     color: teal8,
                        //     borderRadius: BorderRadius.circular(8),
                        //     border: Border.all(color: Colors.transparent)),
                        child: (arguments['tenureData'] as DataLoanTenure)
                                    .payDate !=
                                null
                            ? const Center(
                                child: Text(
                                  'DATE PAID',
                                  style: TextStyle(
                                    fontFamily: FontNamedDef,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Text(
                                  'DUE DATE',
                                  style: TextStyle(
                                    fontFamily: FontNamedDef,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    letterSpacing: 1,
                                  ),
                                ),
                              )),
                    Flexible(
                      fit: FlexFit.tight,
                      child: SizedBox(
                          height: screenHeight * 0.4,
                          child: Theme(
                            data: ThemeData(primarySwatch: Colors.amber),
                            child: CalendarWidget(
                              initialDate: (arguments['tenureData']
                                              as DataLoanTenure)
                                          .payDate !=
                                      null
                                  ? (arguments['tenureData'] as DataLoanTenure)
                                      .payDate!
                                  : (arguments['tenureData'] as DataLoanTenure)
                                      .dueDate,
                            ),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
