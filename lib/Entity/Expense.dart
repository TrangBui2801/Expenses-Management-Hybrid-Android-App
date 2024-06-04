//Lớp expense chứa các thuộc tính và hàm khởi tạo, convert data từ object sang Map để thao tác với SQLite (và ngược lại)
class Expense {
  // thuộc tính
  int expenseId = 0;
  int tripId = 0;
  String expenseType = "";
  int expenseAmount = 0;
  String expenseDate = "";
  String expenseTime = "";
  String expenseComment = "";
  String expenseImage = "";
  String expenseLocation = "";

  //Hàm khởi tạo
  Expense(this.expenseId, this.tripId, this.expenseType, this.expenseAmount,
      this.expenseDate, this.expenseTime, this.expenseComment, this.expenseImage, this.expenseLocation);
  Expense.newExpense(int tripId, String expenseType, int expenseAmount,
      String expenseDate, String expenseTime, String expenseComment, String expenseImage, String expenseLocation)
      : this(0, tripId, expenseType, expenseAmount, expenseDate, expenseTime,
            expenseComment, expenseImage, expenseLocation);
  Expense.emptyExpense();

  // Convert từ Map sang Object
  Expense.fromMap(Map<String, dynamic> map) {
    expenseId = map['expenseId'];
    tripId = map['tripId'];
    expenseType = map['expenseType'];
    expenseAmount = map['expenseAmount'];
    expenseDate = map['expenseDate'];
    expenseTime = map['expenseTime'];
    expenseComment = map['expenseComment'];
    expenseImage = map['expenseImage'];
    expenseLocation = map['expenseLocation'];
  }
  // Convert từ Object sang Map 
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'tripId': tripId,
      'expenseType': expenseType,
      'expenseAmount': expenseAmount,
      'expenseDate': expenseDate,
      'expenseTime': expenseTime,
      'expenseComment': expenseComment,
      'expenseImage': expenseImage,
      'expenseLocation': expenseLocation
    };
    return map;
  }
}
