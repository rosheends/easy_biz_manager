import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:http/http.dart' as http;
import 'views/mobile/mobile_home.dart';
import 'constant.dart' as constants;

// Class to map with database object
class Product {
  final String productCode;
  final String description;

  Product(this.productCode, this.description);
  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      json['product_code'],
      json['description'],
    );
  }
}

List<Product> parseProduct(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromMap(json)).toList();
}

Future<List<Product>> fetchProductList() async {
  final response = await http.get(
      Uri.parse('${constants.URI}product/'),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      });

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //return Project.fromMap(jsonDecode(response.body));
    return parseProduct(response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load products');
  }
}

class ManageProductsWidget extends StatefulWidget {
  const ManageProductsWidget({super.key});

  @override
  State<ManageProductsWidget> createState() => _ManageProductsWidgetState();
}

class _ManageProductsWidgetState extends State<ManageProductsWidget> {
  late Future<List<Product>> productList;
  late List<Product>? _productList = [];
  bool _loading = true;
  Future<Product>? deletedItem;
  Future<Product>? _newProduct;
  Future<bool>? _response;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _productList = (await fetchProductList());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
      _loading = false;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddProductWidget()),
              );
            },
          )
        ],
      ),
      // body: Center(
      //     child: loading == true
      //         ? const Center(
      //       child: SizedBox(
      //         width: 30,
      //         height: 30,
      //         child: CircularProgressIndicator(),
      //       ),
      //     )
      //         : ListView.builder(
      //         padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      //         itemCount: _productList!.length,
      //         itemBuilder: (context, index) {
      //
      //           return Card(
      //             elevation: 3,
      //             shadowColor: Colors.blue,
      //             margin: const EdgeInsets.fromLTRB(0.0, 2.0, 0.0, 6.0),
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(0.0),
      //             ),
      //
      //            // body: SingleChildScrollView(
      //             child: Column(
      //               children: [
      //                 Row(
      //                   //Center Column contents vertically,
      //                   crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
      //                   //mainAxisAlignment: MainAxisAlignment. center,
      //                   children: [
      //                     SizedBox(
      //                       width: 120,
      //                       child: Text(
      //                         _productList![index].productCode,
      //                         style: const TextStyle(
      //                           fontSize: 16,
      //                         ),
      //                         textAlign: TextAlign.left,
      //
      //                       ),
      //
      //                     ),
      //                     SizedBox(
      //                         width: 200,
      //                         child:Text(
      //                       _productList![index].description,
      //                       style: const TextStyle(fontSize: 16),
      //                       textAlign: TextAlign.left,
      //                     )),
      //                   ],
      //                 ),
      //                 const SizedBox(
      //                   height: 30.0,
      //                 ),
      //               ],
      //
      //             ),
      //
      //           );
      //         })),

      body: ListView.separated(

        // child: loading == true
        //     ? const Center(
        //   child: SizedBox(
        //     width: 30,
        //     height: 30,
        //     child: CircularProgressIndicator(),
        //   ),
        // )



        itemCount: _productList!.length,

    itemBuilder: (context, index) {



          return Dismissible( // Step 1
              //key: Key(_productList![index].toString()),
              key:  UniqueKey(),

              background: Container(color: Colors.red),
              secondaryBackground: Container(color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.delete),),
              //secondaryBackground: ,
              onDismissed: (direction) { // Step 2
                setState(() {
                  _productList!.removeAt(index);
                  _response = deleteProduct(_productList![index - 1].productCode);
                });
                if (_response != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${_productList![index]} successfully deleted')));
                }else{
                  return;
                }
              },

          child: ListTile(
            title: Text(_productList![index].productCode),
            subtitle: Text(_productList![index].description),
            selectedColor: Colors.blueAccent,



            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailProductWidget(product: _productList![index]),
                ),
              );
            },
            // When a user taps the ListTile, navigate to the DetailScreen.
            // Notice that you're not only creating a DetailScreen, you're
            // also passing the current todo through to it.
            trailing: const Icon(Icons.more_vert),


          ));
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
      drawer: const AppDrawerWidget(),
    );
  }
}

// Add Product functionality
class AddProductWidget extends StatefulWidget {
  const AddProductWidget({Key? key}) : super(key: key);

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  TextEditingController productCode = TextEditingController();
  TextEditingController description = TextEditingController();

  Future<Product>? _futureProduct;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Form(
          child: ListView(
            //  ListView(
              children: <Widget>[

                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: productCode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Product Code *',
                    ),
                    style: const TextStyle(fontSize: 16),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter the product code';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: description,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(110, 0, 110, 0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shadowColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                         // minimumSize: const Size(50, 50),
                        ),
                        child: const Text('Save', style: TextStyle(fontSize: 20)),
                        onPressed: () {
                          setState(() {
                            _futureProduct = createProduct(productCode.text, description.text);
                          }
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ManageProductsWidget()),
                          );
                        })),
              ]

          )),
    );
  }
}


// Detail and Edit Product functionality
class DetailProductWidget extends StatefulWidget {

  // In the constructor require a Product
  const DetailProductWidget({super.key, required this.product});

  // Declare a field that holds the product
  final Product product;

  @override
  State<DetailProductWidget> createState() => _DetailProductWidgetState();
}

class _DetailProductWidgetState extends State<DetailProductWidget> {

  final _formKey = GlobalKey<FormState>();
  bool _isEditModeEnabled = false;
  Future<Product>? _updatedProduct;

  TextEditingController productCode = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();



  // void _getLatestValue() {
  //   print('Second text field: ${descriptionCtrl.text}');
  // }
  
// @override
// void initState(){
//     super.initState();
//
//     //start listening to changes
//     descriptionCtrl.addListener((){setState(() {
//       _isEditModeEnabled = descriptionCtrl.text.isNotEmpty;
//     });});
//
// }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    descriptionCtrl.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // Use the Product to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.productCode),
      ),
      body: Form(
        child: ListView(
          //  ListView(
            children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            initialValue: widget.product.productCode,
            controller: productCode,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Product Code *',
            ),
            style: const TextStyle(fontSize: 16),
            enabled: false,

            // validator: (value) {
            //   if (value == null || value.isEmpty || value != widget.product.productCode) {
            //     _isEditModeEnabled = true;
            //     return 'Enter the product code';
            //   }
            //   return null;
            // },
          ),
        ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  initialValue: widget.product.description,
                  controller: descriptionCtrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  style: const TextStyle(fontSize: 16),

                  validator: (value) {
                    if (value == null || value.isEmpty || value != widget.product.description) {
                      _isEditModeEnabled = true;
                    }
                    return null;
                  },

                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(110, 0, 110, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shadowColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                       // minimumSize: Size(50, 50);
                      ),
                      onPressed: _isEditModeEnabled ? () {
    setState(() {
    //_updatedProduct = createProduct(productCode.text, description.text);
    });
                      } : null,
                      child: const Text('Save'),

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => const ManageProductsWidget()),
                        // );
                      )),
      ],
        ),
      ),
    );
  }

  void submitData() {

  }

}

Future<Product> createProduct(String productCode, description) async {
  final response = await http.post(
    Uri.parse('${constants.URI}product/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'product_code': productCode,
      'description': description,
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Product.fromMap(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create the product.');
  }
}

Future<bool> deleteProduct(String productCode) async {
  final response = await http.post(
    Uri.parse('${constants.URI}product/$productCode'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return true;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    return false;
  }
}

