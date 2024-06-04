import 'package:m_expense_application/Entity/TravelRoute.dart';
//Lớp Trip chứa các thuộc tính và hàm khởi tạo, convert data từ object sang Map để thao tác với SQLite (và ngược lại)

class Trip {
  // Thuộc tính
  int tripId = 0;
  String tripType = "";
  String tripName = "";
  String tripDestination = "";
  String tripStartDate = "";
  String tripEndDate = "";
  String tripTransportType = "";
  String tripTransportName = "";
  List<TravelRoute> tripRoute = [];
  String tripRiskAssessment = "";
  String tripDescription = "";
  int tripTotal = 0;

  // Hàm khởi tạo
  Trip(
      this.tripId,
      this.tripType,
      this.tripName,
      this.tripDestination,
      this.tripStartDate,
      this.tripEndDate,
      this.tripTransportType,
      this.tripTransportName,
      this.tripRoute,
      this.tripRiskAssessment,
      this.tripDescription,
      this.tripTotal);

  Trip.newTrip(
      String tripType,
      String tripName,
      String tripDestination,
      String tripStartDate,
      String tripToDate,
      String tripTransportType,
      String tripTransportName,
      List<TravelRoute> tripRoute,
      String tripRiskAssessment,
      String tripDescription)
      : this(
            0,
            tripType,
            tripName,
            tripDestination,
            tripStartDate,
            tripToDate,
            tripTransportType,
            tripTransportName,
            tripRoute,
            tripRiskAssessment,
            tripDescription,
            0);
  Trip.emptyTrip();

  // Convert từ Map sang Object
  Trip.fromMap(Map<String, dynamic> map) {
    tripId = map['tripId'] ?? 0;
    tripType = map['tripType'] ?? "";
    tripName = map['tripName'] ?? "";
    tripDestination = map['tripDestination'] ?? "";
    tripStartDate = map['tripStartDate'] ?? "";
    tripEndDate = map['tripEndDate'] ?? "";
    tripTransportType = map['tripTransportType'] ?? "";
    tripTransportName = map['tripTransportName'] ?? "";
    tripRiskAssessment = map['tripRiskAssessment'] ?? "";
    tripDescription = map['tripDescription'] ?? "";
    tripTotal = map['tripTotal'] ?? 0;
  }

  // Convert từ Object sang Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'tripName': tripName,
      'tripType': tripType,
      'tripDestination': tripDestination,
      'tripStartDate': tripStartDate,
      'tripEndDate': tripEndDate,
      'tripTransportType': tripTransportType,
      'tripTransportName': tripTransportName,
      'tripRiskAssessment': tripRiskAssessment,
      'tripDescription': tripDescription
    };
    return map;
  }
}
