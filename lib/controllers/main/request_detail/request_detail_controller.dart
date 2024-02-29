import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thu_gom/models/trash/user_request_trash_model.dart';
import 'package:thu_gom/repositories/user_request_trash_reponsitory.dart';
import 'package:thu_gom/widgets/custom_dialogs.dart';

class RequestDetailController extends GetxController {
  final UserRequestTrashRepository _requestRepository;

  RequestDetailController(this._requestRepository);
  //Get Storage
  final GetStorage _getStorage = GetStorage();
  //Request data
  RxMap data = {}.obs;
  // name and userId
  RxString name =''.obs;
  RxString userId =''.obs;
  //Handle button
  RxBool loading = true.obs;
  RxBool allowHidden = true.obs;
  RxBool allowConfirm = true.obs;
  late String requestId;
  late UserRequestTrashModel requestDetailModel;

  @override
  Future<void> onInit() async {
    super.onInit();
    data.value = await Get.arguments;
    requestDetailModel = data.value['requestDetail'];
    print(requestDetailModel.image);
    requestId = requestDetailModel.requestId;
    name.value = await _getStorage.read('name');
    userId.value = await _getStorage.read('userId');
    loading.value = false;
  }
  //Person
  Future<void> cancelRequest(String requestId)async {
    CustomDialogs.showLoadingDialog();
    await _requestRepository.cancelRequest(requestId).then((value){
      CustomDialogs.hideLoadingDialog();
      Get.offAllNamed('/mainPage');
      CustomDialogs.showSnackBar(2, "Đã hủy yêu cầu thành công", 'success');
    }).catchError((onError){
      CustomDialogs.hideLoadingDialog();
      print(onError);
      CustomDialogs.showSnackBar(2, "Đã có lỗi xảy ra vui lòng thử lại sau!", 'error');
    });
  }
  //Collector
  Future<void> confirmRequest(String requestId,String userId)async {
    CustomDialogs.showLoadingDialog();
    await _requestRepository.confirmRequest(requestId,userId).then((value){
      allowHidden.value = false;
      allowConfirm.value = false;
      CustomDialogs.hideLoadingDialog();
      CustomDialogs.showSnackBar(2, "Xác nhận thu gom thành công", 'success');
    }).catchError((onError){
      CustomDialogs.hideLoadingDialog();
      print(onError);
      CustomDialogs.showSnackBar(2, "Đã có lỗi xảy ra vui lòng thử lại sau!", 'error');
    });
  }

  Future<void> hiddenRequest(String requestId,List<String>? oldHiddenList)async {
    CustomDialogs.showLoadingDialog();
    var newHidden;
    if (oldHiddenList != null) {
      // Nếu danh sách hidden không rỗng, thêm requestId vào danh sách
      oldHiddenList.add(requestId);
      newHidden = oldHiddenList; // Gán lại danh sách mới vào newHidden
    } else {
      // Nếu danh sách hidden rỗng, tạo danh sách mới với requestId duy nhất
      newHidden = [requestId];
    }
    await _requestRepository.hiddenRequest(requestId,newHidden).then((value){
      allowConfirm.value = false;
      CustomDialogs.hideLoadingDialog();
      CustomDialogs.showSnackBar(2, "Đã bỏ qua yêu cầu thành công", 'success');
    }).catchError((onError){
      CustomDialogs.hideLoadingDialog();
      print(onError);
      CustomDialogs.showSnackBar(2, "Đã có lỗi xảy ra vui lòng thử lại sau!", 'error');
    });
  }

}