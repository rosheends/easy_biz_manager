import '../utility/endpoints/dashboard.dart';
import '../utility/util.dart';
import 'executor_service.dart';

class DashboardService{
  Future<dynamic> getExpenses() async{
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + DashboardEndpoints.getAll);
  }
}