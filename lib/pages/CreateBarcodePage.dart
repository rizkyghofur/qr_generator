import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CreateBarcodePage extends StatefulWidget {
  CreateBarcodePage({Key key}) : super(key: key);

  @override
  State<CreateBarcodePage> createState() => _CreateBarcodePageState();
}

class _CreateBarcodePageState extends State<CreateBarcodePage> {
  final key = GlobalKey();
  String data = "";
  final textcontroller = TextEditingController();
  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Barcode'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: key,
              child: Container(
                width: 350,
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: data,
                ),
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
