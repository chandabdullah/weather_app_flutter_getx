import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    print(connectivityResult);
    if ((connectivityResult
            .any((element) => element == ConnectivityResult.mobile)) ||
        (connectivityResult
            .any((element) => element == ConnectivityResult.wifi))) {
      return true; // Device is connected to the internet
    } else {
      return false; // Device is not connected to the internet
    }
  }
}
