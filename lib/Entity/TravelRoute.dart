//Lớp TravelRoute chứa các thuộc tính và hàm khởi tạo, convert data từ object sang Map để thao tác với SQLite (và ngược lại)
class TravelRoute {
  // Thuộc tính
  int travelRouteId = 0;
  int travelRouteTripId = 0;
  String travelRouteDate = "";
  String travelRouteDestination = "";

  // Hàm khởi tạo
  TravelRoute(this.travelRouteId, this.travelRouteTripId, this.travelRouteDate,
      this.travelRouteDestination);

  TravelRoute.newRoute(int travelRouteTripId, String travelRouteDate,
      String travelRouteDestination)
      : this(0, travelRouteTripId, travelRouteDate, travelRouteDestination);

  TravelRoute.emptyRoute();

  //Convert từ Map sang Object
  TravelRoute.fromMap(Map<String, dynamic> map) {
    travelRouteId = map['travelRouteId'] ?? 0;
    travelRouteTripId = map['travelRouteTripId'] ?? 0;
    travelRouteDate = map['travelRouteDate'] ?? "";
    travelRouteDestination = map['travelRouteDestination'] ?? "";
  }

  // Convert từ Object sang Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{
      'travelRouteTripId': travelRouteTripId,
      'travelRouteDate': travelRouteDate,
      'travelRouteDestination': travelRouteDestination
    };
    return map;
  }
}
