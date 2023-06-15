import 'package:ascoop/services/database/data_notification.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_user_notification.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_confirmation_dialog.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

class DashboardNotification extends StatefulWidget {
  const DashboardNotification({super.key});

  @override
  State<DashboardNotification> createState() => _DashboardNotificationState();
}

class _DashboardNotificationState extends State<DashboardNotification> {
  double progress = 100;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenHeight = size.height;
    double screenWidth = size.width;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    StreamBuilder<List<DataUserNotification>>(
                      stream: DataService.database().readUserNotifications(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final notif = snapshot.data!;
                          return headerDeleteText(notif.length, notif);
                        } else if (snapshot.hasError) {
                          return const Text('');
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                    StreamBuilder<List<DataUserNotification>>(
                      stream: DataService.database().checkUserUnreadNotif(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final result = snapshot.data!;
                          return headerMarkText(result.length, result);
                        } else if (snapshot.hasError) {
                          return Text(
                            '',
                            style: TextStyle(
                                fontFamily: FontNamedDef,
                                color: Colors.teal[800],
                                fontSize: 15,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            margin: const EdgeInsets.fromLTRB(0, 8, 8, 10),
            child: Center(
                child: StreamBuilder<List<DataUserNotification>>(
              stream: DataService.database().readUserNotifications(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final notif = snapshot.data!;
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: notif.length,
                      itemBuilder: (context, index) =>
                          buildNotifListTile(notif[index]));
                } else if (snapshot.hasError) {
                  return Text(
                      'there is something error! ${snapshot.hasError.toString()}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )),
          ),
        ),
      ],
    );
  }

  Widget buildNotifListTile(DataUserNotification notif) => Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.fromLTRB(10, 6, 6, 6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: notif.status == 'read' ? Colors.transparent : teal8,
            ),
            boxShadow: [
              BoxShadow(
                  color: notif.status == 'read'
                      ? Color.fromARGB(255, 174, 171, 171)
                      : teal8,
                  spreadRadius: 0.8,
                  blurStyle: BlurStyle.normal,
                  blurRadius: 0.9),
            ]),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                DataService.database()
                    .updateNotifStatus(notifID: notif.notifID)
                    .then((value) => Navigator.of(context).pushNamed(
                          '/user/notificationview/',
                          arguments: {
                            'iconUrl': notif.iconUrl!,
                            'notifTitle': notif.notifTitle ?? 'No Title',
                            'notifText': notif.notifImageUrl != null
                                ? notif.notifText
                                : null,
                            'timestamp': notif.timestamp
                          },
                        ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      backgroundColor: Colors.white30,
                      backgroundImage: notif.notifImageUrl != null
                          ? NetworkImage(notif.iconUrl!)
                          : null),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          notif.notifTitle ?? " ",
                          style: h5,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          notif.notifText ?? " ",
                          style: btnForgotTxtStyle,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            DateFormat('MMM d, yyyy hh:mm a')
                                .format(notif.timestamp),
                            style: TextStyle(
                                fontFamily: FontNamedDef,
                                fontSize: 12,
                                color: Colors.grey[800]),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  void deleteAllNotif(int length, List<DataUserNotification> notif) async {
    for (int i = 0; i < length; i++) {
      await DataService.database().deleteAllNotifications(notif: notif[i]);

      setState(() {
        progress = (i + 1) / length;
      });
    }
  }

  void markAllNotifAsRead(int length, List<DataUserNotification> notif) async {
    for (int i = 0; i < length; i++) {
      await DataService.database().updateNotifStatus(notifID: notif[i].notifID);

      setState(() {
        progress = (i + 1) / length;
      });
    }
  }

  Widget headerMarkText(int length, List<DataUserNotification> notif) =>
      Container(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            // deleteAllNotif(length, notif);
            if (length > 0) {
              markAllNotifAsRead(length, notif);
            } else {
              ShowAlertDialog(
                      context: context,
                      title: 'Notification Prompt',
                      body: 'You already read all of your notifications',
                      btnName: 'OK')
                  .showAlertDialog();
              return;
            }
          },
          child: Row(
            children: [
              Text(
                'Mark all as read',
                style: TextStyle(
                    fontFamily: FontNamedDef,
                    color: Colors.teal[800],
                    fontSize: 15,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      );

  Widget headerDeleteText(int length, List<DataUserNotification> notif) =>
      length <= 0
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (length > 0) {
                    ShowConfirmationDialog(
                            context: context,
                            title: 'Notification',
                            body:
                                'Are you sure you want to trash all the notifications?',
                            fBtnName: 'Yes',
                            sBtnName: 'No')
                        .showConfirmationDialog()
                        .then((value) {
                      if (value != null && value) {
                        deleteAllNotif(length, notif);
                      } else {
                        return;
                      }
                    });
                  } else {
                    ShowAlertDialog(
                            context: context,
                            title: 'Notification',
                            body: 'Nothing to Delete.',
                            btnName: 'Okay')
                        .showAlertDialog();
                    return;
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Feather.trash_2,
                      color: Colors.red[800],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Empty All Notifcation',
                      style: TextStyle(
                          fontFamily: FontNamedDef,
                          color: Colors.red[800],
                          fontSize: 13,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
              ),
            );

  Widget progressIndicator() {
    if (progress * 100 >= 100) {
      return const SizedBox(
        height: 10,
      );
    } else {
      return SizedBox(
        height: 20,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.green,
            ),
            Center(
              child: Text(
                '${(100 * progress).roundToDouble()}%',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }
}
