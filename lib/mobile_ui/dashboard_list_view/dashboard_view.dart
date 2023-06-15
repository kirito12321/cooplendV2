import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_settings_view.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_user_notification.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_cooppage_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_homepage_view.dart';
import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_loanpage_view.dart';
import 'package:ascoop/utilities/show_confirmation_dialog.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'dashboard_notificationpage_view.dart';
// import 'dart:developer' as devtools show log;

enum MenuAction { logout }

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List ico = [
    Icon(
      Feather.monitor,
      size: 23,
      color: Colors.black,
    ),
    Icon(
      Feather.credit_card,
      size: 23,
      color: Colors.black,
    ),
    Icon(
      Feather.bell,
      size: 23,
      color: Colors.black,
    ),
    Image.asset(
      'assets/images/logo_only_c.png',
      color: Colors.black,
    ),
  ];
  List ttl = [
    'Dashboard',
    'Loans',
    'Notifications',
    'Cooperatives',
  ];
  int currentTab = 0;

  int? numNotif = 0;
  var screens = [
    const DashboardHome(),
    const LoanPage(),
    const DashboardNotification(),
    const DashboardCoop(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Widget currentScreen = DashboardHome();
    const selectedColor = Colors.white;
    const unSelectedColor = Colors.white54;
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 27, 138, 115),
      appBar: AppBar(
        elevation: 1,
        title: Row(
          children: [
            IconButton(
              icon: ico[currentTab],
              onPressed: () {},
            ),
            Text(
              ttl[currentTab],
              style: dashboardMemberTextStyle,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              icon: const Image(
                  image: AssetImage('assets/images/cooplendlogo.png')),
              padding: const EdgeInsets.all(2.0),
              iconSize: screenWidth * 0.35,
              onPressed: () {},
            ),
          )
        ],
      ),
      body: screens[currentTab],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            // currentScreen = const DashboardCoop();
            currentTab = 3;
          });
        },
        child: const Image(
          image: AssetImage('assets/images/cooperative.ico'),
          fit: BoxFit.fill,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal[800],
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Transform.scale(
                scale: 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // currentScreen = const DashboardHome();
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Feather.home,
                            color: currentTab == 0
                                ? selectedColor
                                : unSelectedColor,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2)),
                          Text(
                            'Dashboard',
                            style: TextStyle(
                                color: currentTab == 0
                                    ? selectedColor
                                    : unSelectedColor),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // currentScreen = const LoanPage();
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Feather.credit_card,
                            color: currentTab == 1
                                ? selectedColor
                                : unSelectedColor,
                          ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2)),
                          Text(
                            'Loans',
                            style: TextStyle(
                                color: currentTab == 1
                                    ? selectedColor
                                    : unSelectedColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.9,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          // currentScreen = const DashboardNotification();
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<List<DataUserNotification>>(
                            stream:
                                DataService.database().checkUserUnreadNotif(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final notif = snapshot.data!;
                                return notif.isNotEmpty
                                    ? badges.Badge(
                                        position: badges.BadgePosition.topEnd(),
                                        badgeAnimation:
                                            const badges.BadgeAnimation.fade(
                                                animationDuration: Duration(
                                                    milliseconds: 1000),
                                                loopAnimation: false),
                                        badgeContent: notif.length > 100
                                            ? const Text(
                                                '99+',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              )
                                            : Text(
                                                notif.length.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),
                                              ),
                                        child: Icon(
                                          Feather.bell,
                                          color: currentTab == 2
                                              ? selectedColor
                                              : unSelectedColor,
                                        ),
                                      )
                                    : Icon(
                                        Feather.bell,
                                        color: currentTab == 2
                                            ? selectedColor
                                            : unSelectedColor,
                                      );
                              } else if (snapshot.hasError) {
                                print(
                                    'there is something error! ${snapshot.hasError.toString()}');
                                return Container();
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                          // numNotif != null && numNotif != 0
                          //     ? Badge(
                          //         position: BadgePosition.topEnd(),
                          //         animationDuration:
                          //             const Duration(milliseconds: 5000),
                          //         animationType: BadgeAnimationType.slide,
                          //         badgeContent: Text(
                          //           numNotif.toString(),
                          //           style: const TextStyle(color: Colors.white),
                          //         ),
                          //         child: Icon(
                          //           Icons.notifications_outlined,
                          //           color: currentTab == 2
                          //               ? selectedColor
                          //               : unSelectedColor,
                          //         ),
                          //       )
                          //     : Icon(
                          //         Icons.notifications_outlined,
                          //         color: currentTab == 2
                          //             ? selectedColor
                          //             : unSelectedColor,
                          //       ),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2)),
                          Text(
                            'Notifications',
                            style: TextStyle(
                                color: currentTab == 2
                                    ? selectedColor
                                    : unSelectedColor),
                          )
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        ShowConfirmationDialog(
                                context: context,
                                title: 'Logout Confirmation',
                                body: 'Are you sure you want to logout?',
                                fBtnName: 'Yes',
                                sBtnName: 'No')
                            .showConfirmationDialog()
                            .then((value) {
                          if (value!) {
                            AuthService.firebase().logOut().then((value) =>
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    '/login/', (route) => false));
                          }
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Feather.log_out, color: unSelectedColor),
                          const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2)),
                          Text(
                            'Logout',
                            style: TextStyle(color: unSelectedColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
