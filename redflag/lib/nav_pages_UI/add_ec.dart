import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redflag/Emergency.dart';
import 'package:redflag/Users.dart';
import 'package:redflag/registration_pages/login_screen.dart';
import 'package:redflag/EmergencyContacts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class add extends StatefulWidget {
  const add({Key? key}) : super(key: key);

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  final emergencyContactNameEditingController = new TextEditingController();
  final emergencyContactEmailEditingController = new TextEditingController();
  String? name;
  String? email;
  User? user = FirebaseAuth.instance.currentUser;
  Users loggedInUser = Users();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = Users.fromMap(value.data());
      setState(() {});
    });
  }

/**
 In submitData() the data will be sent to the firestore.
 */
  submitData() async {
    EmergencyContacts emergencyContactModel = EmergencyContacts();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//emergency contact
    emergencyContactModel.eFullName =
        emergencyContactNameEditingController.text;
    emergencyContactModel.ecEmail = emergencyContactEmailEditingController.text;

    //add to the emergencycontact array in the user object
    loggedInUser.emergencyContacts.add(emergencyContactModel);

    name = emergencyContactNameEditingController.text;
    email = emergencyContactEmailEditingController.text;

    if (name != "" || email != "") {
      //firestore add emergency contact information
      await firebaseFirestore
          .collection("emergencyContacts")
          .doc()
          .set(emergencyContactModel.toMap(user!.uid));

      Fluttertoast.showToast(msg: "Emergency contact added successfully :) ");

      //----------------------------------------
      // Send an email to the emergency contact
      Emergency mail = new Emergency();
      String subject =
          'You have been added as an Emergency Contact :: Redflag Team';
      String ecName = emergencyContactNameEditingController.text;
      String userFirstName = loggedInUser.getUserFirstName;
      String userLastName = loggedInUser.getUserLastName;
      // String recipients = emergencyContactEmailEditingController.text;
      final recipients = <dynamic>[email];

      String msg =
          '<h1>Hello, $ecName </h1>\n<p><strong>$userFirstName $userLastName </strong>has added you as an emergency contact.\n</p><p>If there is an emergency, the Redflag team will send you the location of <strong>$userFirstName</strong>.</p>\n<br>\<br>\n<br>\n<br>\n<br>\n<hr>\n<p style="color:#6c63ff; font-family:Arial, Helvetica, sans-serif; font-size:18px;";><strong>Atheer Alghamdi</strong></p>\<p style="font-family:Arial, Helvetica, sans-serif; font-size:15px;"><strong>Redflag Developer | IT Department </strong></p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Email: redflagapp.8@gmail.com</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Adress: King Abdulaziz University | FCIT</p>\n<p style="font-family:Arial, Helvetica, sans-serif; font-size:12px;">Websit: <a href="https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php">https://fcitweb.kau.edu.sa/fcitwebsite/itdepartment.php</a></p>\n<br>\n<br>';
      mail.sendMail(recipients, subject, msg);

      //----------------------------------------
      clearData();
    }

    // setState(() {});
  }

/**
 In clearData() the textfields will be cleared.
 */
  clearData() {
    emergencyContactNameEditingController.clear();
    emergencyContactEmailEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    //emergency contact name field
    final emergencyContactNameField = TextFormField(
        autofocus: false,
        controller: emergencyContactNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Emergency Contact Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          emergencyContactNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Emergency Contact Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //emergency contact email field
    final emergencyContactEmailField = TextFormField(
        autofocus: false,
        controller: emergencyContactEmailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emergencyContactEmailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    return Container(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          body: Stack(
            children: [
//------------------------------------ App Bar ----------------------------------------

              Container(
                height: 250,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(30)),
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 122, 122, 243),
                      Color(0xFF4E4EF7)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              ),

//------------------------------------ User info ----------------------------------------

              Container(
                padding: EdgeInsets.only(top: 80, left: 120),
                child: Column(
                  children: [
                    //child 1 --> avatar
                    CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    //child 2 --> for space between the avatar and user data
                    SizedBox(
                      height: 20,
                    ),
//----------------//child 3 --> user data
                    Column(
                      children: [
                        Text(
                          '${loggedInUser.getUserFirstName} ${loggedInUser.getUserLastName}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                        Text(
                          '${loggedInUser.getEmail}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
//------------------------------------Logout------------------------------------

              Container(
                padding: EdgeInsets.only(top: 80, left: 15),
                child: TextButton(
                  onPressed: () {
                    logout(context);
                  },
                  child: Text('Logout',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 245, 245, 245),
                      )),
                ),
              ),

//------------------------------------ Current Emergency Contacts List ----------------------------------------

              Column(
                children: [
                  SizedBox(
                    height: 300,
                  ),
                  Align(
                    // to force it to stay in the left then will control it with th margin, if i remove it, it will go the center and the margin can't move it
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.only(left: 35),
                      child: Text('Add Emergency \nContacts ',
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0xFF4E4EF7),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 35, right: 35),
                    child: Column(
                      children: [
                        emergencyContactNameField,
                        SizedBox(height: 20),
                        emergencyContactEmailField,
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
//-----------------------------------  Buttons ---------------------------------------

                  Container(
                    alignment: FractionalOffset.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // space between the buttons
                      children: [
//----------------------------------- Add Button ---------------------------------------

                        ElevatedButton(
                          onPressed: submitData,
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF4E4EF7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15, bottom: 15),
                            child: Text('Add',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255))),
                          ),
                        ),

//----------------------------------- Clear Button -----------------------------------------
                        ElevatedButton(
                          onPressed: clearData,
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 167, 167, 167),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 25, right: 25, top: 15, bottom: 15),
                            child: Text(
                              'Clear',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
