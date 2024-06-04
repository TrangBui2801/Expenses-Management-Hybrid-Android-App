// ignore_for_file: prefer_const_declarations
import 'package:m_expense_application/Entity/Expense.dart';
import 'package:m_expense_application/Entity/TravelRoute.dart';
import 'package:m_expense_application/Entity/Trip.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static final String databaseName = 'm_expense_application';

  static final String tripTable = 'trip';
  static final String expenseTable = 'expense';
  static final String routeTable = 'route';

  static final String tripIdColumn = 'tripId';
  static final String tripTypeColumn = 'tripType';
  static final String tripNameColumn = 'tripName';
  static final String tripDestinationColumn = 'tripDestination';
  static final String tripStartDateColumn = 'tripStartDate';
  static final String tripEndDateColumn = 'tripEndDate';
  static final String tripTransportTypeColumn = 'tripTransportType';
  static final String tripTransportNameColumn = 'tripTransportName';
  static final String tripRiskAssessmentColumn = 'tripRiskAssessment';
  static final String tripDescriptionColumn = 'tripDescription';

  static final String tripTotalColumn = 'tripTotal';

  static final String expenseIdColumn = 'expenseId';
  static final String expenseTripIdColumn = 'tripId';
  static final String expenseTypeColumn = 'expenseType';
  static final String expenseAmountColumn = 'expenseAmount';
  static final String expenseDateColumn = 'expenseDate';
  static final String expenseTimeColumn = 'expenseTime';
  static final String expenseCommentColumn = 'expenseComment';
  static final String expenseImageColumn = 'expenseImage';
  static final String expenseLocationColumn = 'expenseLocation';

  static final String routeIdColumn = "travelRouteId";
  static final String routeTripIdColumn = "travelRouteTripId";
  static final String routeDestinationColumn = "travelRouteDestination";
  static final String routeDateColumn = "travelRouteDate";

  static final tripQuery = '''
                  CREATE TABLE IF NOT EXISTS $tripTable( 
                        $tripIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
                        $tripTypeColumn VARCHAR(100) NOT NULL,
                        $tripNameColumn VARCHAR(100) NOT NULL,
                        $tripDestinationColumn VARCHAR(255) NOT NULL,
                        $tripStartDateColumn VARCHAR(50) NOT NULL,
                        $tripEndDateColumn VARCHAR(50) NOT NULL,
                        $tripTransportTypeColumn VARCHAR(100) NOT NULL,
                        $tripTransportNameColumn VARCHAR(255) NOT NULL,
                        $tripRiskAssessmentColumn VARCHAR(50) NOT NULL,
                        $tripDescriptionColumn TEXT
                    )
                ''';
  static final expenseQuery = '''
                  CREATE TABLE IF NOT EXISTS $expenseTable( 
                        $expenseIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
                        $expenseTripIdColumn INTEGER NOT NULL,
                        $expenseTypeColumn VARCHAR(100) NOT NULL,
                        $expenseAmountColumn INTEGER NOT NULL,
                        $expenseDateColumn VARCHAR(50) NOT NULL,
                        $expenseTimeColumn VARCHAR(50) NOT NULL,
                        $expenseCommentColumn TEXT,
                        $expenseImageColumn VARCHAR(255),
                        $expenseLocationColumn VARCHAR(255)
                    )
                ''';

  static final routeQuery = '''
                  CREATE TABLE IF NOT EXISTS $routeTable (
                        $routeIdColumn INTEGER PRIMARY KEY AUTOINCREMENT,
                        $routeTripIdColumn INTEGER NOT NULL,
                        $routeDateColumn VARCHAR(50),
                        $routeDestinationColumn TEXT
                    )
                ''';

  // các hàm sử dụng trong sqlite
  // insert: tham số truyền vào là tên bảng và data(Map) 
  // update: tham số truyền vào là tên bảng, data, đk (where và where argument)
  // delete: tham số truyền vào là tên bảng, đk 
  // querry: tham số truyền vào là tên bảng, đk 
  // rawQuery, rawUpdate, rawDelete: tham số truyền vào là truy vấn
  // Luồng chạy của các hàm:
  // B1: Khởi tạo đối tượng Database để thao tác và xử lý dữ liệu trong SQLite
  // B2: Gọi hàm để thao tác với Database
  // B3: Trả về kết quả tương ứng để xử lý

  static Future<void> createTables(sql.Database database) async {
    await database.execute(tripQuery);
    await database.execute(expenseQuery);
    await database.execute(routeQuery);
  }

  static Future<sql.Database> database() async {
    return sql.openDatabase(
      '$databaseName.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> addRoute(TravelRoute route) async {
    final database = await SQLHelper.database();
    int result = await database.insert(routeTable, route.toMap());
    return result;
  }

  static Future<void> addRoutes(List<TravelRoute> listRoutes) async {
    final database = await SQLHelper.database();
    // khởi tạo 1 gói lệnh để insert nhiều bản ghi vào trong db
    var batch = database.batch();
    for (TravelRoute travelRoute in listRoutes) {
      // truyền vào các truy vấn để insert từng bản ghi (tương tự như 1 bản nháp gói các truy vấn mà chưa insert vào db)
      batch.insert(routeTable, travelRoute.toMap());
    }
    // insert các bản ghi vào db
    batch.commit(noResult: true);
  }

  static Future<void> updateRoutes(
      List<TravelRoute> listRoutes, int tripId) async {
    await deleteAllRoutesOfTrip(tripId);
    await addRoutes(listRoutes);
  }

  static Future<int> deleteRoute(int travelRouteId) async {
    final database = await SQLHelper.database();
    int result = await database.delete(routeTable,
        where: "$routeIdColumn= ?", whereArgs: [travelRouteId]);
    return result;
  }

  static Future<int> deleteAllRoutesOfTrip(int tripId) async {
    final database = await SQLHelper.database();
    int result = await database.delete(routeTable,
        where: "$routeTripIdColumn= ?", whereArgs: [tripId]);
    return result;
  }

  static Future<List<TravelRoute>> getRoutes(int tripId) async {
    final database = await SQLHelper.database();
    final data = await database.query(routeTable,
        where: '$routeTripIdColumn = ?', whereArgs: [tripId]);
    List<TravelRoute> result = [];
    for (Map<String, dynamic> map in data) {
      result.add(TravelRoute.fromMap(map));
    }
    return result;
  }

  static Future<int> addTrip(Trip trip) async {
    final database = await SQLHelper.database();
    int result = await database.insert(tripTable, trip.toMap());
    for (TravelRoute route in trip.tripRoute) {
      route.travelRouteTripId = result;
    }
    // Insert nhiều travelRoute
    addRoutes(trip.tripRoute);
    return result;
  }

  static Future<int> updateTrip(Trip trip) async {
    final database = await SQLHelper.database();
    int result = await database.update(tripTable, trip.toMap(),
        where: "$tripIdColumn = ?", whereArgs: [trip.tripId]);
    for (TravelRoute route in trip.tripRoute) {
      route.travelRouteTripId = trip.tripId;
    }
    updateRoutes(trip.tripRoute, trip.tripId);
    return result;
  }

  static Future<int> deleteTrip(int tripId) async {
    final database = await SQLHelper.database();
    int result = await database
        .delete(tripTable, where: "$tripIdColumn = ?", whereArgs: [tripId]);
    await database.delete(expenseTable,
        where: '$expenseTripIdColumn = ?', whereArgs: [tripId]);
    await database.delete(routeTable,
        where: '$routeTripIdColumn = ?', whereArgs: [tripId]);
    return result;
  }

  static Future<List<Trip>> getTrips() async {
    final database = await SQLHelper.database();
    List<Trip> result = [];
    final data = await database.rawQuery("""
        SELECT 
          t.*, e.$tripTotalColumn 
          FROM $tripTable t 
          LEFT JOIN
          (SELECT 
            $expenseTripIdColumn, SUM($expenseAmountColumn) AS $tripTotalColumn 
            FROM $expenseTable 
            GROUP BY $expenseTripIdColumn
          ) e
          ON t.$tripIdColumn = e.$expenseTripIdColumn
          ORDER BY t.$tripIdColumn DESC
        """);
    for (Map<String, dynamic> map in data) {
      result.add(Trip.fromMap(map));
    }
    return result;
  }

  static Future<int> deleteTrips(List<int> ids) async {
    final database = await SQLHelper.database();
    String args = ids.toString();
    args = args.replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "");
    int result = await database
        .rawDelete("DELETE FROM $tripTable WHERE $tripIdColumn IN ($args)");
    await database.rawDelete(
        "DELETE FROM $expenseTable WHERE $expenseTripIdColumn IN ($args)");
    await database.rawDelete(
        "DELETE FROM $routeTable WHERE $routeTripIdColumn IN ($args)");
    return result;
  }

  static Future<int> addExpense(Expense expense) async {
    final database = await SQLHelper.database();
    int result = await database.insert(expenseTable, expense.toMap());
    return result;
  }

  static Future<int> updateExpense(Expense expense) async {
    final database = await SQLHelper.database();
    int result = await database.update(expenseTable, expense.toMap(),
        where: "$expenseIdColumn = ?", whereArgs: [expense.expenseId]);
    return result;
  }

  static Future<int> deleteExpense(int expenseId) async {
    final database = await SQLHelper.database();
    int result = await database.delete(expenseTable,
        where: "$expenseIdColumn = ?", whereArgs: [expenseId]);
    return result;
  }

  static Future<int> deleteExpenses(List<int> ids) async {
    final database = await SQLHelper.database();
    String args = ids.toString();
    args = args.replaceAll("[", "").replaceAll("]", "").replaceAll(" ", "");
    int result = await database.rawDelete(
        "DELETE FROM $expenseTable WHERE $expenseIdColumn IN ($args)");
    return result;
  }

  static Future<List<Expense>> getExpensesByTrip(int tripId) async {
    final database = await SQLHelper.database();
    final data = await database.query(expenseTable,
        where: '$expenseTripIdColumn = ? ORDER BY $expenseIdColumn DESC',
        whereArgs: [tripId]);
    List<Expense> result = [];
    for (Map<String, dynamic> map in data) {
      result.add(Expense.fromMap(map));
    }
    return result;
  }
}
