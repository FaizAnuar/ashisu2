import 'package:Ashisu/api/notification_api.dart';
import 'package:Ashisu/models/NotesPage.dart';
import 'package:Ashisu/models/timetablePage.dart';
import 'package:Ashisu/screens/notes_widget.dart';
import 'package:Ashisu/screens/sign_in.dart';
import 'package:Ashisu/screens/timetable.dart';
import 'package:Ashisu/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Ashisu/screens/calendar.dart';
import 'package:Ashisu/screens/profile.dart';
import 'package:Ashisu/services/auth.dart';
//import 'package:youtube/Service.dart';
//import 'package:youtube/info.dart';

class SelectPage extends StatefulWidget {
  @override
  _SelectPageState createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  FlutterLocalNotificationsPlugin localNotification;
  final usersRef = FirebaseFirestore.instance.collection('Users');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = '';

  get child => null;

  @override
  void initState() {
    super.initState();
    User user = _auth.currentUser;
    uid = user.uid;
    notesDescriptionMaxLenth =
        notesDescriptionMaxLines * notesDescriptionMaxLines;
    NotificationApi.init();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClikedNotification);

  void onClikedNotification(String payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Profile(),
      )); // MaterialPageRoute

  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser;
    uid = user.uid;
    print("this is user uid" + uid);
    return Scaffold(
      backgroundColor: Color(0xFFE0DFF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            icon: Icon(Icons.person, color: Color(0xFF5C0B68)),
            label: Text(
              'Log Out',
              style: TextStyle(color: Color(0xFF5C0B68)),
            ),
            onPressed: () async {
              await _auth.signOut();
              noteDescription.clear();
              noteHeading.clear();
              taskHeading.clear();
              taskDescription.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => SignIn()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: "ASH",
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        fontFamily: 'Bebas')),
                TextSpan(
                    text: "ISU",
                    style: TextStyle(
                        color: kPrimaryLightColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        fontFamily: 'Bebas')),
              ]),
            ),
            SizedBox(height: 30),
            FutureBuilder<DocumentSnapshot>(
              future: usersRef.doc(uid).get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data = snapshot.data.data();
                  return Text(
                      'Hi ' +
                          data['displayName'].toString() +
                          ', \nChoose your option to continue',
                      style: TextStyle(
                          fontFamily: 'Bebas',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C0B68)),
                      textAlign: TextAlign.center);
                }

                return Container(
                  color: Colors.transparent,
                  child: Center(
                    child: SpinKitChasingDots(
                      color: Color(0xffFFD119),
                      size: 50,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Image.asset(
              "assets/time.gif",
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            Container(),
            SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TimetablePage()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.schedule,
                              size: 45,
                              color: Colors.pink[700],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Timetable",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CalendarWidget()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              size: 45,
                              color: Colors.green[700],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Calendar",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotesWidget()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.notes,
                              size: 45,
                              color: Colors.blue[700],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Notes",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => NotificationApi.showNotification(
                        title: 'Topek Arthur',
                        body: 'rokok tang mat',
                        payload: 'topek.abs',
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.pink[100],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 100,
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.schedule,
                              size: 45,
                              color: Colors.pink[700],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Timetable",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Column(
                //   children: <Widget>[
                //     GestureDetector(
                //       onTap: () => NotificationApi.showScheduleNotification(
                //         title: 'Topek Arthur',
                //         body: 'rokok tang mat',
                //         payload: 'topek.abs',
                //         scheduleDate: DateTime.now().add(Duration(seconds: 12)),
                //       ),
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Colors.pink[100],
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         height: 100,
                //         width: 100,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: <Widget>[
                //             Icon(
                //               Icons.schedule,
                //               size: 45,
                //               color: Colors.pink[700],
                //             ),
                //             SizedBox(
                //               height: 5,
                //             ),
                //             Text(
                //               "Timetable",
                //               style: TextStyle(
                //                 fontSize: 15,
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.pink[700],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
