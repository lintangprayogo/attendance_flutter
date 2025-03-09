import 'dart:math';

class RadiusCalculate {
  static double calculateDistance(
      {required double lat1,
      required double lon1,
      required double lat2,
      required double lon2}) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
