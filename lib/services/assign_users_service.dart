import '../utility/endpoints/assignedUser.dart';
import '../utility/endpoints/user.dart';
import '../utility/util.dart';
import 'executor_service.dart';

class AssignUserService {

  Future<dynamic> getAssignedUsers(String id) async{
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + AssignedUserEndpoints.get.replaceAll("{id}", id));
  }

  Future<dynamic> createAssignment(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.post(Util.getServiceHost() + AssignedUserEndpoints.post, params);
  }

  // Future<dynamic> updateUser(Map<String, dynamic> params) async{
  //   ExecutorService service = ExecutorService();
  //   return service.put(Util.getServiceHost() + AssignedUserEndpoints.put, params);
  // }

  Future<bool> deleteUser(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.delete(Util.getServiceHost() + AssignedUserEndpoints.delete, params);
  }
}