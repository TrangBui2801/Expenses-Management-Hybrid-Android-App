
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_expense_application/Entity/Trip.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:m_expense_application/Helper/SqlHelper.dart';
import 'package:m_expense_application/Screens/ExpenseManagement/ListExpenses.dart';
import 'package:m_expense_application/Constants/DropdownData.dart';
import 'package:m_expense_application/Screens/TripManagement/AddTrip.dart';
import 'package:m_expense_application/Screens/TripManagement/ViewTrip.dart';
import 'package:m_expense_application/main.dart';

class ListTrips extends StatefulWidget {
  const ListTrips({super.key});

  @override
  State<ListTrips> createState() => _ListTripstate();
}

class _ListTripstate extends State<ListTrips> {
  bool isShowDeleteOperation = false;
  bool isCheckDeleteAll = false;
  List<Trip> listDeletedTrip = [];

  List<Trip> listTrips = [];
  List<Trip> allData = [];

  void loadData() async {
    final data = await SQLHelper.getTrips();
    setState(() {
      allData = data;
      listTrips = data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
        title: Text("List trips"),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                goHome();
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
      body: CircularMenu(
        alignment: Alignment.bottomRight,
        backgroundWidget: Center(
          child: Container(
            color: Colors.blue.shade500,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) {
                        searchTrip(value);
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintStyle: TextStyle(
                              fontSize: 16, color: Colors.grey.shade700),
                          hintText: "Search trips",
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade500,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none)),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text("List trips (${listTrips.length})"),
                      ),
                    ),
                    Visibility(
                        visible: isShowDeleteOperation,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Checkbox( //checkbox delete all
                                      // value: kiểm tra toàn bộ phần tử của list trip (list đang hiển thị) có nằm trong list delete trip không
                                      // và 2 mảng đều k đc rỗng
                                      // onChanged: cập nhật state cho checkbox check delete all và list delete trip
                                      value: listTrips.every((element) =>
                                              listDeletedTrip
                                                  .contains(element)) &&
                                          listDeletedTrip.isNotEmpty &&
                                          listTrips.isNotEmpty,
                                      onChanged: ((value) {
                                        setState(() {
                                          isCheckDeleteAll = value!;
                                          if (isCheckDeleteAll) {
                                            for (Trip trip in listTrips) {
                                              listDeletedTrip.add(trip);
                                            }
                                          } else {
                                            listDeletedTrip = [];
                                          }
                                        });
                                      }))),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 75, top: 10),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 5),
                                      child: MaterialButton(
                                        color: Colors.blue.shade500,
                                        onPressed: () {
                                          openDeleteTrips();
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: Ink(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(80.0)),
                                          ),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                minWidth: 40,
                                                minHeight:
                                                    40.0), // min sizes for Material buttons
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: MaterialButton(
                                        color: Colors.blue.shade500,
                                        onPressed: () {
                                          setState(() {
                                            isShowDeleteOperation = false;
                                            listDeletedTrip = [];
                                          });
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: Ink(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(80.0)),
                                          ),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                minWidth: 40,
                                                minHeight:
                                                    40.0), // min sizes for Material buttons
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(
                                                      Icons.cancel,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                    (() {
                      if (listTrips.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 20),
                          child: Text("No data found"),
                        );
                      } else {
                        return Expanded(
                            child: Container(
                          alignment: Alignment.topCenter,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: listTrips.length,
                              itemBuilder: (context, index) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.white,
                                  margin: EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, top: 5, right: 10, bottom: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: isShowDeleteOperation,
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Checkbox(
                                              value: listDeletedTrip
                                                  .contains(listTrips[index]),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (!listDeletedTrip.contains(
                                                      listTrips[index])) {
                                                    listDeletedTrip
                                                        .add(listTrips[index]);
                                                  } else {
                                                    listDeletedTrip.remove(
                                                        listTrips[index]);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            viewTrip(listTrips[index]);
                                          },
                                          leading: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Transform.scale(
                                                scale: 2,
                                                alignment: Alignment.center,
                                                child: ImageIcon(
                                                  AssetImage(
                                                    (() {
                                                      if (listTrips[index]
                                                              .tripType ==
                                                          DropdownData
                                                                  .tripTypeData[
                                                              0]) {
                                                        return "lib/assets/images/conference.png";
                                                      } else if (listTrips[
                                                                  index]
                                                              .tripType ==
                                                          DropdownData
                                                                  .tripTypeData[
                                                              1]) {
                                                        return "lib/assets/images/client_meeting.png";
                                                      } else if (listTrips[
                                                                  index]
                                                              .tripType ==
                                                          DropdownData
                                                                  .tripTypeData[
                                                              2]) {
                                                        return "lib/assets/images/businesstravel_1.png";
                                                      } else {
                                                        return "lib/assets/images/travel_2.png";
                                                      }
                                                    }()),
                                                  ),
                                                  size: 24,
                                                ),
                                              )
                                            ],
                                          ),
                                          title: Text(
                                            listTrips[index].tripName,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            "Start: ${listTrips[index].tripStartDate}\nEnd :${listTrips[index].tripEndDate}\nTotal: ${listTrips[index].tripTotal}",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          trailing: SizedBox(
                                            width: 50,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  PopupMenuButton<String>(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    onSelected: (value) {
                                                      handleOptionMenu(
                                                          value, index);
                                                    },
                                                    itemBuilder: (context) {
                                                      return [
                                                        PopupMenuItem<String>(
                                                            value:
                                                                'view_expense',
                                                            child: ListTile(
                                                              leading: Icon(Icons
                                                                  .view_column_rounded), // your icon
                                                              title: Text(
                                                                  "View expenses"),
                                                            )),
                                                        PopupMenuDivider(),
                                                        PopupMenuItem<String>(
                                                            value: 'edit',
                                                            child: ListTile(
                                                              leading: Icon(Icons
                                                                  .edit), // your icon
                                                              title:
                                                                  Text("Edit"),
                                                            )),
                                                        PopupMenuDivider(),
                                                        PopupMenuItem<String>(
                                                          value: 'delete',
                                                          child: ListTile(
                                                            leading: Icon(Icons
                                                                .delete), // your icon
                                                            title:
                                                                Text("Delete"),
                                                          ),
                                                        )
                                                      ];
                                                    },
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))),
                        ));
                      }
                    }()),
                  ],
                ),
              ),
            ),
          ),
        ),
        toggleButtonColor: Colors.pink,
        items: [
          // khai báo và bắt sự kiện cho các button trong circular_menu
          CircularMenuItem(
              icon: Icons.delete_sweep,
              color: Colors.green,
              onTap: () {
                setState(() {
                  // show các button delete
                  isShowDeleteOperation = !isShowDeleteOperation;
                });
              }),
          CircularMenuItem(
              icon: Icons.cancel,
              color: Colors.orange,
              onTap: () {
                setState(() {
                  // ẩn các button delete
                  isShowDeleteOperation = false;
                });
              }),
          CircularMenuItem(
              icon: Icons.add,
              color: Colors.blue,
              onTap: () {
                // điều hướng sang màn Add
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTrip(trip: Trip.emptyTrip())));
              }),
        ],
      ),
    );
  }

  void editTrip(Trip trip) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddTrip(trip: trip)));
  }

  void viewTrip(Trip trip) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ViewTrip(trip: trip)));
  }

  void viewExpense(int tripId) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListExpenses(tripId: tripId)));
  }

  void deleteTrip(int tripId) async {
    String message = "";
    int result = await SQLHelper.deleteTrip(tripId);
    if (result > 0) {
      message += "Delete trip success";
    } else {
      message += "Delete trip fail";
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    loadData();
  }

  void goHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  // xử lý popup menu cho mỗi trip
  void handleOptionMenu(String value, int index) async {
    switch (value) {
      case "view_expense":
        {
          viewExpense(listTrips[index].tripId);
          break;
        }
      case "edit":
        {
          editTrip(listTrips[index]);
          break;
        }
      case "delete":
        {
          openConfirmDeleteTrip(listTrips[index].tripId);
          break;
        }
      default:
        {
          viewTrip(listTrips[index]);
          break;
        }
    }
  }

  // popup confirm delete trip, sử dụng hàm showDialog() có sẵn
  Future openConfirmDeleteTrip(int id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text("Do you want to delete this trip?"),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () {
                  deleteTrip(id);
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


  // xử lý delete trips
  Future<void> deleteTrips() async {
    // khởi tạo 1 mảng lưu các id của trip cần xóa 
    List<int> deletedIds = [];
    // lấy data từ list
    for (Trip trip in listDeletedTrip) {
      deletedIds.add(trip.tripId);
    }
    // gọi hàm deleteTrips()
    int result = await SQLHelper.deleteTrips(deletedIds);
    if (!mounted) return;
    // cập nhật và reload lại màn
    setState(() {
      listDeletedTrip = [];// cập nhật lại status cho checkbox
      isShowDeleteOperation = false; // ẩn checkbox, check delete all, các button delete vs cancel
      listTrips.removeWhere((element) => deletedIds.contains(element.tripId)); // xóa các trips đã chọn
      allData.removeWhere((element) => deletedIds.contains(element.tripId)); // xóa các trips đã chọn
    }); 
    if (result > 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Delete trips success")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Delete trips fail")));
    }
  }

  //popup confirm delete trips
  Future openDeleteTrips() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text(
                "Do you want to delete ${listDeletedTrip.length} selected items?"),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () {
                  deleteTrips();
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

  void searchTrip(String searchContent) {
    // convert chuỗi nhập vào sang dạng viết thường
    searchContent = searchContent.toLowerCase();
    // dùng lamda để search từ mảng lưu toàn bộ data
    List<Trip> searchResult = allData
        .where((element) =>
            element.tripType.toLowerCase().contains(searchContent) ||
            element.tripName.toLowerCase().contains(searchContent) ||
            element.tripDescription.toLowerCase().contains(searchContent) ||
            element.tripDestination.toLowerCase().contains(searchContent) ||
            element.tripTransportName.toLowerCase().contains(searchContent) ||
            element.tripTransportType.toLowerCase().contains(searchContent) ||
            element.tripStartDate.toLowerCase().contains(searchContent) ||
            element.tripEndDate.toLowerCase().contains(searchContent))
        .toList();
        // sort data dựa trên id
    searchResult.sort(((a, b) => a.tripId.compareTo(b.tripId)));
    // cập nhật data và reload màn
    setState(() {
      listTrips = searchResult;
    });
  }
}
