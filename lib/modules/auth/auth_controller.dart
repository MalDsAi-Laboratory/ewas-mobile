import 'package:get/get.dart';
import 'package:simple_ui/models/user_model.dart';

class AuthController extends GetxController {
  RxBool isObscure = true.obs;
  RxBool isConfirmObscure = true.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString userRole = UserRole.seller.obs;
}
