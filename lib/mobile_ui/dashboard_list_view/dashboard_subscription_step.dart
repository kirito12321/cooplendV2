import 'dart:io';
import 'package:ascoop/services/database/data_exception.dart';
import 'package:ascoop/services/database/data_service.dart';
import 'package:ascoop/services/database/data_subscription.dart';
import 'package:ascoop/services/database/data_user.dart';
import 'package:ascoop/style.dart';
import 'package:ascoop/utilities/show_error_dialog.dart';
import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../services/database/data_coop.dart';

class CoopSubscriptionStep extends StatefulWidget {
  final CoopInfo coop;
  final UserInfo user;
  const CoopSubscriptionStep({
    required this.user,
    required this.coop,
    super.key,
  });

  @override
  State<CoopSubscriptionStep> createState() => _CoopSubscriptionStepState();
}

class _CoopSubscriptionStepState extends State<CoopSubscriptionStep> {
  bool isCompleted = false;
  final profilePicFolder = 'Profile_Pic';
  final validIDFolder = 'ValidID';
  final picWithValidIDFolder = 'picWithId';
  int _currentStep = 0;
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  bool isUploaded = false;
  String? path;
  String? imageUrl;
  List<String> imageUrls = [];
  List<PlatformFile?> collectionPF = [];
  Future selectFile(String folderName) async {
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'gif', 'png']);
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
    uploadFile(folderName);
  }

  Future uploadFile(String folderName) async {
    if (pickedFile == null) {
      return;
    }
    path =
        '/users/${widget.user.userUID}/subscriptions/${widget.coop.coopID}/$folderName/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path!);

    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {
      setState(() {
        uploadTask = null;
        isUploaded = true;
      });
    });

    imageUrl = await snapshot.ref.getDownloadURL();
  }

  Future deleteUploadedFile() async {
    if (path == null) {
      return;
    }
    final ref = FirebaseStorage.instance.ref().child(path!);

    ref.delete();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: const Text(
          'Subscriber Application',
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
      body: Theme(
        data: ThemeData(
          canvasColor: Colors.teal[900],
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.teal[500],
                background: red8,
                secondary: Colors.white,
              ),
        ),
        child: isCompleted
            ? completingStep()
            : Center(
                child: Stepper(
                  type: StepperType.horizontal,
                  steps: getSteps(),
                  currentStep: _currentStep,
                  onStepContinue: () {
                    final isLastStep = _currentStep == 3;

                    if (isLastStep) {
                      if (imageUrls.length >= 3) {
                        try {
                          final subscribe = DataSubscription(
                            userId: widget.user.userUID,
                            userFirstName: widget.user.firstName,
                            userMiddleName: widget.user.middleName,
                            userLastName: widget.user.lastName,
                            gender: widget.user.gender,
                            birthdate: widget.user.birthDate,
                            userEmail: widget.user.email,
                            userAddress: widget.user.currentAddress,
                            userMobileNo: widget.user.mobileNo,
                            coopId: widget.coop.coopID,
                            profilePicUrl: imageUrls.elementAt(0),
                            validIdUrl: imageUrls.elementAt(1),
                            timestamp: Timestamp.now().toDate(),
                            selfiewithIdUrl: imageUrls.elementAt(2),
                            status: 'pending',
                          );
                          DataService.database()
                              .subscribe(subscribe: subscribe);

                          setState(() {
                            isCompleted = true;
                          });
                        } on SubscribeException catch (e) {
                          showErrorDialog(context, e.toString());
                        }
                      } else {
                        showErrorDialog(context, 'Please check previous step');
                      }
                    } else if (imageUrl != null && pickedFile != null) {
                      setState(() {
                        imageUrls.insert(_currentStep, imageUrl!);
                        collectionPF.insert(_currentStep, pickedFile!);
                        imageUrl = null;
                        pickedFile = null;
                        isUploaded = false;
                        _currentStep += 1;
                      });
                    } else {
                      setState(() {
                        _currentStep += 1;
                      });
                    }
                  },
                  onStepCancel: () {
                    _currentStep == 0
                        ? null
                        : setState(() {
                            _currentStep -= 1;
                          });
                  },
                  controlsBuilder: (context, details) {
                    final isLastStep = _currentStep == getSteps().length - 1;

                    return Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          _currentStep == 0
                              ? Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: SizedBox(
                                    width: screenWidth * 0.8,
                                    height: 45,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          backgroundColor:
                                              isUploaded || isLastStep
                                                  ? teal8
                                                  : Colors.grey[500]),
                                      onPressed: isUploaded || isLastStep
                                          ? details.onStepContinue
                                          : null,
                                      child: Text(
                                        isLastStep ? 'CONFIRM' : 'NEXT',
                                        style: btnLoginTxtStyle,
                                      ),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: SizedBox(
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: isUploaded || isLastStep
                                        ? details.onStepContinue
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        backgroundColor:
                                            isUploaded || isLastStep
                                                ? teal8
                                                : Colors.grey[500]),
                                    child: Text(
                                      isLastStep ? 'CONFIRM' : 'NEXT',
                                      style: btnLoginTxtStyle,
                                    ),
                                  ),
                                )),
                          const SizedBox(
                            width: 12,
                          ),
                          if (_currentStep != 0)
                            Expanded(
                                child: SizedBox(
                              height: 45,
                              child: ElevatedButton(
                                onPressed: details.onStepCancel,
                                style: ForRedButton,
                                child: const Text(
                                  'BACK',
                                  style: btnLoginTxtStyle,
                                ),
                              ),
                            ))
                        ],
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget completingStep() => Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'The subscription request has been sent',
                style: LoginTextStyle,
              ),
            ),
            buildSubBtn(widget.coop.coopID, widget.user.userUID)
          ],
        ),
      );

  Widget buildSubBtn(String coopID, String userID) => SizedBox(
        height: 50,
        width: 200,
        child: Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 32, 207, 208),
              shape: const StadiumBorder(),
            ),
            onPressed: () async {
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => SubscriptionReq(
              //             coopID: coopID,
              //             userID: userID,
              //           )),
              //   (route) => false,
              // );
              Navigator.pop(context, true);
            },
            child: const Text('Done'),
          ),
        ),
      );
  List<Step> getSteps() => [
        Step(
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 0,
            title: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '1st',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Please take a picture of your Self, and Send it here.'
                        .toUpperCase(),
                    style: h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                pickedFile == null
                    ? SizedBox(
                        height: 150,
                        width: 150,
                        child: Text(
                          'Please select your profile pic',
                          style: btnForgotTxtStyle,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        height: 200,
                        width: 200,
                        color: Colors.white,
                        child: Image.file(
                          File(pickedFile!.path!),
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                if (pickedFile != null) Text(getFileSze(pickedFile!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ForTealButton,
                        onPressed: () {
                          selectFile(profilePicFolder);

                          //  setState(() {
                          //    pickedFiles!.add(pickedFile!);
                          //    pickedFile = null;
                          //  });
                        },
                        child: const Text(
                          'Select Photo',
                          style: btnLoginTxtStyle,
                        )),
                    IconButton(
                        onPressed: () {
                          deleteUploadedFile();

                          setState(() {
                            path = null;
                            pickedFile = null;
                            if (imageUrls.isNotEmpty) {
                              imageUrls.removeAt(_currentStep);
                            }
                            if (collectionPF.isNotEmpty) {
                              collectionPF.removeAt(_currentStep);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          color: red8,
                        ))
                  ],
                ),
                buildUploadProgress(),
              ],
            )),
        Step(
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 1,
            title: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '2nd',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Please take a picture of your valid ID, and send it here'
                        .toUpperCase(),
                    style: h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                pickedFile == null
                    ? SizedBox(
                        height: 150,
                        width: 150,
                        child: Text(
                          'Please select your Valid ID',
                          style: btnForgotTxtStyle,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        height: 200,
                        width: 200,
                        color: Colors.white,
                        child: Image.file(
                          File(pickedFile!.path!),
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                if (pickedFile != null) Text(getFileSze(pickedFile!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ForTealButton,
                      onPressed: () {
                        selectFile(validIDFolder);
                        //  setState(() {
                        //    pickedFiles!.add(pickedFile!);
                        //    pickedFile = null;
                        //  });
                      },
                      child: const Text(
                        'Select Photo',
                        style: btnLoginTxtStyle,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          deleteUploadedFile();

                          setState(() {
                            path = null;
                            pickedFile = null;
                            if (imageUrls.isNotEmpty) {
                              imageUrls.removeAt(_currentStep);
                            }
                            if (collectionPF.isNotEmpty) {
                              collectionPF.removeAt(_currentStep);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          color: red8,
                        ))
                  ],
                ),
                buildUploadProgress(),
              ],
            )),
        Step(
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 2,
            title: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '3rd',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Please take a picture of you and your valid ID, and send it here'
                        .toUpperCase(),
                    style: h4,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                pickedFile == null
                    ? SizedBox(
                        height: 150,
                        width: 150,
                        child: Text(
                          'Please select your picture',
                          style: btnForgotTxtStyle,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(
                        height: 200,
                        width: 200,
                        color: Colors.white,
                        child: Image.file(
                          File(pickedFile!.path!),
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                if (pickedFile != null) Text(getFileSze(pickedFile!)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ForTealButton,
                      onPressed: () {
                        selectFile(picWithValidIDFolder);
                        //  setState(() {
                        //    pickedFiles!.add(pickedFile!);
                        //    pickedFile = null;
                        //  });
                      },
                      child: const Text(
                        'Select Photo',
                        style: btnLoginTxtStyle,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          deleteUploadedFile();

                          setState(() {
                            path = null;
                            pickedFile = null;
                            if (imageUrls.isNotEmpty) {
                              imageUrls.removeAt(_currentStep);
                            }
                            if (collectionPF.isNotEmpty) {
                              collectionPF.removeAt(_currentStep);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.delete_forever_outlined,
                          color: red8,
                        ))
                  ],
                ),
                buildUploadProgress(),
              ],
            )),
        Step(
            isActive: _currentStep >= 3,
            title: const FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'FINAL',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (imageUrls.length >= 3 && collectionPF.length >= 3)
                  fileView(imageUrls.elementAt(0), collectionPF.elementAt(0)!),
                if (imageUrls.length >= 3 && collectionPF.length >= 3)
                  fileView(imageUrls.elementAt(1), collectionPF.elementAt(1)!),
                if (imageUrls.length >= 3 && collectionPF.length >= 3)
                  fileView(imageUrls.elementAt(2), collectionPF.elementAt(2)!),
              ],
            )),
      ];
  Widget fileView(String url, PlatformFile picked) {
    return Column(children: [
      GestureDetector(
        onTap: () {},
        child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
                border: Border.all(width: 2.0, color: Colors.black38)),
            child: Image.network(url)),
      ),
      Text(
        picked.name,
        style: btnForgotTxtStyle1,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 6,
      ),
      Text(
        getFileSze(picked),
        style: btnForgotTxtStyle,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 15,
      ),
    ]);
  }

  Widget buildUploadProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!;
            double progress = data.bytesTransferred / data.totalBytes;
            return progressIndicator(progress);
          } else {
            return const SizedBox(
              height: 10,
            );
          }
        },
      );

  Widget progressIndicator(double progress) {
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

String getFileSze(PlatformFile pickedFile) {
  final kb = pickedFile.size / 1024;
  final mb = kb / 1024;
  final platformFileSize =
      mb >= 1 ? '${mb.toStringAsFixed(2)} MB' : '${kb.toStringAsFixed(2)}KB';

  return platformFileSize;
}
