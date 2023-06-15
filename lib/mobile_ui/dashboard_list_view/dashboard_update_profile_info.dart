import 'package:ascoop/services/database/data_user.dart' as dataUser;
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_confirmation_dialog.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:intl/intl.dart';

import '../../services/database/data_service.dart';
import '../../style.dart';
import '../../web_ui/constants.dart';

class DashboardProfileInfo extends StatefulWidget {
  const DashboardProfileInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardProfileInfo> createState() => _DashboardProfileInfoState();
}

class _DashboardProfileInfoState extends State<DashboardProfileInfo> {
  late final TextEditingController _firstName;
  late final TextEditingController _middleName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _contactNo;
  late final TextEditingController _currentAddress;
  late final TextEditingController _bday;
  bool fnNullChecker = false;
  bool mnNullChecker = false;
  bool lnNullChecker = false;
  bool emailNullChecker = false;
  bool contactNoNullChecker = false;
  bool birthdateNullChecker = false;
  bool currendAddNullChecker = false;
  List<bool> checkField = [];
  DateTime _birthdate = DateTime.now();
  @override
  void initState() {
    _bday = TextEditingController();
    _firstName = TextEditingController();
    _middleName = TextEditingController();
    _lastName = TextEditingController();
    _email = TextEditingController();
    _contactNo = TextEditingController();
    _currentAddress = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _bday.dispose();
    _middleName.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _contactNo.dispose();
    _currentAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return FutureBuilder<dataUser.UserInfo?>(
      future: DataService.database().readUserData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;

          return user == null
              ? const Text('No Data')
              : buildUserProfile(user, size);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildUserProfile(dataUser.UserInfo userInfo, Size size) {
    double screenHeight = size.height;
    double screenWidth = size.width;

    return AlertDialog(
      content: Container(
        clipBehavior: Clip.hardEdge,
        width: 450,
        height: 600,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Feather.edit_3,
                  size: 20,
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
                Text(
                  'Update Profile',
                  style: TextStyle(
                      fontFamily: FontNamedDef,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                thickness: 0.3,
                color: grey4,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 2)),
            Expanded(
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: fnNullChecker == true ? _firstName : null,
                        initialValue:
                            fnNullChecker == true ? null : userInfo.firstName,
                        onTap: () => setState(() {
                          fnNullChecker = true;
                        }),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Firstname',
                            labelStyle: TextStyle(
                                fontFamily: FontNamedDef,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNamedDef,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: mnNullChecker == true ? _middleName : null,
                        initialValue:
                            mnNullChecker == true ? null : userInfo.middleName,
                        onTap: () => setState(() {
                          mnNullChecker = true;
                        }),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Middlename',
                            labelStyle: TextStyle(
                                fontFamily: FontNamedDef,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNamedDef,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: lnNullChecker == true ? _lastName : null,
                        initialValue:
                            lnNullChecker == true ? null : userInfo.lastName,
                        onTap: () => setState(() {
                          lnNullChecker = true;
                        }),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Lastname',
                            labelStyle: TextStyle(
                                fontFamily: FontNamedDef,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNamedDef,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller:
                            contactNoNullChecker == true ? _contactNo : null,
                        initialValue: contactNoNullChecker == true
                            ? null
                            : userInfo.mobileNo,
                        onTap: () => setState(() {
                          contactNoNullChecker = true;
                        }),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Mobile No.',
                            labelStyle: TextStyle(
                                fontFamily: FontNamedDef,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNamedDef,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextFormField(
                        keyboardType: TextInputType.none,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: Timestamp.now().toDate(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));

                          if (newDate == null) return;

                          setState(() => _birthdate = newDate);
                        },
                        decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            alignLabelWithHint: false,
                            hintText:
                                DateFormat('MMM d, yyyy').format(_birthdate),
                            labelText: 'Birthdate',
                            labelStyle: TextStyle(
                                fontFamily: FontNamedDef,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNamedDef,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: currendAddNullChecker == true
                            ? _currentAddress
                            : null,
                        initialValue: currendAddNullChecker == true
                            ? null
                            : userInfo.currentAddress,
                        onTap: () => setState(() {
                          currendAddNullChecker = true;
                        }),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: const BorderSide(
                                color: Color.fromARGB(255, 0, 105, 92),
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Current Address',
                            labelStyle: TextStyle(
                                fontFamily: FontNamedDef,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.grey[700],
                                letterSpacing: 1)),
                        style: const TextStyle(
                            fontFamily: FontNamedDef,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                            letterSpacing: 1),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      fontFamily: FontNamedDef,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 4)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'CONFIRM',
                    style: TextStyle(
                      fontFamily: FontNamedDef,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              onPressed: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      content: onWait),
                );
                if (_firstName.text.isNotEmpty &&
                    _middleName.text.isNotEmpty &&
                    _lastName.text.isNotEmpty &&
                    _contactNo.text.isNotEmpty &&
                    _currentAddress.text.isNotEmpty) {
                  final userUpdate = dataUser.UserInfo(
                      userUID: userInfo.userUID,
                      firstName: _firstName.text,
                      middleName: _middleName.text,
                      lastName: _lastName.text,
                      gender: userInfo.gender,
                      email: userInfo.email,
                      mobileNo: _contactNo.text,
                      birthDate: _birthdate,
                      currentAddress: _currentAddress.text);

                  // showErrorDialog(context,
                  //         'Changes successfuly saved')
                  //     .then((value) => Navigator.of(context)
                  //         .pushNamedAndRemoveUntil(
                  //             '/dashboard/',
                  //             (route) => false));

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Update Confirmation',
                        style: alertDialogTtl,
                      ),
                      content: Text(
                        'Are you sure you want to update your profile?',
                        style: alertDialogContent,
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ForTealButton,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'No',
                                style: alertDialogBtn,
                              ),
                            )),
                        ElevatedButton(
                            onPressed: () {
                              DataService.database()
                                  .updateInfo(user: userUpdate)
                                  .then(
                                      (value) => Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              '/dashboard/', (route) => false),
                                      onError: (e) {
                                okDialog(context, 'Something Wrong',
                                        'Unexpected error found.')
                                    .whenComplete(() => Navigator.pop(context));
                              });
                            },
                            style: ForTealButton,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Yes',
                                style: alertDialogBtn,
                              ),
                            )),
                      ],
                    ),
                  );
                } else {
                  okDialog(
                          context, 'Update Unsuccessful', 'Empty fields found.')
                      .whenComplete(() => Navigator.pop(context));
                }
              },
            ),
          ],
        ),
      ],
      // Column(
      //   mainAxisSize: MainAxisSize.max,
      //   children: [
      //     Container(
      //       decoration: const BoxDecoration(
      //         color: Colors.white,
      //       ),
      //       child: Padding(
      //         padding: EdgeInsets.only(
      //             top: screenHeight * 0.04,
      //             bottom: screenHeight * 0.04,
      //             left: screenWidth * 0.06,
      //             right: screenWidth * 0.06),
      //         child: PhysicalModel(
      //           color: Colors.white,
      //           elevation: 8,
      //           borderRadius: const BorderRadius.all(Radius.circular(20)),
      //           child: Container(
      //             margin: const EdgeInsets.all(20),
      //             decoration: const BoxDecoration(
      //                 // color: Color.fromARGB(153, 237, 241, 242),
      //                 color: Colors.white,
      //                 borderRadius: BorderRadius.all(Radius.circular(20))),
      //             child: SingleChildScrollView(
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.stretch,
      //                 children: [
      //                   const Text('First Name: '),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),

      //                   const Text('Last Name: '),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),

      //                   const Text('Email Address: '),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),

      //                   const Text('Contact Number: '),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),
      //
      //                   const Text('Birthdate: '),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),
      //
      //                   const Text('Address: '),
      //                   const SizedBox(
      //                     height: 10,
      //                   ),
      //
      //                   const SizedBox(
      //                     height: 50,
      //                   ),
      //                   Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       SizedBox(
      //                         height: 50,
      //                         width: 100,
      //                         child: ElevatedButton(
      //                           style: ElevatedButton.styleFrom(
      //                             backgroundColor: checkField
      //                                     .where(
      //                                         (element) => element == true)
      //                                     .isNotEmpty
      //                                 ? Colors.teal[600]
      //                                 : const Color.fromARGB(
      //                                     255, 85, 86, 86),
      //                             shape: const StadiumBorder(),
      //                           ),
      //                           onPressed: () async {
      //                             if (checkField
      //                                 .where((element) => element == true)
      //                                 .isNotEmpty) {
      //                               final userUpdate = dataUser.UserInfo(
      //                                   userUID: userInfo.userUID,
      //                                   firstName: _firstName.text,
      //                                   middleName: userInfo.middleName,
      //                                   lastName: userInfo.lastName,
      //                                   gender: userInfo.gender,
      //                                   email: userInfo.email,
      //                                   mobileNo: userInfo.mobileNo,
      //                                   birthDate: _birthdate ??
      //                                       userInfo.birthDate,
      //                                   currentAddress:
      //                                       userInfo.currentAddress);

      //                               // showErrorDialog(context,
      //                               //         'Changes successfuly saved')
      //                               //     .then((value) => Navigator.of(context)
      //                               //         .pushNamedAndRemoveUntil(
      //                               //             '/dashboard/',
      //                               //             (route) => false));

      //                               ShowConfirmationDialog(
      //                                       context: context,
      //                                       title: 'Save Changes',
      //                                       body:
      //                                           'Are you sure you want to save it?',
      //                                       fBtnName: 'Yes',
      //                                       sBtnName: 'No')
      //                                   .showConfirmationDialog()
      //                                   .then((value) {
      //                                 if (value == true) {
      //                                   DataService.database()
      //                                       .updateInfo(user: userUpdate)
      //                                       .then((value) => Navigator.of(
      //                                               context)
      //                                           .pushNamedAndRemoveUntil(
      //                                               '/dashboard/',
      //                                               (route) => false));
      //                                 }
      //                               });
      //                             } else {
      //                               ShowAlertDialog(
      //                                       context: context,
      //                                       title: 'Error....',
      //                                       body:
      //                                           'No changes has been made.',
      //                                       btnName: 'Close')
      //                                   .showAlertDialog();
      //                               return;
      //                             }
      //                           },
      //                           child: const Text('Save'),
      //                         ),
      //                       ),
      //                       const SizedBox(
      //                         width: 40,
      //                       ),
      //                       SizedBox(
      //                         height: 50,
      //                         width: 100,
      //                         child: ElevatedButton(
      //                           style: ElevatedButton.styleFrom(
      //                             backgroundColor: Colors.teal[600],
      //                             shape: const StadiumBorder(),
      //                           ),
      //                           onPressed: () async {
      //                             //Do something...
      //                             Navigator.of(context).pop();
      //                           },
      //                           child: const Text('Cancel'),
      //                         ),
      //                       ),
      //                     ],
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
