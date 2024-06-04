
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m_expense_application/Entity/Expense.dart';
import 'package:m_expense_application/Helper/SqlHelper.dart';
import 'package:m_expense_application/Screens/ExpenseManagement/AddExpense.dart';
import 'package:m_expense_application/Screens/ExpenseManagement/ListExpenses.dart';
import 'package:m_expense_application/Widgets/CustomTextview.dart';
import 'package:m_expense_application/main.dart';

class ViewExpense extends StatefulWidget {
  final Expense expense;
  const ViewExpense({Key? key, required this.expense}) : super(key: key);

  @override
  State<ViewExpense> createState() => _ViewExpenseState();
}

class _ViewExpenseState extends State<ViewExpense> {
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
        title: Text("Expense detail"),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                viewListExpenses();
              },
              icon: Icon(Icons.arrow_back));
        }),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: IconButton(
                onPressed: () {
                  backToHome();
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
                  CustomTextView("Expense type", widget.expense.expenseType, 1),
                  CustomTextView("Expense date", widget.expense.expenseDate, 1),
                  CustomTextView("Expense time", widget.expense.expenseTime, 1),
                  CustomTextView("Expense amount",
                      widget.expense.expenseAmount.toString(), 1),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        height: 350,
                        padding: EdgeInsets.all(16.0),
                        margin: EdgeInsets.only(
                            top: 10, left: 16, right: 16, bottom: 10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.blue.shade500, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: (() {
                            if (widget.expense.expenseImage != "") {
                              return Image.file(
                                  File(widget.expense.expenseImage));
                            } else {
                              return Image.asset(
                                  'lib/assets/images/no-image-available.jpg');
                            }
                          }()),
                        ),
                      ),
                      Positioned(
                          left: 22,
                          top: 0,
                          child: Container(
                            padding:
                                EdgeInsets.only(bottom: 4, left: 8, right: 4),
                            color: Colors.white,
                            child: Text(
                              'Expense image',
                              style: TextStyle(
                                  color: Colors.blue.shade500, fontSize: 12),
                            ),
                          )),
                    ],
                  ),
                  CustomTextView(
                      "Incurred location", widget.expense.expenseLocation, 2),
                  CustomTextView(
                      "Expense comment", widget.expense.expenseComment, 3),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 65, right: 65),
                    child: MaterialButton(
                      color: Colors.blue.shade500,
                      onPressed: () {
                        navigateToEditExpense();
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
                        openConfirmDeleteExpense();
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

  Future<void> deleteExpense() async {
    int result = await SQLHelper.deleteExpense(widget.expense.expenseId);
    if (!mounted) return;
    if (result > 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully delete expense")));
      viewListExpenses();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Cannot delete expense")));
    }
  }

  Future openConfirmDeleteExpense() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text("Do you want to delete this expense?"),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () {
                  deleteExpense();
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

  void viewListExpenses() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListExpenses(tripId: widget.expense.tripId)));
  }

  void navigateToEditExpense() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditExpense(expense: widget.expense)));
  }

  void backToHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
}

