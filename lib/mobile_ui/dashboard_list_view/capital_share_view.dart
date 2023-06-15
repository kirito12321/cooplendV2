import 'package:ascoop/services/database/data_capital_history.dart';
import 'package:ascoop/services/database/data_coop_acc.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CapitalShareHistory extends StatefulWidget {
  const CapitalShareHistory({super.key});

  @override
  State<CapitalShareHistory> createState() => _CapitalShareHistoryState();
}

class _CapitalShareHistoryState extends State<CapitalShareHistory> {
  final ocCy =
      NumberFormat.currency(decimalDigits: 2, customPattern: '###,###,##0.00');
  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
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
            'Capital Share',
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
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                        // color: Color.fromARGB(153, 237, 241, 242),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: screenHeight * 0.2,
                            child: FutureBuilder<DataCoopAcc?>(
                              future: DataService.database().getCoopAcc(
                                  coopId: arguments['coopId'],
                                  userId: arguments['userId']),
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

                                  return buildCapShare(
                                      screenHeight, screenWidth, accData);
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Error: ${snapshot.error.toString()}');
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.all(15.0),
                        //   child: Divider(
                        //     color: Color.fromARGB(
                        //         255, 19, 13, 13), //color of divider
                        //     height: 0, //height spacing of divider
                        //     thickness: 1, //thickness of divier line
                        //     indent: 0, //spacing at the start of divider
                        //     endIndent: 0, //spacing at the end of divider
                        //   ),
                        // ),
                        SizedBox(
                          height: screenHeight * 0.5,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(Icons.history_outlined),
                                    ),
                                    Text(
                                      'Capital Share History',
                                      style: h4,
                                    )
                                  ],
                                ),
                                StreamBuilder<List<DataCapitalShareHistory>>(
                                  stream: DataService.database()
                                      .getCapitalShareHistory(
                                          coopId: arguments['coopId'],
                                          userId: arguments['userId']),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final cs = snapshot.data!;

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
                                            child: DataTable(
                                                columnSpacing: 20,
                                                horizontalMargin: 0,
                                                dividerThickness: 2,
                                                headingTextStyle:
                                                    CashMediumTextStyle,
                                                dataTextStyle:
                                                    CashMediumTextStyle,
                                                columns: const [
                                                  DataColumn(
                                                      label: Text('Date')),
                                                  DataColumn(
                                                      label:
                                                          Text('Withdrawals')),
                                                  DataColumn(
                                                      label: Text('Deposits')),
                                                  DataColumn(
                                                      label: Text('Balance')),
                                                ],
                                                rows: historyRow(cs)),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text(
                                          'there is something error! ${snapshot.error.toString()}');
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildCapShare(
      double screenHeight, double screenWidth, DataCoopAcc acc) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: screenHeight * 0.15,
        // margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Color.fromARGB(255, 174, 171, 171),
                spreadRadius: 0,
                blurStyle: BlurStyle.normal,
                blurRadius: 0.9),
          ],
          borderRadius: BorderRadius.circular(10),
          // color: Color.fromARGB(153, 237, 241, 242),
          color: Colors.white,
          // borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                    color: Colors.teal[800],
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: const Center(
                    child: Text(
                  'Capital Share',
                  style: btnLoginTxtStyle,
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                    child: Text(
                  'PHP ${ocCy.format(acc.capitalShare)}',
                  style: h2,
                )),
              ),
              const Center(
                  child: Text(
                'Total Shares',
                style: DashboardNormalTextStyle,
              ))
            ],
          ),
        ),
      ),
    );
  }

  List<DataRow> historyRow(List<DataCapitalShareHistory> cs) {
    List<DataRow> newList = cs
        .map((e) => DataRow(cells: [
              DataCell(Center(
                child:
                    Text(DateFormat('MMM d, yyyy hh:mm a').format(e.timestamp)),
              )),
              DataCell(Center(
                child: Text(
                  e.withdrawals == 0 ? '' : 'PHP ${ocCy.format(e.withdrawals)}',
                ),
              )),
              DataCell(Center(
                child: Text(
                  e.deposits == 0 ? '' : 'PHP ${ocCy.format(e.deposits)}',
                ),
              )),
              DataCell(Center(
                child: Text('PHP ${ocCy.format(e.balance)}'),
              )),
            ]))
        .toList();

    return newList;
  }
}
