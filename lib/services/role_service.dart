import '../utility/endpoints/role.dart';
import '../utility/util.dart';
import 'executor_service.dart';

class RoleService {

  Future<dynamic> getRole() async{
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + RoleEndpoints.get);
  }

  Future<dynamic> createRole(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.post(Util.getServiceHost() + RoleEndpoints.post, params);
  }

  Future<dynamic> updateRole(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.put(Util.getServiceHost() + RoleEndpoints.put, params);
  }

  Future<bool> deleteRole(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.delete(Util.getServiceHost() + RoleEndpoints.delete, params);
  }
}