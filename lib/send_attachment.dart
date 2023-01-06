import 'dart:math';

import 'package:easy_biz_manager/utility/util.dart';
import 'package:easy_biz_manager/views/mobile/mobile_home.dart';
import 'package:easy_biz_manager/views/web/web_home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SendAttachmentWidget extends StatefulWidget {
  const SendAttachmentWidget({Key? key}) : super(key: key);

  @override
  State<SendAttachmentWidget> createState() => _SendAttachmentWidgetState();
}

class _SendAttachmentWidgetState extends State<SendAttachmentWidget> {
  final controllerTo = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notify the payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(title: 'To', controller: TextEditingController(text: "rosheen.ds@gmail.com")),
            const SizedBox(height:16),
            buildTextField(title: 'Subject', controller: TextEditingController(text: "Payment Confirmation")),
            const SizedBox(height:16),
            buildTextField(title: 'Message', controller: controllerMessage, maxLines: 8),
            const SizedBox(height:32),
            ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50),
                textStyle: const TextStyle(fontSize: 20),
                ),
            child: const Text('SEND EMAIL'),
              // onPressed: () => launchEmail(
              //   toEmail: controllerTo.text,
              //   subject: controllerSubject.text,
              //   message: controllerMessage.text,
              // ),
              onPressed: () async{
                String email = Uri.encodeComponent('rosheen.ds@gmail.com');
                String subject = Uri.encodeComponent('Payment Confirmation');
                String body = Uri.encodeComponent(controllerMessage.text);
                Uri mail = Uri.parse("mailto:$email?subject=$subject&body=$body");
                if (await canLaunchUrl(mail)){
                  await launchUrl(mail);
                }else{
                  throw "Error occurred sending an email";
                }
                Util.routeNavigatorPush(context, MobileHomeWidget(), WebHomeWidget());
              },
            ),
          ],
        )
      ),
    );
  }

  Widget buildTextField({
  required String title,
    required TextEditingController controller,
    int maxLines = 1,
}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Please attach your receipt for the payment confirmation",
        ),
      ),
    ],
  );

}
