
// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:m_expense_application/Constants/DropdownData.dart';
import 'package:m_expense_application/Entity/Expense.dart';
import 'package:m_expense_application/Helper/SqlHelper.dart';
import 'package:m_expense_application/Screens/ExpenseManagement/ListExpenses.dart';
import 'package:m_expense_application/Widgets/CustomTextfield.dart';
import 'package:m_expense_application/main.dart';
import 'package:path_provider/path_provider.dart';

class EditExpense extends StatefulWidget {
  final Expense expense;
  const EditExpense({Key? key, required this.expense}) : super(key: key);

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final _formKey = GlobalKey<FormState>();

  String screenTitle = "";

  bool isShowOther = false;
  String expenseTypeDropdown = DropdownData.expenseType[0];
  TextEditingController expenseOtherTypeController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController expenseDateController = TextEditingController();
  TextEditingController expenseTimeController = TextEditingController();
  String expenseImageURL = "";
  String expenseLocation = "";
  TimeOfDay timeOfDay = TimeOfDay.now();
  TextEditingController expenseCommentController = TextEditingController();

  String confirmCancelDialogContent = "";

  // Biến để thao tác với ảnh trong điện thoại (gallery hoặc camera)
  ImagePicker picker = ImagePicker();
  // Biến để lưu file ảnh
  File? image;
  // Biển để lưu vị trí (location)
  Position? location;

  void loadLocation() async {
    // Kiểm tra service, permission và get location
    Position data = await getLocation();
    setState(() {
      location = data;
    });
  }

  void loadExpenses() {
    // Get data để cập nhật trạng thái cho các phần tử trong màn
    setState(() {
      if (widget.expense.expenseId > 0) {
        if (DropdownData.expenseType.contains(widget.expense.expenseType) &&
            widget.expense.expenseType != DropdownData.expenseType[2]) {
          expenseTypeDropdown = widget.expense.expenseType;
          isShowOther = false;
        } else {
          expenseTypeDropdown = DropdownData.expenseType[2];
          expenseOtherTypeController.text = widget.expense.expenseType;
          isShowOther = true;
        }
        expenseAmountController.text = widget.expense.expenseAmount.toString();
        expenseDateController.text = widget.expense.expenseDate;
        expenseTimeController.text = widget.expense.expenseTime;
        expenseCommentController.text = widget.expense.expenseComment;
        expenseImageURL = widget.expense.expenseImage;
        screenTitle = "Edit expense";
        confirmCancelDialogContent =
            "Do you want to cancel updating this trip?";
      } else {
        confirmCancelDialogContent = "Do you want to cancel adding new trip?";
        screenTitle = "Add expense";
      }
    });
  }

  @override
  void initState() {
    loadLocation();
    loadExpenses();
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
        title: Text(screenTitle),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                viewListExpense();
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
                            value: expenseTypeDropdown,
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
                                const EdgeInsets.only(left: 20, right: 10),
                            dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            items: DropdownData.expenseType
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
                                return 'ExpenseType type cannot be blank.';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                expenseTypeDropdown = value!;
                                if (expenseTypeDropdown ==
                                    DropdownData.expenseType[2]) {
                                  isShowOther = true;
                                } else {
                                  isShowOther = false;
                                }
                              });
                            },
                            onSaved: (value) {
                              setState(() {
                                expenseTypeDropdown = value!;
                                if (expenseTypeDropdown ==
                                    DropdownData.expenseType[2]) {
                                  isShowOther = true;
                                } else {
                                  isShowOther = false;
                                }
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
                    Visibility(
                      visible: isShowOther,
                      child: CustomTextField("Other type", "Other type",
                          expenseOtherTypeController, false, 1, false),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: TextFormField(
                        controller: expenseDateController,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Expense date cannot be blank';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Expense date",
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
                              expenseDateController.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: TextFormField(
                        controller: expenseTimeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Expense time",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Expense time cannot be blank';
                          }
                          return null;
                        },
                        onTap: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                              context: context, initialTime: timeOfDay);
                          if (pickedTime != null) {
                            var format = DateFormat("HH:mm");
                            if (!mounted) return;
                            var time = format.parse(pickedTime.format(context));
                            String expenseTime = format.format(time);
                            setState(() {
                              timeOfDay = pickedTime;
                              expenseTimeController.text =
                                  expenseTime; //set output date to TextField value.
                            });
                          }
                        },
                      ),
                    ),
                    CustomTextField("Expense amount", "Expense amount",
                        expenseAmountController, true, 1, true),
                    Stack(
                      // Container hiển thị ảnh (Expense Image)
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: 420,
                          padding: EdgeInsets.all(16.0),
                          margin: EdgeInsets.only(
                              top: 10, left: 16, right: 16, bottom: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.blue.shade500, width: 2),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(children: [
                              // Kiểm tra imageURL (nếu có thì hiển thị, không thì báo chưa có ảnh)
                              if (expenseImageURL != "") ...[
                                Image.file(File(expenseImageURL))
                              ] else ...[
                                Image.asset(
                                    'lib/assets/images/no-image-available.jpg')
                              ]
                            ]),
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
                    Align(
                      // Container hiển thị button chụp ảnh (Capture Image Button)
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: MaterialButton(
                          color: Colors.blue.shade500,
                          onPressed: () {
                            takePicture();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Ink(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(80.0)),
                            ),
                            child: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 40,
                                  maxWidth: 150,
                                  minHeight:
                                      40.0), // min sizes for Material buttons
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(right: 5),
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                      )),
                                  Text("Take picture",
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    CustomTextField("Expense comment", "Expense comment",
                        expenseCommentController, false, 3, false),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 65, right: 65),
                      child: MaterialButton(
                        color: Colors.blue.shade500,
                        onPressed: () {
                          addOrUpdate();
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
                                      if (widget.expense.expenseId > 0) {
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
                                    }())),
                                Text(
                                    (() {
                                      if (widget.expense.expenseId > 0) {
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
                          openCancelUpdateExpense();
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

  void viewListExpense() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListExpenses(tripId: widget.expense.tripId)));
  }

  void goHome() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future<int> insertExpense(Expense expense) async {
    return await SQLHelper.addExpense(expense);
  }

  Future<int> updateExpense(Expense expense) async {
    return await SQLHelper.updateExpense(expense);
  }

  Future<void> addOrUpdate() async {
    if (_formKey.currentState!.validate()) {
      int expenseTripId = widget.expense.tripId;
      String expenseType = "";
      if (expenseTypeDropdown == DropdownData.expenseType[2]) {
        expenseType = expenseOtherTypeController.text;
      } else {
        expenseType = expenseTypeDropdown;
      }
      String expenseDate = expenseDateController.text;
      String expenseTime = expenseTimeController.text;
      int expenseAmount = int.parse(expenseAmountController.text);
      String expenseComment = expenseCommentController.text;
      Expense editExpense = Expense.newExpense(
          expenseTripId,
          expenseType,
          expenseAmount,
          expenseDate,
          expenseTime,
          expenseComment,
          expenseImageURL,
          expenseLocation);

      if (widget.expense.expenseId > 0) {
        editExpense.expenseId = widget.expense.expenseId;
        openConfirmUpdateExpense(editExpense);
      } else {
        int result = await insertExpense(editExpense);
        if (!mounted) return;
        if (result > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Successfully add new expense")));
          viewListExpense();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Cannot add new expense")));
        }
      }
      if (!mounted) return;
    }
  }

  // void viewListExpense() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => ListExpenses(tripId: widget.expense.tripId)));
  // }

  Future openConfirmUpdateExpense(Expense expense) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text("Do you want to update this expense?"),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () async {
                  int result = await updateExpense(expense);
                  if (!mounted) return;
                  if (result > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Successfully update trip")));
                    viewListExpense();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Cannot update trip")));
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

  Future openCancelUpdateExpense() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            insetPadding: EdgeInsets.symmetric(vertical: 20),
            title: Text("Warning"),
            content: Text(confirmCancelDialogContent),
            actions: [
              MaterialButton(
                color: Colors.blue.shade500,
                onPressed: () async {
                  viewListExpense();
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

  String generateFileName() {
    DateTime currentDateTime = DateTime.now();
    String fileName =
        "${currentDateTime.year}-${currentDateTime.month}-${currentDateTime.day}_${currentDateTime.hour}:${currentDateTime.minute}";
    return fileName;
  }

  void takePicture() async {
    // Khởi tạo đối tượng XFile để thao tác với ảnh chụp từ camera (ImageSource là camera - Có thể sử dụng gallery nếu muốn chọn ảnh)
    XFile? takenImage = await picker.pickImage(source: ImageSource.camera);
    // Kiểm ra đối tượng
    if (takenImage == null) return;
    // Lấy đường dẫn root của app
    Directory directory = await getApplicationDocumentsDirectory();
    // Tạo mới tên ảnh
    String newImageName = generateFileName();
    // Khởi tạo file ảnh tại đường dẫn với tên ảnh được tạo
    File newImage = File('${directory.path}/$newImageName');
    // Ghi ảnh vào đường dẫn
    await newImage.writeAsBytes(File(takenImage.path).readAsBytesSync());
    // Cập nhật biến và load lại screen
    setState(() {
      image = newImage;
      if (image != null) {
        expenseImageURL = image!.path;
      }
      if (location != null) {
        expenseLocation = location!.toString();
      }
    });
  }
}

Future<Position> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
