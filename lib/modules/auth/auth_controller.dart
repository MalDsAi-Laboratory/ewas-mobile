import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_ui/models/user_model.dart';

class AuthController extends GetxController {
  RxBool isObscure = true.obs;
  RxBool isConfirmObscure = true.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString userRole = UserRole.seller.obs;
  var selectedLatLng = Rxn<LatLng>(); // Nullable LatLng
  var selectedAddress = "".obs;

  void setLocation(LatLng latLng, String address) {
    selectedLatLng.value = latLng;
    selectedAddress.value = address;
  }

  void clearLocation() {
    selectedLatLng.value = null;
    selectedAddress.value = "";
  }
}
