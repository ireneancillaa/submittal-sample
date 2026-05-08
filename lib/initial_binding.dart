import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../services/api_service.dart';
import '../controllers/history_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApiService());

    Get.put(LoginController(), permanent: true);
    Get.put(HistoryController(), permanent: true);
  }
}