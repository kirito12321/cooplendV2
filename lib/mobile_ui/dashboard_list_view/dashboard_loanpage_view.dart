// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:ascoop/services/database/data_loan.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/style.dart';
// import 'package:ascoop/services/payment/baseclient.dart';
// import 'package:ascoop/services/payment/payment_datamodel.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_loan_details.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

enum Actions { view, details }

class LoanPage extends StatefulWidget {
  const LoanPage({Key? key}) : super(key: key);

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  bool isOnlinePay = true;
  int disInd = 0;
  List navs = [true, false, false];
  void select(int n) {
    for (int i = 0; i < navs.length; i++) {
      if (i != n) {
        navs[i] = false;
      } else {
        navs[i] = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double screenHeight = size.height;
    final double screenWidth = size.width;
    return Column(
      children: [
        Container(
          width: screenWidth,
          height: 65,
          child: Row(
            children: [
              InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      select(0);
                      disInd = 0;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: navs[0] == true ? Colors.teal[800] : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 174, 171, 171),
                            spreadRadius: 0,
                            blurStyle: BlurStyle.normal,
                            blurRadius: 0.9),
                      ],
                    ),
                    child: Text(
                      'Active Loans',
                      style: TextStyle(
                          fontFamily: FontNamedDef,
                          color: navs[0] == true ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      select(1);
                      disInd = 1;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color:
                          navs[1] == true ? Colors.orange[800] : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 174, 171, 171),
                            spreadRadius: 0,
                            blurStyle: BlurStyle.normal,
                            blurRadius: 0.9),
                      ],
                    ),
                    child: Text(
                      'Pending Loans',
                      style: TextStyle(
                          fontFamily: FontNamedDef,
                          color: navs[1] == true ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      select(2);
                      disInd = 2;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: navs[2] == true ? Colors.red[800] : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 174, 171, 171),
                            spreadRadius: 0,
                            blurStyle: BlurStyle.normal,
                            blurRadius: 0.9),
                      ],
                    ),
                    child: Text(
                      'Completed Loans',
                      style: TextStyle(
                          fontFamily: FontNamedDef,
                          color: navs[2] == true ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: IndexedStack(
              index: disInd,
              children: [
                StreamBuilder<List<DataLoan>>(
                  stream: DataService.database()
                      .readAllLoans(status: ['active', 'unreceived']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.hasData) {
                      final loan = snapshot.data!;
                      if (snapshot.data!.length == 0) {
                        return Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ghost_noresult.gif',
                                scale: 3.5,
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8)),
                              Text(
                                'No Completed Loans Yet',
                                style: const TextStyle(
                                    fontFamily: FontNameDefault,
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SlidableAutoCloseBehavior(
                          closeWhenOpened: true,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: loan.length,
                              itemBuilder: (context, index) => Slidable(
                                  endActionPane: ActionPane(
                                      motion: const BehindMotion(),
                                      extentRatio: 0.5,
                                      children: [
                                        SlidableAction(
                                          backgroundColor: teal8,
                                          icon: Feather.clipboard,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              topLeft: Radius.circular(15)),
                                          label: 'Details',
                                          spacing: 5,
                                          onPressed: (context) =>
                                              _onSelectedAction(
                                                  loan[index], Actions.details),
                                        ),
                                        SlidableAction(
                                          backgroundColor: orange8,
                                          icon: Feather.bookmark,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                          spacing: 5,
                                          label: 'View',
                                          onPressed: (context) =>
                                              Navigator.of(context).pushNamed(
                                            // '/coop/loanview/',
                                            '/coop/loantenureview',
                                            arguments: {
                                              'loanInfo': loan[index],
                                              'isOnlinePay': isOnlinePay
                                            },
                                          ),
                                        ),
                                      ]),
                                  child: Container(
                                      width: screenWidth,
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey4,
                                                spreadRadius: 0.2,
                                                blurStyle: BlurStyle.normal,
                                                blurRadius: 1.6),
                                          ]),
                                      child: buildLoan(loan[index])))),
                        );
                      }
                    } else if (snapshot.hasError &&
                        snapshot.connectionState == ConnectionState.active) {
                      return Text(
                          'No data to display ${snapshot.error.toString()}');
                    } else {
                      return Center(
                          child: Transform.scale(
                              scale: 0.8, child: CircularProgressIndicator()));
                    }
                  },
                ),
                StreamBuilder<List<DataLoan>>(
                  stream: DataService.database()
                      .readAllLoans(status: ['pending', 'process']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.hasData) {
                      final loan = snapshot.data!;
                      if (snapshot.data!.length == 0) {
                        return Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ghost_noresult.gif',
                                scale: 3.5,
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8)),
                              Text(
                                'No Completed Loans Yet',
                                style: const TextStyle(
                                    fontFamily: FontNameDefault,
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: loan.length,
                            itemBuilder: (context, index) => Container(
                                width: screenWidth,
                                margin: const EdgeInsets.all(8),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: grey4,
                                          spreadRadius: 0.2,
                                          blurStyle: BlurStyle.normal,
                                          blurRadius: 1.6),
                                    ]),
                                child: buildLoan(loan[index])));
                      }
                    } else if (snapshot.hasError &&
                        snapshot.connectionState == ConnectionState.active) {
                      return Text(
                          'No data to display ${snapshot.error.toString()}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                StreamBuilder<List<DataLoan>>(
                  stream: DataService.database()
                      .readAllLoans(status: ['completed']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.hasData) {
                      final loan = snapshot.data!;
                      if (snapshot.data!.length == 0) {
                        return Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/ghost_noresult.gif',
                                scale: 3.5,
                              ),
                              const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8)),
                              Text(
                                'No Completed Loans Yet',
                                style: const TextStyle(
                                    fontFamily: FontNameDefault,
                                    letterSpacing: 0.5,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SlidableAutoCloseBehavior(
                          closeWhenOpened: true,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: loan.length,
                              itemBuilder: (context, index) => Slidable(
                                  endActionPane: ActionPane(
                                      motion: const BehindMotion(),
                                      children: [
                                        SlidableAction(
                                          backgroundColor:
                                              Colors.yellow.shade300,
                                          icon: Feather.clipboard,
                                          label: 'Details',
                                          onPressed: (context) =>
                                              _onSelectedAction(
                                                  loan[index], Actions.details),
                                        ),
                                      ]),
                                  child: Container(
                                      width: screenWidth,
                                      margin: const EdgeInsets.all(8),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                                color: grey4,
                                                spreadRadius: 0.2,
                                                blurStyle: BlurStyle.normal,
                                                blurRadius: 1.6),
                                          ]),
                                      child: buildLoan(loan[index])))),
                        );
                      }
                    } else if (snapshot.hasError &&
                        snapshot.connectionState == ConnectionState.active) {
                      return Text(
                          'No data to display on completed loan and the error is ${snapshot.error.toString()}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _onSelectedAction(DataLoan loan, Actions action) {
    switch (action) {
      case Actions.details:
        ShowLoanInfoDialog(context: context, loan: loan).showLoanDataDialog();
        break;
      case Actions.view:
        // _payAction(loan);
        Navigator.of(context).pushNamed(
          // '/coop/loanview/',
          '/coop/loantenureview',
          arguments: {
            'loanId': loan.loanId,
            'coopId': loan.coopId,
            'userId': loan.userId
          },
        );
        break;
    }
  }

  Widget buildLoan(DataLoan loanInfo) => Builder(
        builder: (context) => InkWell(
          onTap: () {
            checkCoopPayService(loanInfo.coopId);
            // final slidable = Slidable.of(context)!;

            // final isClosed =
            //     slidable.actionPaneType.value == ActionPaneType.none;

            // if (isClosed) {
            //   slidable.openEndActionPane();
            // } else {
            //   slidable.close();
            // }
            if (loanInfo.loanStatus == 'pending') {
              ShowAlertDialog(
                      context: context,
                      title: 'Show this to the coop counter',
                      body: 'Loan code: ${loanInfo.loanId}',
                      btnName: 'Done')
                  .showAlertDialog();
            } else {
              print('this is in loan page: $isOnlinePay');
              Navigator.of(context).pushNamed(
                // '/coop/loanview/',
                '/coop/loantenureview',
                arguments: {'loanInfo': loanInfo, 'isOnlinePay': isOnlinePay},
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: loanInfo.coopProfilePic,
                      width: 70.0,
                      height: 70.0,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                  SizedBox(
                    width: 70.0,
                    child: Text(
                      '${loanInfo.loanType} loan'.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FontNameDefault,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: grey4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOAN NO.'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: 10,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                            color: grey4,
                          ),
                        ),
                        Text(
                          loanInfo.loanId,
                          style: const TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3)),
                        Builder(builder: (context) {
                          switch (loanInfo.loanStatus) {
                            case 'pending':
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DATE REQUESTED'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy')
                                        .format(loanInfo.createdAt)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    "INTEREST RATE",
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: myDb
                                        .collection('coops')
                                        .doc(loanInfo.coopId)
                                        .collection('loanTypes')
                                        .doc(loanInfo.loanType)
                                        .get(),
                                    builder: (context, snapshot) {
                                      try {
                                        if (snapshot.hasError) {
                                          log('snapshot.hasError (coopdash): ${snapshot.error}');
                                          return Container();
                                        } else if (snapshot.hasData) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return onWait;
                                            default:
                                              return Text(
                                                '${NumberFormat('###.##').format(snapshot.data!.data()!['interest'] * 100)} %',
                                                style: const TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                              );
                            case 'complete':
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DATE COMPLETED'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy')
                                        .format(loanInfo.completeAt!)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    'TOTAL AMOUNT PAID',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    'PHP ${NumberFormat('###,###,###,###.##').format(loanInfo.paidAmount)}',
                                    style: const TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              );
                            default:
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DATE APPROVED'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MMM d, yyyy')
                                        .format(loanInfo.activeAt!)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    'PAY THIS MONTH',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  StreamBuilder(
                                      stream: myDb
                                          .collectionGroup('tenure')
                                          .where('loanId',
                                              isEqualTo: loanInfo.loanId)
                                          .where('userId',
                                              isEqualTo: loanInfo.userId)
                                          .where('status', isEqualTo: 'pending')
                                          .orderBy('dueDate')
                                          .snapshots(),
                                      builder: (context, tenure) {
                                        try {
                                          if (tenure.hasError) {
                                            return Center(
                                                child: Transform.scale(
                                                    scale: 0.8,
                                                    child:
                                                        CircularProgressIndicator()));
                                          } else {
                                            switch (tenure.connectionState) {
                                              case ConnectionState.waiting:
                                                return Center(
                                                    child: Transform.scale(
                                                        scale: 0.8,
                                                        child:
                                                            CircularProgressIndicator()));
                                              case ConnectionState.active:
                                                return Text(
                                                  'PHP ${NumberFormat('###,###,###,###.##').format(tenure.data!.docs[0]['payment'])}',
                                                  style: const TextStyle(
                                                    fontFamily: FontNameDefault,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black,
                                                  ),
                                                );
                                            }
                                          }
                                        } catch (e) {}
                                        return Container();
                                      }),
                                ],
                              );
                          }
                        }),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOAN AMOUNT'.toUpperCase(),
                          style: TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: 10,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w400,
                            color: grey4,
                          ),
                        ),
                        Text(
                          'PHP ${NumberFormat('###,###,###,###.00').format(loanInfo.loanAmount)}',
                          style: const TextStyle(
                            fontFamily: FontNameDefault,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 3)),
                        Builder(builder: (context) {
                          double? getTotPayment(double amount, double interest,
                              int noMonths, String coopid) {
                            double totpay = 0;
                            double emp, emi, ap;
                            double totBal = amount;
                            if (coopid == '7JcfdmGdC4O5mmfYuCkPONQMPAy1') {
                              for (int a = 0; a < noMonths; a++) {
                                if (a < 12) {
                                  emi = amount * interest;
                                  ap = amount / noMonths;
                                  emp = emi + ap;
                                  totBal = totBal - ap;
                                } else {
                                  emi = totBal * interest;

                                  ap = amount / noMonths;
                                  totBal = totBal - ap;
                                  emp = emi + ap;
                                }
                                totpay = totpay + emp;
                              }
                              return totpay;
                            } else {
                              for (int a = 0; a < noMonths; a++) {
                                if (a == 0) {
                                  emi = amount * interest;
                                  ap = amount / noMonths;
                                  emp = emi + ap;
                                  totBal = totBal - ap;
                                } else {
                                  emi = totBal * interest;

                                  ap = amount / noMonths;
                                  totBal = totBal - ap;
                                  emp = emi + ap;
                                }
                                totpay = totpay + emp;
                              }
                              return totpay;
                            }
                          }

                          switch (loanInfo.loanStatus) {
                            case 'pending':
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NO. OF MONTHS TO PAY'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat("###,##0", "en_US").format(loanInfo.noMonths)} MONTHS',
                                    style: const TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    'EST. TOTAL PAYMENT'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: myDb
                                        .collection('coops')
                                        .doc(loanInfo.coopId)
                                        .collection('loanTypes')
                                        .doc(loanInfo.loanType)
                                        .get(),
                                    builder: (context, snapshot) {
                                      try {
                                        if (snapshot.hasError) {
                                          log('snapshot.hasError (coopdash): ${snapshot.error}');
                                          return Container();
                                        } else if (snapshot.hasData) {
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.waiting:
                                              return onWait;
                                            default:
                                              return Text(
                                                'PHP ${NumberFormat("###,###,###,###.00", "en_US").format(getTotPayment(loanInfo.loanAmount, snapshot.data!.data()!['interest'], loanInfo.noMonths, loanInfo.coopId))}',
                                                style: const TextStyle(
                                                  fontFamily: FontNameDefault,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
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
                              );
                            case 'complete':
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NO. OF MONTHS PAID'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat("###,##0", "en_US").format(loanInfo.noMonths)} MONTHS',
                                    style: const TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    'COMPLETION PROGRESS'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat("##0", "en_US").format((loanInfo.noMonthsPaid / loanInfo.noMonths) * 100)}%',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                ],
                              );
                            default:
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NO. OF MONTHS TO PAY'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat("###,##0", "en_US").format(loanInfo.noMonths)} MONTHS',
                                    style: const TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 3)),
                                  Text(
                                    'COMPLETION PROGRESS'.toUpperCase(),
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400,
                                      color: grey4,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat("##0", "en_US").format((loanInfo.noMonthsPaid / loanInfo.noMonths) * 100)}%',
                                    style: TextStyle(
                                      fontFamily: FontNameDefault,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.teal[800],
                                    ),
                                  ),
                                ],
                              );
                          }
                        }),
                      ],
                    ),
                  ],
                ),
              )
            ],
            // ),
            // ListTile(
            //   leading: ClipOval(
            //     child: CachedNetworkImage(
            //       imageUrl: loanInfo.coopProfilePic,
            //       width: 60.0,
            //       height: 60.0,
            //       placeholder: (context, url) =>
            //           Center(child: CircularProgressIndicator()),
            //       errorWidget: (context, url, error) => Icon(Icons.error),
            //     ),
            //   ),
            //   title: Text(
            //     loanInfo.loanId,
            //     style: TextStyle(fontWeight: FontWeight.w800),
            //   ),
            //   subtitle: Text('Php ${loanInfo.loanAmount.toString()}'),
            //   trailing: Icon(Icons.arrow_left_outlined),
            //   onTap: () {
            //     checkCoopPayService(loanInfo.coopId);
            //     // final slidable = Slidable.of(context)!;

            //     // final isClosed =
            //     //     slidable.actionPaneType.value == ActionPaneType.none;

            //     // if (isClosed) {
            //     //   slidable.openEndActionPane();
            //     // } else {
            //     //   slidable.close();
            //     // }
            //     if (loanInfo.loanStatus == 'pending') {
            //       ShowAlertDialog(
            //               context: context,
            //               title: 'Show this to the coop counter',
            //               body: 'Loan code: ${loanInfo.loanId}',
            //               btnName: 'Done')
            //           .showAlertDialog();
            //     } else {
            //       print('this is in loan page: $isOnlinePay');
            //       Navigator.of(context).pushNamed(
            //         // '/coop/loanview/',
            //         '/coop/loantenureview',
            //         arguments: {'loanInfo': loanInfo, 'isOnlinePay': isOnlinePay},
            //       );
            //     }
            //   },
          ),
        ),
      );
  void checkCoopPayService(String coopId) async {
    try {
      await DataService.database()
          .checkCoopOnlinePay(coopId: coopId)
          .then((value) {
        print('this is in checkCoopService function: ${value!.isOnlinePay}');
        setState(() {
          isOnlinePay = value.isOnlinePay;
        });
      });
    } catch (e) {
      print('error in check pay service ${e.toString()}');
    }
  }
}
