import 'package:ascoop/mobile_ui/dashboard_list_view/dashboard_update_profile_info.dart';
import 'package:ascoop/services/auth/auth_user.dart';
import 'package:ascoop/services/database/data_user.dart' as dataUser;
import 'package:ascoop/style.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart' as modal;

import '../../services/database/data_service.dart';

class DashboardHome extends StatefulWidget {
  const DashboardHome({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
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
    return SafeArea(
        child: Expanded(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),

                //coop
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(255, 174, 171, 171),
                        spreadRadius: 0.5,
                        blurStyle: BlurStyle.normal,
                        blurRadius: 3.0)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  '/user/profilepicset/',
                                  arguments: {'userId': userInfo.userUID});
                            },
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: userInfo.profilePicUrl!,
                                fit: BoxFit.cover,
                                width: 60.0,
                                height: 60.0,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(
                      vertical: 6,
                    )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${userInfo.firstName} ${userInfo.middleName} ${userInfo.lastName}',
                              style: h2,
                            ),
                          ],
                        ), //User Full Name
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 6)),
                        const Text(
                          'Email Address:',
                          style: DashboardNormalTextStyle,
                        ),

                        Text(
                          (FirebaseAuth.instance.currentUser?.email) ??
                              'no data',
                          style: h5,
                        ), //User Email Address
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        const Text('Contact Number:',
                            style: DashboardNormalTextStyle),
                        Text(
                          userInfo.mobileNo,
                          style: h5,
                        ), //User Contact Number
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),

                        const Text('Birthdate:',
                            style: DashboardNormalTextStyle),
                        Text(
                          DateFormat('MMM d, yyyy').format(userInfo.birthDate),
                          style: h5,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 4)),
                        const Text('Address:', style: DashboardNormalTextStyle),
                        Text(
                          userInfo.currentAddress,
                          style: h5,
                        ),
                        //User Birthdate
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: ElevatedButton(
                                style: ForBorderTeal,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Feather.edit_3,
                                        size: 20,
                                        color: Colors.teal[900],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4)),
                                      Text(
                                        'Update Profile'.toUpperCase(),
                                        style: txtborderteal,
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return DashboardProfileInfo();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 2)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: ElevatedButton(
                                style: ForBorderTeal,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Feather.unlock,
                                        size: 20,
                                        color: Colors.teal[900],
                                      ),
                                      const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4)),
                                      Text(
                                        'Change Password'.toUpperCase(),
                                        style: txtborderteal,
                                      ),
                                    ],
                                  ),
                                ),
                                onPressed: () async {
                                  var org = TextEditingController();
                                  var npass = TextEditingController();
                                  var cpass = TextEditingController();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Container(
                                            clipBehavior: Clip.hardEdge,
                                            width: 400,
                                            height: 350,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: const [
                                                    Icon(
                                                      Feather.unlock,
                                                      size: 20,
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4)),
                                                    Text(
                                                      'Change Password',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              FontNamedDef,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 1.5,
                                                          fontSize: 18,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: Divider(
                                                    thickness: 0.3,
                                                    color: grey4,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: ScrollConfiguration(
                                                    behavior:
                                                        MyCustomScrollBehavior(),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            controller: org,
                                                            obscureText: true,
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            105,
                                                                            92),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                    labelText:
                                                                        'Current Password',
                                                                    labelStyle: TextStyle(
                                                                        fontFamily:
                                                                            FontNamedDef,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors.grey[
                                                                            700],
                                                                        letterSpacing:
                                                                            1)),
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10)),
                                                          TextFormField(
                                                            controller: npass,
                                                            obscureText: true,
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            105,
                                                                            92),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                    labelText:
                                                                        'New Password',
                                                                    labelStyle: TextStyle(
                                                                        fontFamily:
                                                                            FontNamedDef,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors.grey[
                                                                            700],
                                                                        letterSpacing:
                                                                            1)),
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          10)),
                                                          TextFormField(
                                                            controller: cpass,
                                                            obscureText: true,
                                                            decoration:
                                                                InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30.0),
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            105,
                                                                            92),
                                                                        width:
                                                                            2.0,
                                                                      ),
                                                                    ),
                                                                    labelText:
                                                                        'Confirm New Password',
                                                                    labelStyle: TextStyle(
                                                                        fontFamily:
                                                                            FontNamedDef,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors.grey[
                                                                            700],
                                                                        letterSpacing:
                                                                            1)),
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    FontNamedDef,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black,
                                                                letterSpacing:
                                                                    1),
                                                          ),
                                                          const Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          15)),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors.red[
                                                                          800],
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child: Text(
                                                                      'CANCEL',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontNamedDef,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color: Colors
                                                                            .white,
                                                                        letterSpacing:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                              const Padding(
                                                                  padding: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8)),
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Colors.teal[
                                                                          800],
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25.0),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    child: Text(
                                                                      'CONFIRM',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            FontNamedDef,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        color: Colors
                                                                            .white,
                                                                        letterSpacing:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  showDialog(
                                                                    barrierDismissible:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder: (context) => AlertDialog(
                                                                        backgroundColor:
                                                                            Colors
                                                                                .transparent,
                                                                        elevation:
                                                                            0,
                                                                        content:
                                                                            onWait),
                                                                  );
                                                                  late String
                                                                      pass,
                                                                      conpass,
                                                                      newpass;
                                                                  pass = org
                                                                      .text
                                                                      .trim();
                                                                  conpass = cpass
                                                                      .text
                                                                      .trim();
                                                                  newpass = npass
                                                                      .text
                                                                      .trim();
                                                                  if (pass.isNotEmpty &&
                                                                      conpass
                                                                          .isNotEmpty &&
                                                                      newpass
                                                                          .isNotEmpty) {
                                                                    if (conpass ==
                                                                        newpass) {
                                                                      try {
                                                                        await FirebaseAuth
                                                                            .instance
                                                                            .signInWithEmailAndPassword(
                                                                                email: userInfo.email,
                                                                                password: pass)
                                                                            .catchError((e) {
                                                                          okDialog(
                                                                            context,
                                                                            "Wrong Current Password",
                                                                            "You entered wrong password.",
                                                                          ).whenComplete(() =>
                                                                              Navigator.pop(context));
                                                                        }).then((value) async {
                                                                          await FirebaseAuth
                                                                              .instance
                                                                              .currentUser!
                                                                              .updatePassword(conpass)
                                                                              .whenComplete(() {
                                                                            okDialog(
                                                                              context,
                                                                              "Change Password Successfully",
                                                                              "You've successfully changed password.",
                                                                            ).whenComplete(() {
                                                                              Navigator.pushNamedAndRemoveUntil(context, '/dashboard/', (route) => false);
                                                                            });
                                                                          });
                                                                        }, onError: (e) {});
                                                                      } catch (e) {}
                                                                    } else if (newpass ==
                                                                        pass) {
                                                                      okDialog(
                                                                        context,
                                                                        "Repeated Password",
                                                                        "Your new password is exactly the same as current password.",
                                                                      ).whenComplete(() =>
                                                                          Navigator.pop(
                                                                              context));
                                                                    } else {
                                                                      okDialog(
                                                                        context,
                                                                        "Password Not Match",
                                                                        "Your new password doesn't match with confirm password.",
                                                                      ).whenComplete(() =>
                                                                          Navigator.pop(
                                                                              context));
                                                                    }
                                                                  } else {
                                                                    okDialog(
                                                                      context,
                                                                      "Empty Field",
                                                                      "Please fill all textfields.",
                                                                    ).whenComplete(() =>
                                                                        Navigator.pop(
                                                                            context));
                                                                  }
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                height: 60,
                child: ElevatedButton(
                  style: ForTealButton,
                  onPressed: () => Navigator.of(context).pushNamed(
                    // '/coop/loanview/',
                    //  '/coop/loantenureview',
                    '/user/wallet/',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.wallet,
                        color: Colors.white,
                        size: 16,
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4)),
                      Text(
                        'VIEW WALLET'.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: FontNamedDef,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10)), //foter
            ],
          ),
        ),
      ),
    ));
  }
}
