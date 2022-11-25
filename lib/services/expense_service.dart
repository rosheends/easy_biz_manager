import '../utility/endpoints/Expense.dart';
import '../utility/util.dart';
import 'executor_service.dart';

class ExpenseService {

  Future<dynamic> getExpenses() async{
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + ExpenseEndpoints.get);
  }

  Future<dynamic> getRequests(String status) async{
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + ExpenseEndpoints.getReq.replaceAll("{status}", status));
  }

  Future<dynamic> createExpense(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.post(Util.getServiceHost() + ExpenseEndpoints.post, params);
  }

  Future<dynamic> updateExpense(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.put(Util.getServiceHost() + ExpenseEndpoints.put, params);
  }

  Future<dynamic> updateStatus(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.put(Util.getServiceHost() + ExpenseEndpoints.putStatus, params);
  }

  Future<bool> deleteExpense(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.delete(Util.getServiceHost() + ExpenseEndpoints.delete, params);
  }
}