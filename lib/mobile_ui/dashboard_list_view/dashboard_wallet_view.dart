import 'package:ascoop/services/database/data_coop.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/view_wallet_options.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../web_ui/constants.dart';

class DashboardWallet extends StatefulWidget {
  const DashboardWallet({super.key});

  @override
  State<DashboardWallet> createState() => _DashboardWalletState();
}

class _DashboardWalletState extends State<DashboardWallet> {
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '###,###,##0.00');
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          leading: const BackButton(
            color: Colors.black,
          ),
          title: const Text(
            'Wallet',
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        child: StreamBuilder<List<DataSubscription>>(
                          stream: DataService.database().readAllSubs(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.active &&
                                snapshot.hasData) {
                              final subs = snapshot.data!;
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: subs.length,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                          onTap: () {
                                            ShowWalletViewOption(
                                                    context: context,
                                                    coopId: subs[index].coopId,
                                                    userId: subs[index].userId)
                                                .showOptionDialog();
                                          },
                                          child:
                                              buildWallet(size, subs[index])));
                            } else if (snapshot.hasError &&
                                snapshot.connectionState ==
                                    ConnectionState.active) {
                              return Text(
                                  'No data to display ${snapshot.error.toString()}');
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildWallet(Size size, DataSubscription subs) {
    double screenHeight = size.height;
    // double screenWidth =size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: grey4,
                spreadRadius: 0.2,
                blurStyle: BlurStyle.normal,
                blurRadius: 1.6),
          ]),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<CoopInfo?>(
              future: DataService.database().readCoopData(coopID: subs.coopId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final coop = snapshot.data;
                  return coop == null
                      ? const Text('No Data')
                      : buildCapData(coop, subs);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildCapData(CoopInfo coop, DataSubscription subs) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: coop.profilePic,
              fit: BoxFit.fill,
              width: 90.0,
              height: 90.0,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  coop.coopName,
                  style: h4,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Capital Share:',
                          style: btnForgotTxtStyle,
                        ),
                        FutureBuilder<double>(
                          future: DataService.database().getCapitalShare(
                              coopId: coop.coopID, userId: subs.userId),
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
                                child: Text(
                                  'Php ${ocCy.format(accData.toDouble())}'
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: FontNamedDef,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Php${ocCy.format(0.0)}');
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Savings:',
                          style: btnForgotTxtStyle,
                        ),
                        FutureBuilder<double>(
                          future: DataService.database().getSavings(
                              coopId: coop.coopID, userId: subs.userId),
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
                                child: Text(
                                  'Php ${ocCy.format(accData.toDouble())}'
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: FontNamedDef,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Php${ocCy.format(0.0)}');
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );

  String makeFewWords(String text) {
    final splitted = text.split(' ');

    return '${splitted.first} Coop';
  }
}
