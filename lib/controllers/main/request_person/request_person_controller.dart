import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:thu_gom/managers/data_manager.dart';
import 'package:thu_gom/models/trash/user_request_trash_model.dart';
import 'package:thu_gom/repositories/user_request_trash_reponsitory.dart';
import 'package:thu_gom/widgets/custom_dialogs.dart';
import 'package:uuid/uuid.dart';

class RequestPersonController extends GetxController {
  final UserRequestTrashRepository _requestRepository;

  RequestPersonController(this._requestRepository);

  //Key
  final desriptionFieldKey = GlobalKey<FormBuilderFieldState>();
  final addressFieldKey = GlobalKey<FormBuilderFieldState>();
  final phoneNumberFieldKey = GlobalKey<FormBuilderFieldState>();

  dynamic argumentData = Get.arguments;

  //Handle button
  RxBool loading = true.obs;
  late String title;
  late String requestId;
  late String userId;
  RxString name = "".obs;
  RxString address = "".obs;
  RxString phoneNumber = "".obs;
  RxString description = "".obs;
  late String pointLatitute;
  late String pointLongitute;
  String status = "pending";
  late String trashType;
  late String confirm = "";

  late UserRequestTrashModel requestDetailModel;

  @override
  onInit() {
    title = argumentData['categoryTitle'];
    trashType = argumentData['categoryTitle'];
    name.value = DataManager().getData("userId");
    userId = DataManager().getData("userId");
    loading.value = false;
    getUserLocation();
    
    super.onInit();
  }

  //Person
  Future<void> sendRequestToAppwrite() async {
    CustomDialogs.showLoadingDialog();
    UserRequestTrashModel userRequestTrashModel = UserRequestTrashModel(
        requestId: Uuid().v1(),
        senderId: userId,
        trash_type: trashType,
        image: "test image",
        phone_number: phoneNumber.value,
        address: address.value,
        description: description.value,
        point_lat: double.parse(pointLatitute),
        point_lng: double.parse(pointLongitute),
        status: status,
        confirm: confirm,
        hidden: [],
        createAt: DateTime.now().toString(),
        updateAt: DateTime.now().toString());
    print(userRequestTrashModel.toString());

    await _requestRepository
        .sendRequestToAppwrite(userRequestTrashModel)
        .then((value) {
      CustomDialogs.hideLoadingDialog();
      Get.offAllNamed('/mainPage');
      CustomDialogs.showSnackBar(
          2, "Yêu cầu đã được gửi thành công", 'success');
    }).catchError((onError) {
      CustomDialogs.hideLoadingDialog();
      print(onError);
      CustomDialogs.showSnackBar(
          2, "Đã có lỗi xảy ra vui lòng thử lại sau!", 'error');
    });
  }

  Future getImageFromCamera() async {
    
  }

  Future<void> getUserLocation() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
    } else {
      LocationPermission permission;
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Quyền vị trí bị từ chối');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Quyền vị trí bị từ chối vĩnh viễn, chúng tôi không thể yêu cầu quyền.');
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      DataManager().saveData('latitude', '${position.latitude}');
      DataManager().saveData('longitude', '${position.longitude}');
      pointLatitute = position.latitude.toString();
      pointLongitute = position.longitude.toString();
    }
  }
}
