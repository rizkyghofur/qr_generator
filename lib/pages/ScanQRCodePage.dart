import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQRCodePage extends StatefulWidget {
  ScanQRCodePage({Key key}) : super(key: key);

  @override
  State<ScanQRCodePage> createState() => _ScanQRCodePageState();
}

class _ScanQRCodePageState extends State<ScanQRCodePage> {
  String _scanQRBarcode = 'Tidak diketahui';

  Future<void> scanQR() async {
    String qrScanRes;
    try {
      qrScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Batal', true, ScanMode.QR);
      print(qrScanRes);
    } on PlatformException {
      qrScanRes = 'Gagal mendapat versi platform.';
    }
    if (!mounted) return;
    setState(() {
      _scanQRBarcode = qrScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => scanQR(),
              child: Text(
                'Mulai Scan QR Code',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Text(
              'Hasil scan : $_scanQRBarcode\n',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
