import 'dart:typed_data';

import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:webcontent_converter/webcontent_converter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
// import 'package:flutter_sunmi_printer/flutter_sunmi_printer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TestApp());
}

class TestApp extends StatefulWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  State<TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  // final r = json.decode(response.body);
  // int invoice_id = r['id'];
  WebViewController? ctrl;
  ScreenshotController screnCtrl = ScreenshotController();

  WidgetsToImageController screenCtrl = WidgetsToImageController();

  @override
  void initState() {
    super.initState();
    SunmiPrinter.bindingPrinter();
    // SunmiAidlPrint.bindPrinter();
  }

  /* void _print() async {
    SunmiPrinter.hr(); // prints a full width separator
    SunmiPrinter.text(
      'Test Sunmi Printer',
      styles: const SunmiStyles(align: SunmiAlign.center),
    );
    SunmiPrinter.hr();

// Test align
    SunmiPrinter.text(
      'left',
      styles: const SunmiStyles(bold: true, underline: true),
    );
    SunmiPrinter.text(
      'center',
      styles: const SunmiStyles(
          bold: true, underline: true, align: SunmiAlign.center),
    );
    SunmiPrinter.text(
      'right',
      styles: const SunmiStyles(
          bold: true, underline: true, align: SunmiAlign.right),
    );

// Test text size
    SunmiPrinter.text('Extra small text',
        styles: const SunmiStyles(size: SunmiSize.xs));
    SunmiPrinter.text('Medium text',
        styles: const SunmiStyles(size: SunmiSize.md));
    SunmiPrinter.text('Large text',
        styles: const SunmiStyles(size: SunmiSize.lg));
    SunmiPrinter.text('Extra large text',
        styles: const SunmiStyles(size: SunmiSize.xl));

// Test row
    SunmiPrinter.row(
      cols: [
        SunmiCol(text: 'col1', width: 4),
        SunmiCol(text: 'col2', width: 4, align: SunmiAlign.center),
        SunmiCol(text: 'col3', width: 4, align: SunmiAlign.right),
      ],
    );

// Test image
    // ByteData bytes = await rootBundle.load('assets/rabbit_black.jpg');
    // final buffer = bytes.buffer;
    // final imgData = base64.encode(Uint8List.view(buffer));
    // SunmiPrinter.image(imgData);

    // SunmiPrinter.emptyLines(3);
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.print,
            ),
            onPressed: () async {
              // _print();
              await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
              await SunmiPrinter.startTransactionPrint(true);
              await SunmiPrinter.printText('HELLO');
              await SunmiPrinter.lineWrap(1);
              await SunmiPrinter.exitTransactionPrint(true);
              await SunmiPrinter.cut();
            }),
        body: Stack(
          children: [
            WidgetsToImage(
              controller: screenCtrl,
              child: Screenshot(
                controller: screnCtrl,
                child: WebView(
                  initialUrl:
                      'https://test.6o9.live/api/Incoice/SellInvoice/20',
                  javascriptMode: JavascriptMode.unrestricted,
                  // initialUrl:
                  //     'https://test.6o9.live/api/Incoice/SellInvoice/$invoice_id',
                  onWebViewCreated: (c) {
                    ctrl = c;
                  },
                  onPageFinished: (c) async {
                    Uint8List? widgetCapture;
                    Uint8List? screenCapture;
                    Uint8List? webConv;
                    String html = await ctrl!.runJavascriptReturningResult(
                        "encodeURIComponent(document.documentElement.outerHTML)");
                    html = Uri.decodeComponent(html);
                    html = html.substring(1, html.length - 1);
                    webConv =
                        await WebcontentConverter.contentToImage(content: html);
                    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                    await SunmiPrinter.startTransactionPrint(true);
                    await SunmiPrinter.printImage(webConv);
                    await SunmiPrinter.lineWrap(1);
                    await SunmiPrinter.exitTransactionPrint(true);
                    await SunmiPrinter.cut();
                    //! ---------------------
                    // print('DONE');
                    widgetCapture = await screenCtrl.capture();
                    await SunmiPrinter.initPrinter();
                    // Uint8List byte = img!;
                    print(widgetCapture);
                    await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                    await SunmiPrinter.startTransactionPrint(true);
                    await SunmiPrinter.printImage(widgetCapture!);
                    await SunmiPrinter.lineWrap(1);
                    await SunmiPrinter.exitTransactionPrint(true);
                    await SunmiPrinter.cut();
                    print('DONE');

                    await screenCtrl.capture().then((value) async {
                      screenCapture = value;
                      await SunmiPrinter.initPrinter();
                      // Uint8List byte = img!;
                      print(screenCapture);
                      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
                      await SunmiPrinter.startTransactionPrint(true);
                      await SunmiPrinter.printImage(screenCapture!);
                      await SunmiPrinter.lineWrap(1);
                      await SunmiPrinter.exitTransactionPrint(true);
                      await SunmiPrinter.cut();
                      print('DONE');
                    });
                  },

                  // onPageStarted: (url) {},
                  // onWebViewCreated: (c) {
                  //   ctrl = c;
                  // },

                  /* onWebViewFinished: (url) async {
                        
                      },*/
                ),
                //   ),
                // ),
                // Container(
                //   height: 500.0,
                //   width: 300.0,
                //   color: img != null ? Colors.green : Colors.red,
                //   child: img != null
                //       ? Image.memory(
                //           img!,
                //           fit: BoxFit.fitHeight,
                //         )
                //       : null,
                // )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
