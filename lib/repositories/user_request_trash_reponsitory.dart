import 'package:appwrite/models.dart' as models;
import 'package:thu_gom/providers/category_provider.dart';
import 'package:thu_gom/providers/user_request_trash_provider.dart';
class UserRequestTrashRepository{

  final UserRequestTrashProvider _userRequestTrashProvider;
  UserRequestTrashRepository(this._userRequestTrashProvider);


  Future<models.DocumentList> getRequestOfUserFromAppwrite() => _userRequestTrashProvider.getRequestOfUserFromAppwrite();
  Future<models.DocumentList> getRequestWithStatusPending() => _userRequestTrashProvider.getRequestWithStatusPending();
  Future<models.DocumentList> getRequestHistory() => _userRequestTrashProvider.getRequestHistory();
  
  Future<models.DocumentList> getRequestListColletor() => _userRequestTrashProvider.getRequestListColletor();
  Future<models.DocumentList> getRequestListConfirmColletor() => _userRequestTrashProvider.getRequestListConfirmColletor();

}