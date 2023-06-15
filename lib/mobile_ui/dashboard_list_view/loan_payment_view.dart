import 'dart:developer';

import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_loan_tenure.dart';
import 'package:ascoop/services/database/data_loan_types.dart';
import 'package:ascoop/services/database/data_service.dart';
// import 'package:ascoop/services/payment/baseclient.dart';
// import 'package:ascoop/services/payment/payment_datamodel.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_pay_dialog.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../services/database/data_loan_payment_data.dart';
import '../../web_ui/styles/buttonstyle.dart';

class LoanTenureView extends StatefulWidget {
  const LoanTenureView({super.key});

  @override
  State<LoanTenureView> createState() => _LoanTenureViewState();
}

class _LoanTenureViewState extends State<LoanTenureView> {
  int activeIndex = 0;
  // bool isOnlinePay = false;
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,##0.00');

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    Size size = MediaQuery.of(context).size;
    // checkCoopPayService(arguments['coopId']);
    double screenWidth = size.width;

    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            'Loan Details',
            style: dashboardMemberTextStyle,
          ),
          backgroundColor: Colors.white,
          actions: [
            Transform.scale(
              scale: 0.8,
              child: IconButton(
                icon: const Image(
                    image: AssetImage('assets/images/cooplendlogo.png')),
                padding: const EdgeInsets.all(2.0),
                iconSize: screenWidth * 0.4,
                onPressed: () {},
              ),
            )
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10),
          child: StreamBuilder<DataLoanTenure?>(
            stream: DataService.database().readLoanTenure(
                loanId: (arguments['loanInfo'] as DataLoan).loanId,
                coopId: (arguments['loanInfo'] as DataLoan).coopId,
                userId: (arguments['loanInfo'] as DataLoan).userId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final loanTenure = snapshot.data!;

                return buildLoan(loanTenure, size, arguments);

                // return loanTenure == null
                //     ? const Text('No Data')
                //     : buildLoan(loanTenure, size, arguments);
              } else if (snapshot.hasError) {
                // return Center(
                //     child: Text('error reading loan details${snapshot.error}'));
                final loanTenure = DataLoanTenure(
                    loanId: (arguments['loanInfo'] as DataLoan).loanId,
                    coopId: (arguments['loanInfo'] as DataLoan).coopId,
                    userId: (arguments['loanInfo'] as DataLoan).userId,
                    status: 'completed',
                    amountPayable: 0,
                    monthInterest: 0,
                    payment: 0,
                    dueDate: DateTime.now(),
                    month: 0);
                return buildLoan(loanTenure, size, arguments);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
  }

  Widget buildLoan(
      DataLoanTenure loanTenure, Size size, Map<dynamic, dynamic> arguments) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 250,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 122, 122, 122),
                    spreadRadius: 0,
                    blurStyle: BlurStyle.normal,
                    blurRadius: 2.6)
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.teal[800],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'LOAN NO. ${loanTenure.loanId}',
                      style: const TextStyle(
                        fontFamily: FontNamedDef,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  children: [
                    Column(
                      children: [
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        SizedBox(
                          child: Column(
                            children: [
                              Text(
                                'NEXT PAYMENT DUE',
                                style: TextStyle(
                                  fontFamily: FontNamedDef,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: grey4,
                                ),
                              ),
                              loanTenure.status == 'pending'
                                  ? Text(
                                      'PHP ${NumberFormat('###,###,###,##0.00').format(loanTenure.payment)}',
                                      style: const TextStyle(
                                        fontFamily: FontNamedDef,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        letterSpacing: 1,
                                      ),
                                    )
                                  : Text(
                                      loanTenure.status,
                                      style: const TextStyle(
                                        fontFamily: FontNamedDef,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        SizedBox(
                          child: Column(
                            children: [
                              Text(
                                'DUE DATE',
                                style: TextStyle(
                                  fontFamily: FontNamedDef,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w400,
                                  color: grey4,
                                ),
                              ),
                              loanTenure.status == 'pending'
                                  ? Text(
                                      DateFormat('MMM d, yyyy')
                                          .format(loanTenure.dueDate)
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: FontNamedDef,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        letterSpacing: 1,
                                      ),
                                    )
                                  : Text(
                                      loanTenure.status,
                                      style: const TextStyle(
                                        fontFamily: FontNamedDef,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        letterSpacing: 1,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: SizedBox(
                              height: 50,
                              width: 160,
                              child: loanTenure.status == 'pending'
                                  ? FutureBuilder<DataLoanPaymentData>(
                                      future: DataService.database()
                                          .checkLoanPayment(tenure: loanTenure)
                                          .first,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final paymentData = snapshot.data!;

                                          return ElevatedButton(
                                            style: ForTealButton1,
                                            onPressed: () {
                                              if (arguments['isOnlinePay'] &&
                                                  paymentData.payStatus !=
                                                      'processing') {
                                                ShowPayDialog(
                                                        context: context,
                                                        loanData: arguments[
                                                                'loanInfo']
                                                            as DataLoan,
                                                        tenure: loanTenure)
                                                    .showPaymentDialog()
                                                    .then((value) {
                                                  if (value == true) {
                                                    ShowAlertDialog(
                                                            context: context,
                                                            title:
                                                                'Payment Successful',
                                                            body:
                                                                'Your payment is now processing',
                                                            btnName: 'Close')
                                                        .showAlertDialog();
                                                  }
                                                });
                                              } else if (paymentData
                                                      .payStatus ==
                                                  'processing') {
                                                ShowAlertDialog(
                                                        context: context,
                                                        title: 'STATUS',
                                                        body:
                                                            'Your payment is currently on process.',
                                                        btnName: 'Close')
                                                    .showAlertDialog();
                                              } else {
                                                ShowAlertDialog(
                                                        context: context,
                                                        title: 'Ops, Sorry',
                                                        body:
                                                            'Your coop currently not accepting online payment.',
                                                        btnName: 'Close')
                                                    .showAlertDialog();
                                              }
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Feather.dollar_sign,
                                                  size: 18,
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2)),
                                                Text(
                                                  'PAY',
                                                  style: btnLoginTxtStyle,
                                                ),
                                              ],
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        content: onWait),
                                              );
                                              print(arguments['isOnlinePay']);
                                              if (arguments['isOnlinePay']) {
                                                ShowPayDialog(
                                                        context: context,
                                                        loanData: arguments[
                                                                'loanInfo']
                                                            as DataLoan,
                                                        tenure: loanTenure)
                                                    .showPaymentDialog()
                                                    .then((value) {
                                                  if (value == true) {
                                                    ShowAlertDialog(
                                                            context: context,
                                                            title:
                                                                'Payment Successful',
                                                            body:
                                                                'Your payment is now processing',
                                                            btnName: 'Close')
                                                        .showAlertDialog();
                                                  }
                                                });
                                              } else {
                                                ShowAlertDialog(
                                                        context: context,
                                                        title: 'Ops, Sorry',
                                                        body:
                                                            'Your coop currently not accepting online payment.',
                                                        btnName: 'Close')
                                                    .showAlertDialog();
                                              }
                                            },
                                            style: ForTealButton1,
                                            child: const Row(
                                              children: [
                                                Icon(Feather.dollar_sign),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 2)),
                                                Text(
                                                  'PAY',
                                                  style: btnLoginTxtStyle,
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      })
                                  : null),
                        ),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<List<DataLoanTypes>>(
                stream: DataService.database().readLoanTypeAvailable(
                    coopId: (arguments['loanInfo'] as DataLoan).coopId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final loanTypes = snapshot.data!;

                    // return SizedBox(
                    //     height: size.height * 0.5,
                    //     width: size.width,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: notif.length,
                    //       itemBuilder: (context, index) =>
                    //           paymentSchedule(notif[index]),
                    //     ));

                    return SizedBox(
                      height: size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                'Advertisement',
                                style: btnForgotTxtStyle,
                              ),
                            ),
                          ),
                          CarouselSlider.builder(
                            options: CarouselOptions(
                              height: size.height * 0.2,
                              enableInfiniteScroll: false,
                              reverse: false,
                              onPageChanged: (index, reason) =>
                                  setState(() => activeIndex = index),
                            ),
                            itemCount: loanTypes.length,
                            itemBuilder: (context, index, realIndex) {
                              final loan = loanTypes[index];

                              return buildCard(
                                  loan,
                                  index,
                                  (arguments['loanInfo'] as DataLoan).coopId,
                                  (arguments['loanInfo'] as DataLoan).userId);
                            },
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          buildIndicator(loanTypes.length)
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'there is something error!carousel ${snapshot.error.toString()}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          Container(
            padding: const EdgeInsets.all(10),
            child: StreamBuilder(
                stream: myDb
                    .collection('loans')
                    .where('loanId', isEqualTo: loanTenure.loanId)
                    .where('coopId', isEqualTo: loanTenure.coopId)
                    .where('userId', isEqualTo: loanTenure.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  try {
                    final length = snapshot.data!.docs;
                    final data = snapshot.data!.docs;
                    if (snapshot.hasError) {
                      log('snapshot.hasError (coopdash): ${snapshot.error}');
                      return Container();
                    } else if (snapshot.hasData && length.isNotEmpty) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return onWait;
                        default:
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'LOAN NUMBER',
                                          style: TextStyle(
                                            fontFamily: FontNamedDef,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '${data[0]['loanId']}',
                                          style: const TextStyle(
                                            fontFamily: FontNamedDef,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: data[0]['loanStatus']
                                                      .toString !=
                                                  'completed'
                                              ? Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'DATE ACTIVE',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FontNamedDef,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('MMM d, yyyy')
                                                          .format(data[0]
                                                                  ['createdAt']
                                                              .toDate())
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            FontNamedDef,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Text(
                                                      'DATE COMPLETED',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FontNamedDef,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      DateFormat('MMM d, yyyy')
                                                          .format(data[0]
                                                                  ['completeAt']
                                                              .toDate())
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontFamily:
                                                            FontNamedDef,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'LOAN TYPE',
                                                style: TextStyle(
                                                  fontFamily: FontNamedDef,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '${data[0]['loanType']} LOAN'
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  fontFamily: FontNamedDef,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'EST. TOTAL PAYMENT',
                                                style: TextStyle(
                                                  fontFamily: FontNamedDef,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['totalPayment'])}',
                                                style: const TextStyle(
                                                  fontFamily: FontNamedDef,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'EST. TOTAL INTEREST',
                                                style: TextStyle(
                                                  fontFamily: FontNamedDef,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['totalInterest'])}',
                                                style: const TextStyle(
                                                  fontFamily: FontNamedDef,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.black,
                                                  letterSpacing: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'LOAN AMOUNT',
                                            style: TextStyle(
                                              fontFamily: FontNamedDef,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['loanAmount'])}'
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              fontFamily: FontNamedDef,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            const Text(
                                              'LOAN TENURE',
                                              style: TextStyle(
                                                fontFamily: FontNamedDef,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              '${NumberFormat('###,##0').format(data[0]['noMonths'])} MONTHS',
                                              style: const TextStyle(
                                                fontFamily: FontNamedDef,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "INTEREST RATE",
                                              style: TextStyle(
                                                fontFamily: FontNamedDef,
                                                fontSize: 10,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                            FutureBuilder(
                                              future: myDb
                                                  .collection('coops')
                                                  .doc(data[0]['coopId'])
                                                  .collection('loanTypes')
                                                  .doc(data[0]['loanType'])
                                                  .get(),
                                              builder: (context, snapshot) {
                                                try {
                                                  if (snapshot.hasError) {
                                                    log('snapshot.hasError (coopdash): ${snapshot.error}');
                                                    return Container();
                                                  } else if (snapshot.hasData) {
                                                    switch (snapshot
                                                        .connectionState) {
                                                      case ConnectionState
                                                            .waiting:
                                                        return onWait;
                                                      default:
                                                        return Text(
                                                          '${NumberFormat('##0.00').format(snapshot.data!.data()!['interest'] * 100)} %',
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                FontNamedDef,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                    }
                                                  }
                                                } catch (e) {
                                                  log(e.toString());
                                                }
                                                return Container();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'TOTAL REMAINING BALANCE',
                                              style: TextStyle(
                                                fontFamily: FontNamedDef,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['totalPayment'] - data[0]['paidAmount'])}',
                                              style: TextStyle(
                                                fontFamily: FontNamedDef,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.red[800],
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'TOTAL AMOUNT PAID',
                                              style: TextStyle(
                                                fontFamily: FontNamedDef,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['paidAmount'])}',
                                              style: TextStyle(
                                                fontFamily: FontNamedDef,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.teal[800],
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              FutureBuilder(
                                  future: myDb
                                      .collection('coops')
                                      .doc(loanTenure.coopId)
                                      .collection('loanTypes')
                                      .doc(data[0]['loanType'])
                                      .get(),
                                  builder: (context, snapshot) {
                                    try {
                                      final snap = snapshot.data!.data()!;
                                      if (snapshot.hasError) {
                                        log('snapshot.hasError (coopdash): ${snapshot.error}');
                                        return Container();
                                      } else if (snapshot.hasData &&
                                          data.isNotEmpty) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return onWait;
                                          default:
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'CAPITAL SHARE PAID-UP',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['capitalFee'])}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8)),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'SAVINGS PAID-UP',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['savingsFee'])}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8)),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'TOTAL NET PROCEEDS',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['netProceed'])}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'SERVICE FEE',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['serviceFee'])}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8)),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'INSURANCE FEE',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['insuranceFee'])}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        8)),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Text(
                                                              'TOTAL DEDUCTIONS',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                            Text(
                                                              'PHP ${NumberFormat('###,###,###,##0.00').format(data[0]['totalDeduction'])}',
                                                              style:
                                                                  const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1.5,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            );
                                        }
                                      }
                                    } catch (e) {}
                                    return onWait;
                                  }),
                            ],
                          );
                      }
                    }
                  } catch (e) {}
                  return Container();
                }),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
          Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Feather.calendar,
                  ),
                  Text(
                    'Payment Schedule',
                    style: TextStyle(
                      fontFamily: FontNamedDef,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
              StreamBuilder<List<DataLoanTenure>>(
                stream: DataService.database().readAllLoanTenure(
                    loanId: (arguments['loanInfo'] as DataLoan).loanId,
                    coopId: (arguments['loanInfo'] as DataLoan).coopId,
                    userId: (arguments['loanInfo'] as DataLoan).userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final tenure = snapshot.data!;

                    // return SizedBox(
                    //     height: size.height * 0.5,
                    //     width: size.width,
                    //     child: ListView.builder(
                    //       scrollDirection: Axis.vertical,
                    //       itemCount: notif.length,
                    //       itemBuilder: (context, index) =>
                    //           paymentSchedule(notif[index]),
                    //     ));

                    return SizedBox(
                      child: SingleChildScrollView(
                        child: FittedBox(
                          child: DataTable(columns: const [
                            DataColumn(label: Text('Month')),
                            DataColumn(label: Text('Recommended Pay Date')),
                            DataColumn(label: Text('Amount Due')),
                          ], rows: paymentRow(tenure)),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                        'there is something error! ${snapshot.error.toString()}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget paymentSchedule(DataLoanTenure loanTenure) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/coop/loanview/',
          arguments: {
            'loanId': loanTenure.loanId,
            'coopId': loanTenure.coopId,
            'userId': loanTenure.userId
          },
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(loanTenure.month.toString()),
              Text(DateFormat('MMM d, yyyy')
                  .format(loanTenure.dueDate)
                  .toUpperCase()),
              Text(loanTenure.payment <= 0
                  ? 'PHP 0'
                  : 'PHP ${NumberFormat('###,###,###,##0.00').format(loanTenure.payment)}')
            ],
          ),
          const Divider(
            thickness: 1,
            color: Color.fromRGBO(0, 0, 0, 0.8),
          ),
        ],
      ),
    );
  }

  List<DataRow> paymentRow(List<DataLoanTenure> tenure) {
    final ocCy =
        NumberFormat.currency(decimalDigits: 2, customPattern: '#,###,##0.00');
    List<DataRow> newList = tenure
        .map((e) => DataRow(cells: [
              DataCell(Center(
                  child: Row(
                children: [
                  e.status == 'paid'
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.teal[800],
                        )
                      : Icon(
                          Icons.check_circle,
                          color: Colors.grey[600],
                        ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(e.month.toString()),
                  ),
                ],
              ))),
              DataCell(Center(
                child: Text(
                    DateFormat('MMM d, yyyy').format(e.dueDate).toUpperCase()),
              )),
              DataCell(Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(e.payment <= 0
                          ? 'PHP 0'
                          : 'PHP ${NumberFormat('###,###,###,##0.00').format(e.payment)}'),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            '/coop/loanview/',
                            arguments: {'tenureData': e},
                          );
                        },
                        icon: const Icon(Icons.info_outline))
                  ],
                ),
              ))
            ]))
        .toList();

    return newList;
  }

  Widget buildCard(
      DataLoanTypes? loanTypes, int index, String coopId, String userId) {
    return Container(
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: grey4,
                  spreadRadius: 0.2,
                  blurStyle: BlurStyle.normal,
                  blurRadius: 1.6),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
                child: Text(
              '${loanTypes!.loanName} LOAN'.toUpperCase(),
              style: h4,
            )),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Interest Rate:  ".toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: grey4,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${NumberFormat('###.##').format(double.parse((loanTypes.interest * 100).toStringAsFixed(2)))}%'
                              .toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          fontSize: 13,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            FutureBuilder<double>(
              future: DataService.database()
                  .getCapitalShare(coopId: coopId, userId: userId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final accData = snapshot.data!;

                  // return SizedBox(
                  //     height: size.height * 0.5,
                  //     width: size.width,
                  //     child: ListView.builder(
                  //       scrollDirection: Axis.vertical,
                  //       itemCount: notif.length,
                  //       itemBuilder: (context, index) =>
                  //           paymentSchedule(notif[index]),
                  //     ));

                  return Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Loan Up to:  ".toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: grey4,
                        ),
                        children: [
                          TextSpan(
                            text:
                                'PHP ${NumberFormat('###,###,###,##0.00').format(accData.toDouble() * loanTypes.loanBasedValue)}'
                                    .toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                                fontSize: 13,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text(
                      'there is something error! buildcar ${snapshot.error.toString()}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 30,
                      width: 100,
                      child: ElevatedButton(
                          onPressed: () {},
                          style: ForTealButton1,
                          child: Transform.scale(
                            scale: 0.8,
                            child: Text(
                              'Apply'.toUpperCase(),
                              style: btnLoginTxtStyle,
                            ),
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(int count) => Transform.scale(
        scale: 0.7,
        child: AnimatedSmoothIndicator(
            effect: WormEffect(activeDotColor: teal8),
            activeIndex: activeIndex,
            count: count),
      );
}
