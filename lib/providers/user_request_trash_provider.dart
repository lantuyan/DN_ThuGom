import 'dart:async';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thu_gom/models/trash/user_request_trash_model.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thu_gom/services/appwrite.dart';
import 'package:thu_gom/shared/constants/appwrite_constants.dart';

class UserRequestTrashProvider {
  late Account account;
  late Storage storage;
  late Databases databases;

  UserRequestTrashProvider() {
    account = Account(Appwrite.instance.client);
    storage = Storage(Appwrite.instance.client);
    databases = Databases(Appwrite.instance.client);
  }

  Future<models.DocumentList> getRequestOfUserFromAppwrite() async {
    final response = await databases!.listDocuments(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userRequestTrashCollection);

    return response;
  }

  // LIST REQUEST OF USER
  Future<models.DocumentList> getRequestWithStatusPending() async {
    final GetStorage _getStorage = GetStorage();
    final userID = _getStorage.read('userId');
    final response = await databases!.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userRequestTrashCollection,
      queries: [
        Query.equal('status', 'pending'),
        Query.equal('senderId', userID)
      ],
    );
    return response;
  }

  // LIST REQUEST OF COLLECTOR
  Future<models.DocumentList> getRequestListColletor(
      int offset, int currentPage) async {
    final response = await databases!.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userRequestTrashCollection,
      queries: [
        Query.equal('status', 'pending'),
        Query.limit(10),
        Query.offset(offset * currentPage),
      ],
    );
    return response;
  }

  Future<models.DocumentList> getRequestHistory() async {
    final GetStorage _getStorage = GetStorage();
    final userID = _getStorage.read('userId');
    final response = await databases!.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userRequestTrashCollection,
      queries: [
        Query.notEqual('status', 'pending'),
        Query.equal('senderId', userID)
      ],
    );
    return response;
  }

  Future<models.DocumentList> getRequestListConfirmColletor() async {
    final GetStorage _getStorage = GetStorage();
    final userID = _getStorage.read('userId');
    final response = await databases!.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userRequestTrashCollection,
      queries: [Query.equal('confirm', userID)],
    );
    return response;
  }

  Future<void> cancelRequest(String requestId) async {
    await databases?.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.userRequestTrashCollection,
        documentId: requestId,
        data: {
          'status': 'cancel',
        });
  }

  Future<void> hiddenRequest(String requestId, List<String> hidden) async {
    await databases?.updateDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userRequestTrashCollection,
      documentId: requestId,
      data: {'hidden': hidden},
    );
  }

  Future<void> confirmRequest(String requestId, String userId) async {
    await databases?.updateDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userRequestTrashCollection,
      documentId: requestId,
      data: {'confirm': userId, 'status': 'finish'},
    );
  }

  Future sendRequestToAppwrite(
      UserRequestTrashModel userRequestTrashModel) async {
    try {
      await databases.createDocument(
          databaseId: AppWriteConstants.databaseId,
          collectionId: AppWriteConstants.userRequestTrashCollection,
          documentId: userRequestTrashModel.requestId,
          data: {
            "senderId": userRequestTrashModel.senderId,
            "image": userRequestTrashModel.image,
            "phone_number": userRequestTrashModel.phone_number,
            "address": userRequestTrashModel.address,
            "description": userRequestTrashModel.description,
            "point_lat": userRequestTrashModel.point_lat,
            "point_lng": userRequestTrashModel.point_lng,
            "status": userRequestTrashModel.status,
            "confirm": userRequestTrashModel.confirm,
            "hidden": userRequestTrashModel.hidden,
            "trash_type": userRequestTrashModel.trash_type,
            "createAt": userRequestTrashModel.createAt,
            "updateAt": userRequestTrashModel.updateAt,
          });
      print("sendRequestToAppwrite");
    } catch (e) {
      print("sendRequestToAppwrite error: $e");
    }
  }

  Future<models.File> uploadCategoryImage(String imagePath) {
    String fileName = "${DateTime.now().microsecondsSinceEpoch}"
        "${imagePath.split(".").last}";
    final response = storage.createFile(
        bucketId: AppWriteConstants.userRequestTrashBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: imagePath, filename: fileName));

    return response;
  }

  Future<int> loadRequestByType(String type, String dateRange) async {
    List<String> dates = dateRange.toString().split(" - ");
    print(dates[0]);
    print(dates[1]);
    final response = await databases.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userRequestTrashCollection,
      queries: [
        Query.equal('trash_type', type),
        Query.greaterThanEqual('createAt', dates[0]),
        Query.lessThanEqual('createAt', dates[1]),
      ],
    );
    return response.total;
  }

  // admin
  Future<models.DocumentList> getRequestByDateRange(String dateRange) async {
    List<String> dates = dateRange.toString().split(" - ");
    print("dataRange $dateRange");
    print(dates[0]);
    print(dates[1]);
    final response = await databases.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.userRequestTrashCollection,
      queries: [
        Query.greaterThanEqual('createAt', dates[0]),
        Query.lessThanEqual('createAt', dates[1]),
      ],
    );
    return response;
  }

  Future<String> exportRequestToExcel(models.DocumentList data, String fileName) async {
    final stopwatch = Stopwatch()..start();

    final excel = Excel.createExcel();
    final Sheet sheet = excel[excel.getDefaultSheet()!];
   
  //   // Write header row
  sheet.appendRow([
    TextCellValue('senderId'),
    TextCellValue('image'),
    TextCellValue('phone_number'),
    TextCellValue('address'),
    TextCellValue('description'),
    TextCellValue('status'),
    TextCellValue('confirm'),
    TextCellValue('hidden'),
    TextCellValue('trash_type'),
    TextCellValue('createAt'),
    TextCellValue('updateAt'),
    TextCellValue('point_lat'),
    TextCellValue('point_lng')
  ]);
   sheet.appendRow([]);

  // Populate data
  for (final document in data.documents) {
    sheet.appendRow([
      TextCellValue(document.data['senderId'] ?? ''),
      TextCellValue(document.data['image'] ?? ''),
      TextCellValue(document.data['phone_number'] ?? ''),
      TextCellValue(document.data['address'] ?? ''),
      TextCellValue(document.data['description'] ?? ''),
      TextCellValue(document.data['status'] ?? ''),
      TextCellValue(document.data['confirm'] ?? ''),
      TextCellValue(document.data['hidden'].toString()),
      TextCellValue(document.data['trash_type'] ?? ''),
      TextCellValue(document.data['createAt'] ?? ''),
      TextCellValue(document.data['updateAt'] ?? ''),
      TextCellValue(document.data['point_lat'].toString()),
      TextCellValue(document.data['point_lng'].toString()),
    ]);

    // break line
    sheet.appendRow([]);
  }

  var fileBytes = excel.save();
  var directory = await getApplicationDocumentsDirectory();
  
  directory = Directory('/storage/emulated/0/Download');

  final file =  File('${directory.path}/$fileName.xlsx')
  ..createSync(recursive: true)
  ..writeAsBytesSync(fileBytes!);

  print('File is saved to ${file.path}');

  if (file.existsSync()) {
    return file.path;
  } else {
    return '';
  }

}

  // Future<dynamic> deleteCategoryImage(String fileId) {
  //   final response = storage!.deleteFile(
  //     bucketId: AppWriteConstants.categoryBucketId,
  //     fileId: ID.unique(),
  //   );

  //   return response;
  // }

  // Future<models.Document> createCategory(Map map) async {
  //   final response = databases!.createDocument(
  //       databaseId: AppWriteConstants.databaseId,
  //       collectionId: AppWriteConstants.categoryCollectionId,
  //       documentId: ID.unique(),
  //       data: {
  //         "category_name": map["category_name"],
  //         "category_image": map["category_image"],
  //         "categoryID": map["category_image"]
  //       });

  //   return response;
  // }

  //   Future<models.DocumentList> getCategoryDetail() async {
  //   final response = await databases!.listDocuments(
  //       databaseId: AppWriteConstants.databaseId,
  //       collectionId: AppWriteConstants.categoryDetailCollectionId);

  //   return response;
  // }
}
