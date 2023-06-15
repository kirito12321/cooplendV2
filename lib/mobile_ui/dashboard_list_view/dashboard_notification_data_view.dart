import 'package:ascoop/style.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

class DashboardNotifDataView extends StatefulWidget {
  const DashboardNotifDataView({super.key});

  @override
  State<DashboardNotifDataView> createState() => _DashboardNotifDataViewState();
}

class _DashboardNotifDataViewState extends State<DashboardNotifDataView> {
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.04,
                      bottom: screenHeight * 0.04,
                      left: screenWidth * 0.06,
                      right: screenWidth * 0.06),
                  child: PhysicalModel(
                    color: Colors.white,
                    elevation: 8,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                          // color: Color.fromARGB(153, 237, 241, 242),
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              clipBehavior: Clip.none,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: teal8, width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Icon(
                                  Feather.mail,
                                  color: Colors.teal[800],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              DateFormat('MMMM d, yyyy hh:mm a')
                                  .format(arguments['timestamp']),
                              style: TextStyle(
                                  fontFamily: FontNamedDef,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600]),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              arguments['notifTitle'] ?? 'no Title',
                              style: h2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              arguments['notifText'] ?? ' ',
                              style: TextStyle(
                                  fontFamily: FontNamedDef,
                                  fontSize: 16,
                                  color: Colors.grey[800]),
                              textAlign: TextAlign.center,
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
        ));
  }
}
