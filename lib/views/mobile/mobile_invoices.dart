import 'dart:typed_data';

import 'package:easy_biz_manager/app_drawer.dart';
import 'package:easy_biz_manager/services/invoice_service.dart';
import 'package:easy_biz_manager/utility/invoice_template.dart';
import 'package:easy_biz_manager/utility/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class MobileInvoiceWidget extends StatefulWidget {
  const MobileInvoiceWidget({super.key});

  @override
  State<MobileInvoiceWidget> createState() => _MobileInvoiceWidgetState();
}

class _MobileInvoiceWidgetState extends State<MobileInvoiceWidget> {
  late List<dynamic>? _invoices = [];
  bool _loading = true;
  InvoiceService service = InvoiceService();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    List<dynamic> temp = (await service.getInvoices());
    setState(() {
      _loading = false;
      _invoices = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {

            },
          )
        ],
      ),

      body: _loading ? Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ),
      ) : GridView.count(
          padding: const EdgeInsets.all(10),
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          children: _invoices!.map((data) {
            return GestureDetector(
              onTap: () async {
                Map<String, dynamic> invoice = await service.getInvoice(data['id'].toString());
                Uint8List pdfInBytes = await generateInvoice(invoice);
                await Printing.sharePdf(bytes: pdfInBytes, filename: '${data['id'].toString().padLeft(4, '0')}.pdf');
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            data['id'].toString().padLeft(4, '0'),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic
                                )
                            ),
                          ),
                          Text(
                            DateFormat.yMMMd().format(DateTime.parse(data['invoice_date'])),
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                    color: Colors.blue[900],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              data['client_name'].toString(),
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 100,
                              padding: const EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: data['payment_status'].toString().toLowerCase() == 'paid' ? Colors.green : Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Text(
                                data['payment_status'].toString().toUpperCase(),
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        )
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        Util.printAmount(data['total_amount']),
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 18,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
      drawer: const AppDrawerWidget(),
    );
  }
}
