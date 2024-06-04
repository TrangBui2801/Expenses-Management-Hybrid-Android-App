
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_expense_application/Entity/TravelRoute.dart';
import 'package:m_expense_application/Entity/Trip.dart';
import 'package:m_expense_application/Helper/SqlHelper.dart';
import 'package:m_expense_application/Screens/ExpenseManagement/ListExpenses.dart';
import 'package:m_expense_application/Screens/TripManagement/AddTrip.dart';
import 'package:m_expense_application/Screens/TripManagement/ListTrips.dart';
import 'package:m_expense_application/Widgets/CustomTextview.dart';
import 'package:m_expense_application/main.dart';

class ViewTrip extends StatefulWidget {
  final Trip trip;
  const ViewTrip({Key? key, required this.trip}) : super(key: key);

  @override
  State<ViewTrip> createState() => _ViewTripState();
}

class _ViewTripState extends State<ViewTrip> {
  Future<void> loadTravelRoute() async {
    List<TravelRoute> routes = await SQLHelper.getRoutes(widget.trip.tripId);
    setState(() {
      widget.trip.tripRoute = routes;
    });
  }

  @override
  void initState() {
    loadTravelRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade500,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.blue.shade500,
        elevation: 0.0,
        toolbarHeight: 70,
        title: Text("Trip detail"),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                viewListTrips();
              },
              icon: Icon(Icons.arrow_back));
        }),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  goHome();
                },
                icon: Icon(Icons.home)),
          )
        ],
      ),
      body: Container(
        color: Colors.blue.shade500,
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  CustomTextView("Trip type", widget.trip.tripType, 1),
                  CustomTextView("Trip name", widget.trip.tripName, 1),
                  CustomTextView(
                      "Trip destination", widget.trip.tripDestination, 1),
                  CustomTextView(
                      "Trip start date", widget.trip.tripStartDate, 1),
                  CustomTextView("Trip end date", widget.trip.tripEndDate, 1),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        height: 220,
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blue.shade500, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: (() {
                          if (widget.trip.tripRoute.isEmpty) {
                            return Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(16.0),
                              child: Text("No data found"),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              alignment: Alignment.topCenter,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.trip.tripRoute.length,
                                itemBuilder: (context, index) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Colors.grey.shade300,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 5, right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ListTile(
                                        title: Text(
                                          widget.trip.tripRoute[index]
                                              .travelRouteDestination,
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        subtitle: Text(
                                          widget.trip.tripRoute[index]
                                              .travelRouteDate,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }()),
                      ),
                      Positioned(
                          left: 24,
                          top: 7,
                          child: Container(
                            padding:
                                EdgeInsets.only(bottom: 4, left: 8, right: 4),
                            color: Colors.white,
                            child: Text(
                              "Trip route",
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 12),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(height: 16),
                  CustomTextView(
                      "Transport type", widget.trip.tripTransportType, 1),
                  CustomTextView(
                      "Transport name", widget.trip.tripTransportName, 1),
                  CustomTextView(
                      "Risk assessment", widget.trip.tripRiskAssessment, 1),
                  CustomTextView(
                      "Trip description", widget.trip.tripDescription, 3),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 65, right: 65),
                    child: MaterialButton(
                      color: Colors.blue.shade500,
                      onPressed: () {
                        viewListExpenses();
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
                              minHeight:
                                  40.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.view_list,
                                    color: Colors.white,
                                  )),
                              Text('View expenses',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 65, right: 65),
                    child: MaterialButton(
                      color: Colors.blue.shade500,
                      onPressed: () {
                        editTrip();
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
                              minHeight:
                                  40.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  )),
                              Text('Edit',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 65, right: 65),
                    child: MaterialButton(
                      color: Colors.blue.shade500,
                      onPressed: () {
                        confirmDelete();
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
                              minHeight:
                                  40.0), // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )),
                              Text('Delete',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void editTrip() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddTrip(trip: widget.trip)));
  }

  void viewListExpenses() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListExpenses(tripId: widget.trip.tripId)));
  }

  void viewListTrips() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListTrips()));
  }

  void goHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future<void> deleteTrip() async {
    int result = await SQLHelper.deleteTrip(widget.trip.tripId);
    if (!mounted) return;
    if (result > 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully delete trip")));
      viewListTrips();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Cannot delete trip")));
    }
  }

  Future confirmDelete() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text("Do you want to delete this trip?"),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () {
                  deleteTrip();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Ink(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 80,
                        minHeight: 40.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            )),
                        Text('Yes',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Ink(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                  child: Container(
                    constraints: const BoxConstraints(
                        minWidth: 80,
                        minHeight: 40.0), // min sizes for Material buttons
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.cancel,
                              color: Colors.white,
                            )),
                        Text('No',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
}
