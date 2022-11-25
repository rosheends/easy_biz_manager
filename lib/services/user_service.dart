import '../utility/endpoints/user.dart';
import '../utility/endpoints/project.dart';
import '../utility/util.dart';
import 'executor_service.dart';

class UserService {

  Future<dynamic> getUsers() async{
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + UserEndpoints.get);
  }

  Future<dynamic> getClients() async{
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + UserEndpoints.getClient);
  }


  Future<dynamic> createUser(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.post(Util.getServiceHost() + UserEndpoints.post, params);
  }

  Future<dynamic> updateUser(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.put(Util.getServiceHost() + UserEndpoints.put, params);
  }

  Future<bool> deleteUser(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.delete(Util.getServiceHost() + UserEndpoints.delete, params);
  }
}