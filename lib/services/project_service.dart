
import 'package:easy_biz_manager/services/executor_service.dart';
import 'package:easy_biz_manager/utility/endpoints/project.dart';
import 'package:easy_biz_manager/utility/util.dart';

class ProjectService {

  Future<dynamic> getProjects() async{
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + ProjectEndpoints.get);
  }

  Future<dynamic> createProject(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.post(Util.getServiceHost() + ProjectEndpoints.post, params);
  }

  Future<dynamic> updateProject(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.put(Util.getServiceHost() + ProjectEndpoints.put, params);
  }

  Future<bool> deleteProject(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.delete(Util.getServiceHost() + ProjectEndpoints.delete, params);
  }
}