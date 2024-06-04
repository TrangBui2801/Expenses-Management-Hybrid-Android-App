// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_expense_application/Navigation/Routes.dart';
import 'package:m_expense_application/Screens/TripManagement/ListTrips.dart';
import 'package:m_expense_application/Widgets/WaveWidget.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Cosmic Sans MS'),
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Cosmic Sans MS'),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.blue.shade500,
            elevation: 0.0,
            toolbarHeight: 65,
            centerTitle: true,
          ),
          body: Column(
            children: <Widget>[
              ClipPath(
                clipper: WaveWidget(),
                child: Container(
                    padding: EdgeInsets.only(bottom: 50),
                    color: Colors.blue.shade500,
                    height: 230,
                    alignment: Alignment.center,
                    child: Text(
                      "EXPENSE MANAGEMENT",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    )),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                margin: EdgeInsets.only(left: 65, right: 65),
                child: MaterialButton(
                  color: Colors.blue.shade500,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListTrips()));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  padding: EdgeInsets.zero,
                  child: Ink(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(80.0)),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                          minHeight: 40.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                              )),
                          Text('View Data',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.only(left: 65, right: 65),
                  child: MaterialButton(
                      color: Colors.blue.shade500,
                      onPressed: () {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      padding: EdgeInsets.zero,
                      child: Ink(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(80.0)),
                        ),
                        child: Container(
                          constraints: const BoxConstraints(
                              minHeight:
                                  40.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.cloud_upload,
                                    color: Colors.white,
                                  )),
                              Text('Upload Data',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ],
                          ),
                        ),
                      )))
            ],
          )),
      initialRoute: RouteNames.home,
      routes: routes,
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (_) => const Home()),
    );
  }
}
