
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_expense_application/Constants/DropdownData.dart';
import 'package:m_expense_application/Entity/TravelRoute.dart';
import 'package:m_expense_application/Entity/Trip.dart';
import 'package:m_expense_application/Helper/SqlHelper.dart';
import 'package:m_expense_application/Screens/TripManagement/ListTrips.dart';
import 'package:m_expense_application/Widgets/CustomTextfield.dart';
import 'package:m_expense_application/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

class AddTrip extends StatefulWidget {
  // Tham số truyền vào khi navigate từ màn khác
  final Trip trip;
  // Hàm khởi tạo (required là các thuộc tính bắt buộc, VD: AddTrip(trip: Trip.newTrip()))
  const AddTrip({Key? key, required this.trip}) : super(key: key);

  @override
  State<AddTrip> createState() => _AddTripState();
}

class _AddTripState extends State<AddTrip> {
  // form key để validate data
  final _formKey = GlobalKey<FormState>();

  // Các biến để thao tác với screen
  String tripTypeDropdown = DropdownData.tripTypeData[0];
  TextEditingController tripNameController = TextEditingController();
  TextEditingController tripDestinationController = TextEditingController();
  TextEditingController tripStartDateController = TextEditingController();
  TextEditingController tripEndDateController = TextEditingController();
  String tripTransportTypeDropdown = DropdownData.transportTypeData[0];
  TextEditingController tripTrainsportNameController = TextEditingController();
  String riskAssessmentController = "No";
  TextEditingController tripDescriptionController = TextEditingController();
  List<TravelRoute> listTravelRoute = [];
  TextEditingController routeDestinationController = TextEditingController();
  TextEditingController routeDateController = TextEditingController();

  // Hàm để load data từ SQLite
  Future<void> loadData() async {
    List<TravelRoute> temp = [];
    if (widget.trip.tripId > 0) {
      temp = await SQLHelper.getRoutes(widget.trip.tripId);
    }
    setState(() {
      if (widget.trip.tripId > 0) {
        tripTypeDropdown = widget.trip.tripType;
        tripNameController.text = widget.trip.tripName;
        tripDestinationController.text = widget.trip.tripDestination;
        tripStartDateController.text = widget.trip.tripStartDate;
        tripEndDateController.text = widget.trip.tripEndDate;
        tripTransportTypeDropdown = widget.trip.tripTransportType;
        tripTrainsportNameController.text = widget.trip.tripTransportName;
        riskAssessmentController = widget.trip.tripRiskAssessment;
        tripDescriptionController.text = widget.trip.tripDescription;
        listTravelRoute = temp;
      } else {
        tripStartDateController.text =
            DateFormat('dd/MM/yyyy').format(DateTime.now());
        tripEndDateController.text =
            DateFormat('dd/MM/yyyy').format(DateTime.now());
      }
    });
  }

  @override
  // Hàm default, thực thi khi màn được load
  void initState() {
    loadData();
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
        title: (() {
          if (widget.trip.tripId > 0) {
            return Text("Edit trip");
          } else {
            return Text("Add trip");
          }
        }()),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 5, left: 15, right: 15, bottom: 10),
                          child: DropdownButtonFormField2(
                            value: tripTypeDropdown,
                            decoration: InputDecoration(
                              //Add isDense true and zero Padding.
                              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              //Add more decoration as you want here
                              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                            ),
                            isExpanded: true,
                            hint: const Text(
                              'Trip type',
                              style: TextStyle(fontSize: 14),
                            ),
                            barrierLabel: "Trip type",
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                            buttonHeight: 60,
                            buttonPadding:
                                const EdgeInsets.only(left: 15, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            items: DropdownData.tripTypeData
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Trip type cannot be blank.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                tripTypeDropdown = value!;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                tripTypeDropdown = value!;
                              });
                            },
                          ),
                        ),
                        Positioned(
                            left: 24,
                            top: 0,
                            child: Container(
                              padding:
                                  EdgeInsets.only(bottom: 5, left: 5, right: 5),
                              color: Colors.white,
                              child: Text(
                                "Trip type",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                            )),
                      ],
                    ),
                    CustomTextField("Trip name", "Trip name",
                        tripNameController, false, 1, true),
                    CustomTextField("Trip destination", "Trip destination",
                        tripDestinationController, false, 2, true),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: TextField(
                        controller: tripStartDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Start date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        onTap: () async {
                          // popup datepicker cho ngày bắt đầu
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  1900), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);

                            setState(() {
                              tripStartDateController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: TextField(
                        controller: tripEndDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "End date",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        onTap: () async {
                          // popup datepicker cho ngày kết thúc
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  1900), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(pickedDate);

                            setState(() {
                              tripEndDateController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                      ),
                    ),
                    Stack(
                      // List view cho travel route của trip
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: 220,
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(top: 10, left: 16, right: 16),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 51, 204, 255),
                                width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: (() {
                            // Kiểm tra list travelroute trong database có tồn tại bản ghi
                            if (listTravelRoute.isEmpty) {
                              return Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(top: 20),
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
                                  itemCount: listTravelRoute.length,
                                  itemBuilder: (context, index) => Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.grey.shade300,
                                    margin: EdgeInsets.only(
                                        top: 10, left: 5, right: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        // Hiển thị từng travel route
                                        ListTile(
                                          title: Text(
                                            listTravelRoute[index]
                                                .travelRouteDestination,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            listTravelRoute[index]
                                                .travelRouteDate,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          trailing: IconButton(
                                            icon: Icon(Icons.cancel_outlined),
                                            onPressed: () {
                                              // Chỉ cập nhật trên view mà chưa xóa trong database
                                              // list sẽ được cập nhật khi ấn button Add/Update
                                              setState(() {
                                                listTravelRoute.removeAt(index);
                                              });
                                            },
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
                                  EdgeInsets.only(bottom: 5, left: 5, right: 5),
                              color: Colors.white,
                              child: Text(
                                "Trip route",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                            )),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 170, right: 20, top: 10, bottom: 10),
                        child: MaterialButton(
                          color: Colors.blue.shade500,
                          onPressed: () {
                            openDialogAddRoute();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          padding: EdgeInsets.zero,
                          child: Ink(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
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
                                        Icons.alt_route,
                                        color: Colors.white,
                                      )),
                                  Text('Add route',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 5, left: 15, right: 15, bottom: 10),
                          child: DropdownButtonFormField2(
                            value: tripTransportTypeDropdown,
                            decoration: InputDecoration(
                              //Add isDense true and zero Padding.
                              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              //Add more decoration as you want here
                              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                            ),
                            isExpanded: true,
                            hint: const Text(
                              'Transport type',
                              style: TextStyle(fontSize: 14),
                            ),
                            barrierLabel: "Transport type",
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.black45,
                            ),
                            iconSize: 30,
                            buttonHeight: 60,
                            buttonPadding:
                                const EdgeInsets.only(left: 15, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            items: DropdownData.transportTypeData
                                .map((item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Transport type cannot be blank.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                tripTransportTypeDropdown = value!;
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                tripTransportTypeDropdown = value!;
                              });
                            },
                          ),
                        ),
                        Positioned(
                            left: 24,
                            top: 0,
                            child: Container(
                              padding:
                                  EdgeInsets.only(bottom: 5, left: 5, right: 5),
                              color: Colors.white,
                              child: Text(
                                "Transport type",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                            )),
                      ],
                    ),
                    CustomTextField("Transport name", "Transport name",
                        tripTrainsportNameController, false, 1, true),
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          padding: EdgeInsets.only(
                              top: 16.0, left: 16.0, bottom: 16.0, right: 32.0),
                          margin: EdgeInsets.only(
                              top: 10, left: 16, right: 16, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromARGB(255, 51, 204, 255),
                                width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Required risk assessment:       "),
                                Transform.scale(
                                    scale: 2,
                                    child: Switch(
                                      onChanged: (value) {
                                        String swtValue = "";
                                        if (value) {
                                          swtValue += "YES";
                                        } else {
                                          swtValue += "NO";
                                        }
                                        setState(() {
                                          riskAssessmentController = swtValue;
                                        });
                                      },
                                      value: (() {
                                        return riskAssessmentController ==
                                            "YES";
                                      }()),
                                      activeColor: Colors.blue.shade500,
                                      activeTrackColor: Colors.grey.shade300,
                                      inactiveThumbColor: Colors.grey.shade400,
                                      inactiveTrackColor: Colors.grey.shade100,
                                    )),
                              ]),
                        ),
                        Positioned(
                            left: 22,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.only(
                                  bottom: 10, left: 10, right: 10),
                              color: Colors.white,
                              child: Text(
                                "Risk assessment",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              ),
                            )),
                      ],
                    ),
                    CustomTextField("Trip description", "Trip description",
                        tripDescriptionController, false, 3, false),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 65, right: 65),
                      child: MaterialButton(
                        color: Colors.blue.shade500,
                        onPressed: () {
                          insertOrUpdate();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: EdgeInsets.zero,
                        child: Ink(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
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
                                    child: (() {
                                      if (widget.trip.tripId > 0) {
                                        return Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        );
                                      } else {
                                        return Icon(
                                          Icons.add_box,
                                          color: Colors.white,
                                        );
                                      }
                                    } ())),
                                Text(
                                    (() {
                                      if (widget.trip.tripId > 0) {
                                        return "Update";
                                      } else {
                                        return "Add";
                                      }
                                    }()),
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 65, right: 65),
                      child: MaterialButton(
                        color: Colors.blue.shade500,
                        onPressed: () {
                          cancelUpdate();
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        padding: EdgeInsets.zero,
                        child: Ink(
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
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
                                      Icons.cancel,
                                      color: Colors.white,
                                    )),
                                Text('Cancel',
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
      ),
    );
  }

  // Hiển thị dialog add new route cho trip
  Future openDialogAddRoute() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Add route"),
            content: SingleChildScrollView(
              child: Column(children: [
                CustomTextField("Destination", "Destination",
                    routeDestinationController, false, 1, true),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: routeDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Date",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              1900), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));
                      if (pickedDate != null) {
                        //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(pickedDate);

                        setState(() {
                          routeDateController.text =
                              formattedDate; //set output date to TextField value.
                        });
                      }
                    },
                  ),
                ),
              ]),
            ),
            actions: [
              // khai báo và bắt sự kiện cho các button trong dialog
              Container(
                padding: EdgeInsets.symmetric(horizontal: 70),
                child: MaterialButton(
                  color: Colors.blue.shade500,
                  onPressed: () {
                    // Chỉ cập nhật mảng list route trong view mà chưa insert,
                    // List sẽ insert khi ấn button Add/Update(Gọi hàm insertOrUpdate hay addTrip trong SQLHelper)
                    String newRouteDestination =
                        routeDestinationController.text;
                    String newRouteDate = routeDateController.text;
                    TravelRoute newRoute = TravelRoute.newRoute(
                        0, newRouteDate, newRouteDestination);
                    setState(() {
                      listTravelRoute.add(newRoute);
                      routeDestinationController.text = "";
                      routeDateController.text = "";
                    });
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
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 70),
                child: MaterialButton(
                  color: Colors.blue.shade500,
                  onPressed: () {
                    routeDestinationController.text = "";
                    routeDateController.text = "";
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
              )
            ],
          ));

  void viewListTrips() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListTrips()));
  }

  void goHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future<bool> updateTrip(Trip trip) async {
    int result = await SQLHelper.updateTrip(trip);
    return result > 0;
  }

  Future<bool> insertTrip(Trip trip) async {
    int result = await SQLHelper.addTrip(trip);
    return result > 0;
  }

  Future<void> insertOrUpdate() async {
    if (_formKey.currentState!.validate()) {
      String tripType = tripTypeDropdown;
      String tripName = tripNameController.text;
      String tripDestination = tripDestinationController.text;
      String tripStartDate = tripStartDateController.text;
      String tripEndDate = tripEndDateController.text;
      String tripTransportType = tripTransportTypeDropdown;
      String tripTransportName = tripTrainsportNameController.text;
      String riskAssessment = riskAssessmentController;
      String tripDescription = tripDestinationController.text;
      Trip data = Trip.newTrip(
          tripType,
          tripName,
          tripDestination,
          tripStartDate,
          tripEndDate,
          tripTransportType,
          tripTransportName,
          listTravelRoute,
          riskAssessment,
          tripDescription);

      if (widget.trip.tripId > 0) {
        data.tripId = widget.trip.tripId;
        confirmUpdate(data);
      } else {
        bool result = await insertTrip(data);
        if (!mounted) return;
        if (result) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Add new trip success")));
          viewListTrips();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Add new trip fail")));
        }
      }
    }
  }


  Future confirmUpdate(Trip trip) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text("Do you want to update this trip?"),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () async {
                  bool result = await updateTrip(trip);
                  if (!mounted) return;
                  if (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Update trip success")));
                    viewListTrips();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Update trip fail")));
                  }
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

  Future cancelUpdate() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: (() {
              if (widget.trip.tripId > 0) {
                return Text("Do you want to cancel updating this trip?");
              } else {
                return Text("Do you want to cancel inserting new trip?");
              }
            }()),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () async {
                  viewListTrips();
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
                        Text('OK',
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
                        Text('Cancel',
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
