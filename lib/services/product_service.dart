import '../utility/endpoints/product.dart';
import '../utility/util.dart';
import 'executor_service.dart';

class ProductService {

  Future<dynamic> getProducts() async {
    ExecutorService service = ExecutorService();
    return service.get(Util.getServiceHost() + ProductEndpoints.get);
  }
}