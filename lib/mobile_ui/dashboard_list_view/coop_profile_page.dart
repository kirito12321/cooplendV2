import 'dart:math';

import 'package:ascoop/services/database/data_coop.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/services/database/data_user.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/create_loan_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_subscription_step.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CoopProfile extends StatefulWidget {
  final String coopID;
  const CoopProfile({required this.coopID, super.key});

  @override
  State<CoopProfile> createState() => _CoopProfileState();
}

class _CoopProfileState extends State<CoopProfile> {
  bool isSuccess = false;
  bool isAllowed = false;
  String sendLoanCode = '';

  @override
  void initState() {
    loanCodeGenerator(5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<CoopInfo?>(
      future: DataService.database().readCoopData(coopID: widget.coopID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final coop = snapshot.data;
          return coop == null
              ? const Text('No Data')
              : buildCoopProf(coop, size);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildCoopProf(CoopInfo coop, Size size) {
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: Text(
            coop.coopName,
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
                iconSize: screenWidth * 0.3,
                onPressed: () {},
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: screenHeight * 0.02,
                        bottom: screenHeight * 0.04,
                        left: screenWidth * 0.06,
                        right: screenWidth * 0.06),
                    child: PhysicalModel(
                      color: Colors.white,
                      elevation: 6,
                      shadowColor: grey4,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                            // color: Color.fromARGB(153, 237, 241, 242),
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              width: 250,
                              height: 250,
                              clipBehavior: Clip.none,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(coop.profilePic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Flexible(
                              fit: FlexFit.tight,
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        coop.coopName,
                                        style: h2,
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Email Address',
                                        style: btnForgotTxtStyle,
                                      ),
                                      Text(
                                        coop.email,
                                        style: h4,
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        'Current Address',
                                        style: btnForgotTxtStyle,
                                      ),
                                      Text(
                                        coop.coopAddress,
                                        style: h4,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          FutureBuilder<UserInfo?>(
                                            future: DataService.database()
                                                .readUserData(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                final user = snapshot.data;

                                                return user == null
                                                    ? const Text('No Data')
                                                    : checkingSubs(coop, user);
                                              } else {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget checkingSubs(CoopInfo coop, UserInfo user) {
    return FutureBuilder<DataSubscription?>(
        future: DataService.database()
            .readSubscriptions(coopID: coop.coopID, userID: user.userUID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data?.status) {
              case 'verified':
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: teal8, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'SUBSCRIBER',
                            style: TextStyle(
                                fontFamily: FontNamedDef,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.teal[800]),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Feather.user_check,
                            color: Colors.teal[800],
                            size: 25,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    coopProfileBtn(
                        coop,
                        user,
                        'APPLY LOAN',
                        CreateLoan(
                          coop: coop,
                          user: user,
                          loanCode: sendLoanCode,
                        ),
                        snapshot.data!.status,
                        FontAwesomeIcons.handHoldingDollar),
                  ],
                );
              case 'pending':
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: orange8, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'REQUEST SENT',
                            style: TextStyle(
                                fontFamily: FontNamedDef,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.orange[800]),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Feather.check_circle,
                            color: Colors.orange[800],
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              case 'process':
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: orange8, width: 2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'REQUEST SENT',
                            style: TextStyle(
                                fontFamily: FontNamedDef,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                                color: Colors.orange[800]),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Feather.check_circle,
                            color: Colors.orange[800],
                            size: 25,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              default:
                return Container(
                  height: 50,
                  width: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: red8, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'BLOCKED',
                        style: TextStyle(
                            fontFamily: FontNamedDef,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: Colors.red[800]),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Feather.user_x,
                        color: Colors.red[800],
                        size: 25,
                      )
                    ],
                  ),
                );
            }
          }
          // else if (snapshot.data?.status == 'pending') {
          //   return coopProfileBtn(
          //       coop,
          //       user,
          //       '',
          //       CoopSubscriptionStep(user: user, coop: coop,),
          //       snapshot.data?.status,

          //       ,);
          // }
          else if (snapshot.hasData != true) {
            print(snapshot.error.toString());
            return coopProfileBtn(
              coop,
              user,
              'SUBSCRIBE',
              CoopSubscriptionStep(user: user, coop: coop),
              snapshot.data?.status,
              Feather.user_plus,
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Widget coopProfileBtn(CoopInfo coop, UserInfo user, String text,
          dynamic object, String? status, var ico) =>
      SizedBox(
        height: 50,
        width: 260,
        child: Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  status == 'verified' || status != null || isSuccess == true
                      // ? const Color.fromARGB(115, 115, 115, 115)
                      ? teal8
                      : teal8,
              shape: const StadiumBorder(),
            ),
            onPressed:
                status == 'verified' || status == null || isSuccess == false
                    ? () async {
                        final data = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => object),
                        );

                        setState(() {
                          isSuccess = data ?? false;
                        });
                      }
                    : () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  ico,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  text,
                  style: btnLoginTxtStyle,
                ),
              ],
            ),
          ),
        ),
      );

  void loanCodeGenerator(int length) async {
    String loanId = '';

    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
    loanId = getRandomString(length);

    // bool check = await DataService.database().checkLoanCode(loanId: loanId);
    // if (check) {
    //   return loanId;
    // } else {
    bool check = await DataService.database().checkLoanCode(loanId: loanId);
    print(check);
    if (check) {
      return loanCodeGenerator(5);
    } else {
      setState(() {
        sendLoanCode = loanId;
        print(sendLoanCode);
      });
    }

    // }
  }

  void checkIsAllowedToLoan() async {
    bool result = await DataService.database()
        .checkAllowedReloan(coopId: widget.coopID, requiredMonthLoanPaid: 6);
    setState(() {
      isAllowed = result;
    });

    print('result from checkIsAllowedToLoan function: $isAllowed');
  }

  Widget coopLoanBtn() => SizedBox(
        height: 50,
        width: 200,
        child: Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              ShowAlertDialog(
                      context: context,
                      title: 'Loan Error',
                      body:
                          'You already have pending or have an active loan and not paid up to 6 months',
                      btnName: 'Okay')
                  .showAlertDialog();
              return;
            },
            child: Text('loan'),
          ),
        ),
      );
}
