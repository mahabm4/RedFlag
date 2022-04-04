import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redflag/Users.dart';

class profilePage extends StatefulWidget {
  const profilePage({Key? key}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
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

  @override
  Widget build(BuildContext context) {
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

              Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 80, left: 80),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Color.fromARGB(255, 255, 255, 255),
                          ),
                          Container(
                            margin: EdgeInsets.all(15.0),
                            child: Column(
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
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
              SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 210,
                    ),

//------------------------------------ Dispaly the number of Emergency Contacts for the user ----------------------------------------
                    Container(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 22, bottom: 22),
                      // margin: EdgeInsets.only(left: 100),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        // boxShadow: shadowList,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(170, 188, 188, 188)
                                .withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Text('3',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6666FF))),
                    ),
                    SizedBox(
                      height: 17,
                    ),
                    Text('Emergency \nContatcs.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),

                    SizedBox(
                      height: 40,
                    ),

//------------------------------------ Current Emergency Contacts List ----------------------------------------
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 35),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Current Emergency Contacts ',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Text('Show All',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color.fromARGB(255, 0, 181, 253),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
