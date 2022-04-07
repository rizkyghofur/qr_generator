import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CreateQRCodePage extends StatefulWidget {
  CreateQRCodePage({Key key}) : super(key: key);

  @override
  State<CreateQRCodePage> createState() => _CreateQRCodePageState();
}

class _CreateQRCodePageState extends State<CreateQRCodePage> {
  final key = GlobalKey();
  String data = "";
  final textcontroller = TextEditingController();
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat QR Code'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: key,
              child: QrImage(
                data: data,
                version: QrVersions.auto,
                size: 250.0,
              ),
            ),
            Container(
              width: 350,
              child: TextField(
                controller: textcontroller,
                textInputAction: TextInputAction.done,
                maxLines: 1,
                onChanged: (teks) {
                  setState(() {
                    data = teks;
                  });
                },
                onSubmitted: (teks) {
                  setState(() {
                    data = teks;
                  });
                },
                onEditingComplete: () {
                  setState(() {
                    data = textcontroller.text;
                  });
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              child: Text(
                'Bagikan',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                try {
                  RenderRepaintBoundary boundary = key.currentContext
                      .findRenderObject() as RenderRepaintBoundary;
                  var image = await boundary.toImage();
                  ByteData byteData =
                      await image.toByteData(format: ImageByteFormat.png);
                  Uint8List pngBytes = byteData.buffer.asUint8List();
                  final appDir = await getApplicationDocumentsDirectory();
                  var datetime = DateTime.now();
                  file = await File('${appDir.path}/$datetime.png').create();
                  await file?.writeAsBytes(pngBytes);
                  await Share.shareFiles(
                    [file.path],
                    mimeTypes: ["image/png"],
                  );
                } catch (e) {
                  print(e.toString());
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
