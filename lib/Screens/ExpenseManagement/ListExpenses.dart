
// ignore_for_file: prefer_const_constructors

import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_expense_application/Entity/Expense.dart';
import 'package:m_expense_application/Helper/SqlHelper.dart';
import 'package:m_expense_application/Screens/ExpenseManagement/AddExpense.dart';
import 'package:m_expense_application/Screens/ExpenseManagement/ViewExpense.dart';
import 'package:m_expense_application/Screens/TripManagement/ListTrips.dart';
import 'package:m_expense_application/main.dart';

class ListExpenses extends StatefulWidget {
  final int tripId;
  const ListExpenses({Key? key, required this.tripId}) : super(key: key);

  @override
  State<ListExpenses> createState() => _ListExpensesState();
}

class _ListExpensesState extends State<ListExpenses> {
  bool isShowDeleteOperation = false;
  bool isCheckDeleteAll = false;
  bool isSortByAmountDesc = false;
  bool isOpening = true;
  List<Expense> listDeletedExpense = [];

  List<Expense> listExpenses = [];
  List<Expense> allData = [];

  void loadData() async {
    final data = await SQLHelper.getExpensesByTrip(widget.tripId);
    setState(() {
      allData = data;
      listExpenses = data;
      isOpening = true;
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
        title: Text("List expenses"),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                viewListTrip();
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
                    // Text field để tìm kiếm
                    TextField(
                      onChanged: (value) {
                        searchExpense(value);
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          hintStyle: TextStyle(
                              fontSize: 16, color: Colors.grey.shade700),
                          hintText: "Search expenses",
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("List expenses (${listExpenses.length})"),
                            Padding(
                              padding: EdgeInsets.only(left: 100),
                              child: Row(
                                children: [
                                  Text("Amount"),
                                  // icon sort
                                  IconButton(
                                    onPressed: (() {
                                      setState(() {
                                        if (isSortByAmountDesc) {
                                          listExpenses.sort((a, b) => a
                                              .expenseAmount
                                              .compareTo(b.expenseAmount));
                                        } else {
                                          listExpenses.sort((a, b) => b
                                              .expenseAmount
                                              .compareTo(a.expenseAmount));
                                        }
                                        isSortByAmountDesc =
                                            !isSortByAmountDesc;
                                        isOpening = false;
                                      });
                                    }),
                                    icon: (() {
                                      if (isOpening) {
                                        return ImageIcon(
                                          AssetImage(
                                              "lib/assets/images/sort2.png"),
                                          size: 23,
                                        );
                                      } else if (!isSortByAmountDesc) {
                                        return Icon(
                                            Icons.arrow_downward_rounded);
                                      } else {
                                        return Icon(Icons.arrow_upward_rounded);
                                      }
                                    }()),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        // Delete operation (Checkbox check delete all, button delete và cancel) 
                        visible: isShowDeleteOperation,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 25),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Checkbox(
                                      // value cho checkbox,
                                      // true nếu list hiển thị và list delete giống nhau (2 list đều không rỗng)
                                      value: listExpenses.every((element) =>
                                              listDeletedExpense
                                                  .contains(element)) &&
                                          listDeletedExpense.isNotEmpty &&
                                          listExpenses.isNotEmpty,
                                      // Sự kiện cho checkbox,
                                      // Nếu checked thì gán list delete = list hiển thị, ngược lại thì rỗng
                                      onChanged: ((value) {
                                        setState(() {
                                          isCheckDeleteAll = value!;
                                          if (isCheckDeleteAll) {
                                            for (Expense expense
                                                in listExpenses) {
                                              listDeletedExpense.add(expense);
                                            }
                                          } else {
                                            listDeletedExpense = [];
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
                                          openDeleteExpenses();
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
                                            listDeletedExpense = [];
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
                      if (listExpenses.isEmpty) {
                        return Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 20),
                          child: Text("No data found"),
                        );
                      } else {
                        return Expanded(
                            child: Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: listExpenses.length,
                              itemBuilder: (contextcontext, index) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.white,
                                  margin: EdgeInsets.all(15),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: isShowDeleteOperation,
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Checkbox(
                                              value:
                                                  listDeletedExpense.contains(
                                                      listExpenses[index]),
                                              onChanged: (value) {
                                                setState(() {
                                                  if (!listDeletedExpense
                                                      .contains(listExpenses[
                                                          index])) {
                                                    listDeletedExpense.add(
                                                        listExpenses[index]);
                                                  } else {
                                                    listDeletedExpense.remove(
                                                        listExpenses[index]);
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            navigateToViewExpense(index);
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
                                                      "lib/assets/images/wallet.png"),
                                                  size: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                          title: Text(
                                            listExpenses[index].expenseType,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          subtitle: Text(
                                            "Date: ${listExpenses[index].expenseDate} \nTime: ${listExpenses[index].expenseTime}\nAmount: ${listExpenses[index].expenseAmount}",
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
          CircularMenuItem(
              icon: Icons.delete_sweep,
              color: Colors.green,
              onTap: () {
                setState(() {
                  isShowDeleteOperation = !isShowDeleteOperation;
                });
              }),
          CircularMenuItem(
              icon: Icons.cancel,
              color: Colors.orange,
              onTap: () {
                isShowDeleteOperation = false;
              }),
          CircularMenuItem(
              icon: Icons.add,
              color: Colors.blue,
              onTap: () {
                addExpense();
              }),
        ],
      ),
    );
  }

  void viewListTrip() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListTrips()));
  }

  void goHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void navigateToViewExpense(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewExpense(expense: listExpenses[index])));
  }

  // xử lý popup menu
  void handleOptionMenu(String value, int index) {
    switch (value) {
      case 'edit':
        {
          editExpense(index);
          break;
        }
      case 'delete':
        {
          openConfirmDeleteExpense(index);
          break;
        }
      default:
        {
          break;
        }
    }
  }

  void addExpense() {
    Expense expense = Expense.emptyExpense();
    expense.tripId = widget.tripId;
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditExpense(expense: expense)));
  }

  Future<int> deleteItem(int expenseId) async {
    return await SQLHelper.deleteExpense(expenseId);
  }

  void editExpense(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditExpense(expense: listExpenses[index])));
  }

  // search expenses
  void searchExpense(String searchText) {
    searchText = searchText.toLowerCase();
    List<Expense> temp = allData
        .where((element) =>
            element.expenseDate.toLowerCase().contains(searchText) ||
            element.expenseTime.toLowerCase().contains(searchText) ||
            element.expenseType.toLowerCase().contains(searchText) ||
            element.expenseComment.toLowerCase().contains(searchText))
        .toList();
    setState(() {
      listExpenses = temp;
    });
  }

  // confirm delete expense
  Future openConfirmDeleteExpense(int index) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text("Do you want to delete this expense?"),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () {
                  deleteExpense(index);
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

  // delete expense
  Future<void> deleteExpense(int index) async {
    String message = "";
    int result = await deleteItem(listExpenses[index].expenseId);
    if (result > 0) {
      message += "Delete expense success";
    } else {
      message += "Delete expense fail";
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    loadData();
  }

  // delete nhiều expenses
  Future<void> deleteExpenses() async {
    List<int> deletedIds = [];
    for (Expense expense in listDeletedExpense) {
      deletedIds.add(expense.expenseId);
    }
    int result = await SQLHelper.deleteExpenses(deletedIds);
    if (!mounted) return;
    setState(() {
      listDeletedExpense = [];
      isShowDeleteOperation = false;
      listExpenses
          .removeWhere((element) => deletedIds.contains(element.expenseId));
      allData.removeWhere((element) => deletedIds.contains(element.expenseId));
    });
    if (result > 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Delete expenses success")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Delete expenses fail")));
    }
  }

  // confirm delete expenses
  Future openDeleteExpenses() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text(
                "Do you want to delete ${listDeletedExpense.length} selected items?"),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () {
                  deleteExpenses();
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
}

