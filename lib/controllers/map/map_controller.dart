import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/material.dart';
import 'package:thu_gom/models/trash/user_request_trash_model.dart';
import 'package:thu_gom/shared/constants/appwrite_constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapController extends GetxController {
  late LatLng _initialPosition = LatLng(16.0544, 108.2034);
  LatLng get initialPos => _initialPosition;

  var activeGPS = true.obs;
  var shouldShowMarkers = false.obs;

  RxString currentAddress = ''.obs;
  RxString labels = ''.obs;
  RxString infos = ''.obs;

  late final client = Client()
      .setEndpoint(AppWriteConstants.endPoint)
      .setProject(AppWriteConstants.projectId);
  // user
  late Databases collection_points;
  List<Marker> markers = [];
  //collecter
  late Databases user_request;
  List<Marker> markers_user = [];
  //static
  List<Marker> static_user_done = [];
  List<Marker> static_user_not = [];
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  var isDataLoaded = false.obs;
  var isDataLoaded2 = false.obs;
  var isDataLoaded3 = false.obs;


  @override
  void onInit() async {
    super.onInit();
    await getUserLocation();
    await userRequest();
    await loadMarkersCollecter();
  }

  void filterDataByTime() {
    statistical(startTime, endTime);
  }

  Future<void> getUserLocation() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      activeGPS.value = false;
    } else {
      activeGPS.value = true;
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
      _initialPosition = LatLng(position.latitude, position.longitude);

      // Sau khi _initialPosition được khởi tạo, cập nhật biến isDataLoaded
      // isDataLoaded.value = true;
      update(); // Cần gọi update để cập nhật UI
    }
  }

  Future<void> loadMarkersCollecter() async {
    try {
      collection_points = Databases(client);
      models.DocumentList documentList = await collection_points.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.collection_point_Id,
          queries: [
            Query.limit(1000),
            Query.offset(0)
          ]
      );

      for (var document in documentList.documents) {
        Map<String, dynamic> data = document.data as Map<String, dynamic>;
        double latitude = data['point_lat'];
        double longitude = data['point_lng'];
        String address = data['address'];
        String label = data['label'];
        String info = data['info'] ?? "";
        if (data['info'] != null) {
          info = data['info'];
        } else {
          // Xử lý khi 'info' là null
          info = "Không có thông tin";
        }
        Marker marker = Marker(
          point: LatLng(latitude, longitude),
          child: GestureDetector(
            onTap: () {
              currentAddress.value = address;
              labels.value = label;
              infos.value = info;
              openGoogleMapsApp(_initialPosition.latitude,
                  _initialPosition.longitude, latitude, longitude);
            },
            child: Image.asset(
              'assets/images/bin.jpg',
              height: 10,
              width: 10,
            ),
          ),
        );
        markers.add(marker);
      }
      isDataLoaded.value = true;
      shouldShowMarkers.value = true;
      update();

    } catch (e) {
      print('Error!!! $e');
    }
  }

  Future<void> userRequest() async {

    try {
      user_request = Databases(client);
      models.DocumentList documentlistUser = await user_request.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userRequestTrashCollection,
          queries: [
            Query.limit(10000),
            Query.offset(0)
          ]
      );
      markers_user.clear();
      for (var documents in documentlistUser.documents) {
        Map<String, dynamic> data = documents.data as Map<String, dynamic>;
        double? pointLat = data['point_lat'] as double?;
        double? pointLng = data['point_lng'] as double?;
        String address = data['address'];
        String senderId = data['senderId'];
        String trash_type = data['trash_type'];
        String image = data['image'];
        String? description = data['description'] as String?;
        String phone_number = data['phone_number'];
        String status = data['status'];
        String createAt = data['createAt'];
        String updateAt = data['updateAt'];


        UserRequestTrashModel request = UserRequestTrashModel(senderId: senderId,
          address: address, trash_type: trash_type, image: image, description: description!,
          phone_number: phone_number, point_lat: pointLat!, point_lng: pointLng!, status: status, createAt: createAt, updateAt: updateAt, requestId: ''
        );
        if (status == 'pending')
        {
          Marker marker = Marker(
            point: LatLng(pointLat!, pointLng!),
            child: GestureDetector(
              onTap: () {
                currentAddress.value = address;
                requestDetail(request);
              },
              child: Image.asset(
                'assets/images/bin.jpg',
                height: 10,
                width: 10,
              ),
            ),
          );
          markers_user.add(marker);
        }
      }
      isDataLoaded2.value = true;
      shouldShowMarkers.value = true;
      update();
    } catch (e) {
      print('Error!!! $e');
    }
  }

  Future<void> statistical(DateTime startTime, DateTime endTime) async {
    try {
      user_request = Databases(client);
      models.DocumentList documentlistUser = await user_request.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userRequestTrashCollection,
          queries: [
            Query.limit(10000),
            Query.offset(0)
          ]
      );
      static_user_done.clear();
      static_user_not.clear();
      for (var documents in documentlistUser.documents) {
        Map<String, dynamic> data = documents.data as Map<String, dynamic>;
        // double pointLat = data['point_lat'] as double;
        // double pointLng = data['point_lng'] as double;
        // String address = data['address'];
        // String senderId = data['senderId'];
        // String trash_type = data['trash_type'];
        // String image = data['image'];
        // String description = data['description'] as String;
        // String phone_number = data['phone_number'];
        // String status = data['status'];
        // String date = data['createAt'];
        // String updateAt = data['updateAt'];
        // String? finishImage = data['finishImage'] as String?;
        // double? rating = data['rating'] as double?;
        // UserRequestTrashModel request = UserRequestTrashModel(senderId: senderId,
        //     address: address, trash_type: trash_type, image: image, description: description,
        //     phone_number: phone_number, point_lat: pointLat, point_lng: pointLng, status: status, createAt: date, updateAt: updateAt, requestId: '', finishImage: finishImage!, rating: rating!);
          UserRequestTrashModel request = UserRequestTrashModel.fromMap(data);
        DateTime documentDateTime = DateTime.parse(request.createAt);
        if (documentDateTime.isAfter(startTime) && documentDateTime.isBefore(endTime)) {
          if (request.status == 'pending' || request.status == 'processing') {
            Marker marker = Marker(
              point: LatLng(request.point_lat, request.point_lng),
              child: GestureDetector(
                onTap: () {
                  requestDetail(request);
                },
                child: Image.asset(
                  'assets/images/bin.jpg',
                  height: 10,
                  width: 10,
                ),
              ),
            );
            static_user_not.add(marker);
          }
          // Thêm marker vào danh sách tương ứng
          else if(request.status == 'finish' || request.status == 'confirming') {
            Marker marker = Marker(
              point: LatLng(request.point_lat, request.point_lng),
              child: GestureDetector(
                onTap: () {
                  requestDetail(request);
                },
                child: Image.asset(
                  'assets/images/bin1.jpg',
                  height: 10,
                  width: 10,
                ),
              ),
            );
            static_user_done.add(marker);
          }
        }
      }
      isDataLoaded3.value = true;
      shouldShowMarkers.value = true;
      update();
    } catch (e) {
      print('Error!!! $e');
    }
  }
  Future<void> openGoogleMapsApp(
      double startLat, double startLng, double endLat, double endLng) async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác nhận di chuyển"),
          content: Text("Bạn có chắc chắn muốn di chuyển đến đích này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng dialog
                final url = Uri.parse(
                    'https://www.google.com/maps/dir/?api=1&origin=$startLat,$startLng&destination=$endLat,$endLng');
                try {
                  await launchUrl(url);
                } catch (e) {
                  print('Error launching Google Maps: $e');
                }
              },
              child: Text("Đồng ý"),
            ),
          ],
        );
      },
    );
  }

  Future<void> requestDetail(
      dynamic request) async {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Chi tiết yêu cầu"),
          content: Text("Bạn muốn xem yêu cầu chi tiết?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng dialog
                Get.toNamed('requestDetailPage', arguments: {
                  'requestDetail': request
                });
              },
              child: Text("Xác nhận"),
            ),
          ],
        );
      },
    );
  }

}
