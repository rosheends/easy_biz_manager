
import 'package:easy_biz_manager/services/executor_service.dart';
import 'package:easy_biz_manager/utility/endpoints/invoice.dart';
import 'package:easy_biz_manager/utility/endpoints/project.dart';
import 'package:easy_biz_manager/utility/util.dart';

class InvoiceService {

  Future<dynamic> getInvoice(String id) async{
    ExecutorService service = ExecutorService();

    // [
    //   {
    //     'invoice_id' : '00001',
    //     'user' : 'Client A',
    //     'amount' : 2000.00,
    //     'status' : 'pending',
    //     'created_date' : '2022-11-11'
    //   },
    //   {
    //     'invoice_id' : '00002',
    //     'user' : 'Client B',
    //     'amount' : 3000.40,
    //     'status' : 'pending',
    //     'created_date' : '2022-11-12'
    //   },
    //   {
    //     'invoice_id' : '00003',
    //     'user' : 'Client C',
    //     'amount' : 400.00,
    //     'status' : 'paid',
    //     'created_date' : '2022-11-13'
    //   },
    // ];

    return service.getAsList(Util.getServiceHost() + InvoiceEndpoints.get.replaceAll("{id}", id));
  }

  Future<dynamic> getInvoices() async {
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + InvoiceEndpoints.getAll);
  }

  Future<dynamic> getClientInvoices(String id) async {
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + "${InvoiceEndpoints.getClientInvAll}/$id");
  }

  Future<dynamic> createInvoice(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.post(Util.getServiceHost() + InvoiceEndpoints.post, params);
  }
  Future<dynamic> getTotalExpense(String id) async {
    ExecutorService service = ExecutorService();
    return service.getAsList(Util.getServiceHost() + "${InvoiceEndpoints.getExp}/$id");
  }

  Future<dynamic> updateInvId(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.put(Util.getServiceHost() + InvoiceEndpoints.putInvId, params);
  }

  Future<dynamic> updateInvStatus(Map<String, dynamic> params) async{
    ExecutorService service = ExecutorService();
    return service.put(Util.getServiceHost() + InvoiceEndpoints.putInvStatus, params);
  }

}