import 'package:ascoop/services/auth/auth_exception.dart';
import 'package:ascoop/services/auth/auth_service.dart';
import 'package:ascoop/utilities/show_alert_dialog.dart';
import 'package:ascoop/utilities/show_error_dialog.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/inputstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool _aggrement = false;
  bool _isObscure = true;
  bool _isObscureC = true;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _firstName;
  late final TextEditingController _middleName;
  late final TextEditingController _lastName;
  late final TextEditingController _cpassword;
  late final TextEditingController _mobileNo;
  late final TextEditingController _currentAddress;

  final genderSelection = ['Male', 'Female'];
  String? genderValue;
  DateTime _birthdate = DateTime.now();

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _middleName = TextEditingController();
    _lastName = TextEditingController();
    _cpassword = TextEditingController();
    _mobileNo = TextEditingController();
    _currentAddress = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _middleName.dispose();
    _lastName.dispose();
    _cpassword.dispose();
    _mobileNo.dispose();
    _currentAddress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0.7,
      //   title: Text(
      //     'Register',
      //     style: const TextStyle(
      //       fontFamily: FontNameDefault,
      //       fontSize: 16,
      //       fontWeight: FontWeight.w600,
      //       color: Colors.black,
      //     ),
      //   ),
      //   leading: InkWell(
      //     hoverColor: Colors.white,
      //     splashColor: Colors.white,
      //     highlightColor: Colors.white,
      //     onTap: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Icon(
      //       Icons.arrow_back,
      //       size: 25,
      //       color: Colors.black,
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Container(
              child: Center(
                child: Container(
                  width: registrationContainer(screenWidth),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 70.0, 0, 60.0),
                        child: Center(
                            child: Text(
                          'CREATE AN ACCOUNT',
                          style: h1,
                        )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'First Name',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: TextFormField(
                            style: inputTextStyle1,
                            controller: _firstName,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                      color: Colors.teal[800], Icons.person),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Middle Name',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: TextFormField(
                            style: inputTextStyle1,
                            controller: _middleName,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                      color: Colors.teal[800], Icons.person),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Last Name',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: TextFormField(
                            style: inputTextStyle1,
                            controller: _lastName,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                      color: Colors.teal[800], Icons.person),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Email Address',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: TextFormField(
                            style: inputTextStyle1,
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                      color: Colors.teal[800], Icons.email),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Gender',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                        child: SizedBox(
                          height: 55,
                          child: InputDecorator(
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                isDense: true,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: genderValue == 'Male'
                                      ? Icon(
                                          color: Colors.teal[800],
                                          Icons.male_outlined)
                                      : Icon(
                                          color: Colors.teal[800],
                                          Icons.female_outlined),
                                )),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                  items: genderSelection.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: inputTextStyle1,
                                      ),
                                    );
                                  }).toList(),
                                  value: genderValue,
                                  isDense: true,
                                  iconSize: 24,
                                  icon: Icon(
                                      color: Colors.teal[800],
                                      Icons.arrow_drop_down),
                                  isExpanded: true,
                                  onChanged: (value) =>
                                      setState(() => genderValue = value)),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Mobile number',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: TextFormField(
                            style: inputTextStyle1,
                            controller: _mobileNo,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child:
                                      Icon(color: Colors.teal[800], Icons.pin),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Birthdate',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: TextFormField(
                            style: inputTextStyle1,
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
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                      color: Colors.teal[800],
                                      Icons.calendar_month_outlined),
                                ),
                                hintText: DateFormat('MMM d, yyyy')
                                    .format(_birthdate),
                                isDense: true,
                                contentPadding: const EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Current Address',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: TextFormField(
                            style: inputTextStyle1,
                            controller: _currentAddress,
                            keyboardType: TextInputType.streetAddress,
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child: Icon(
                                      color: Colors.teal[800],
                                      Icons.location_pin),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                          child: TextFormField(
                            style: inputTextStyle1,
                            obscureText: _isObscure,
                            controller: _password,
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child:
                                      Icon(color: Colors.teal[800], Icons.lock),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isObscure = !_isObscure;
                                      });
                                    },
                                    icon: Icon(
                                        color: Colors.teal[800],
                                        _isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                isDense: true,
                                contentPadding: const EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50, bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm Password',
                              style: btnForgotTxtStyle,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: TextFormField(
                            style: inputTextStyle1,
                            obscureText: _isObscureC,
                            controller: _cpassword,
                            decoration: InputDecoration(
                                hintStyle: inputHintTxtStyle,
                                focusedBorder: focusOutlineBorder,
                                border: OutlineBorder,
                                prefixIcon: Align(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  child:
                                      Icon(color: Colors.teal[800], Icons.lock),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isObscureC = !_isObscureC;
                                      });
                                    },
                                    icon: Icon(
                                        color: Colors.teal[800],
                                        _isObscureC
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                isDense: true,
                                contentPadding: const EdgeInsets.all(8)),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              activeColor: Colors.teal[500],
                              value: _aggrement,
                              onChanged: (bool? value) {
                                setState(() {
                                  _aggrement = value!;
                                });
                              }),
                          SizedBox(
                              width: 250,
                              child: Text(
                                "By checking Register, you are agreeing to our Privacy and Term of use.",
                                style: btnForgotTxtStyle,
                              ))
                        ],
                      ),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: 350,
                        height: 65,
                        child: ElevatedButton(
                          style: ForTealButton,
                          onPressed: () async {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  content: onWait),
                            );

                            if (_aggrement != true) {
                              okDialog(context, 'Registration Failed',
                                      'Please agree to our terms and condition before registering an acount.')
                                  .whenComplete(() => Navigator.pop(context));
                            } else {
                              final email = _email.text;
                              final password = _password.text;
                              final firstName = _firstName.text;
                              final middleName = _middleName.text;
                              final lastName = _lastName.text;
                              final gender = genderValue ?? 'male';
                              final mobileNo = _mobileNo.text;
                              final birthDate = _birthdate;
                              final currenAddress = _currentAddress.text;
                              try {
                                await AuthService.firebase().createUser(
                                  email: email,
                                  password: password,
                                  firstName: firstName,
                                  middleName: middleName,
                                  lastName: lastName,
                                  gender: gender,
                                  mobileNo: mobileNo,
                                  birthDate: birthDate,
                                  currentAddress: currenAddress,
                                );

                                //after this line we should proceed in verification view instead of login view
                                AuthService.firebase()
                                    .sendEmailVerification()
                                    .then((value) => okDialog(
                                            context,
                                            'Registration Successfully',
                                            'Registration Complete. You can now login your account.')
                                        .then((value) => Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/login/', (route) => false)));
                                // ignore: use_build_context_synchronously
                              } on WeakPasswordAuthException {
                                okDialog(context, 'Registration Failed',
                                        'Weak Password.')
                                    .whenComplete(() => Navigator.pop(context));
                              } on EmailAlreadyInUseAuthException {
                                okDialog(context, 'Registration Failed',
                                        'Email is already in used.')
                                    .whenComplete(() => Navigator.pop(context));
                              } on InvalidEmailAuthException {
                                okDialog(context, 'Registration Failed',
                                        'Invalid Email Address.')
                                    .whenComplete(() => Navigator.pop(context));
                              } on GenericAuthException {
                                okDialog(context, 'Something Wrong',
                                        'Unexpected error. Please try again later.')
                                    .whenComplete(() => Navigator.pop(context));
                                ;
                              }
                            } //else statement
                          },
                          child: const Text(
                            'REGISTER',
                            style: btnLoginTxtStyle,
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
      ),
    );
  }
}

double registrationContainer(double screenWidth) {
  if (screenWidth > 480.0) {
    return 480.0;
  } else {
    return screenWidth;
  }
}
