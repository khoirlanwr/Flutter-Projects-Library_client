import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:oktoast/oktoast.dart';

class HalamanPrint extends StatefulWidget {

  static const String id = "HALAMANPRINT";

  // Put the constructor:
  // String: idUser 
  // String: nama mahasiswa
  // String: judul buku  
  final String idUser;
  final String namaMhs;
  final String judulBuku;

  HalamanPrint({this.idUser, this.namaMhs, this.judulBuku}); 

  @override
  _HalamanPrintState createState() => _HalamanPrintState();
}

class _HalamanPrintState extends State<HalamanPrint> {

  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];

  @override
  void initState() {
    super.initState();

    // debug
    print(widget.namaMhs);
    print(widget.judulBuku);

    printerManager.scanResults.listen((devices) { 
      print('UI: Devices found ${devices.length}');
      setState(() {
        _devices = devices;
      });      
    });
  }

  void _startScanDevices() {
    setState(() {
      _devices = [];
    });
    printerManager.startScan(Duration(seconds: 120));
  }

  void _stopScanDevices() {
    printerManager.stopScan();
  }

  static String timeParser(String time) {
    // String timeSubString1 = time.substring(0, 17);
    // String timeFinal = timeSubString1 + "00Z";
    // return timeFinal;

    String date = time.substring(0, 10);
    String timeHours = time.substring(11, 16);

    String timeFinal = timeHours + " " + date;
    return timeFinal;
  }

  Future<Ticket> testTicket(PaperSize paper) async {
    final Ticket ticket = Ticket(paper);

    String timeBorrowedBook = DateTime.now().toIso8601String();
    timeBorrowedBook = timeParser(timeBorrowedBook);    

    var now = new DateTime.now();
    var timeReturnedBook = now.add(new Duration(days: 14));
    String timeReturnedBooks = timeParser(timeReturnedBook.toIso8601String());

    ticket.text('Data Peminjam: ', styles: PosStyles(bold: true));
    ticket.text('NRP: ' + widget.idUser);
    ticket.text('Nama: ' + widget.namaMhs);

    ticket.text('Data Buku: ', styles: PosStyles(bold: true));
    ticket.text('Judul: ' + widget.judulBuku);

    ticket.text('Waktu: ', styles: PosStyles(bold: true));
    ticket.text('Peminjaman: ' + timeBorrowedBook);
    ticket.text('Pengembalian: ' + timeReturnedBooks);

    // ticket.text(
    //     'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
    //     styles: PosStyles(codeTable: PosCodeTable.westEur));
    // ticket.text('Special 2: blåbærgrød',
    //     styles: PosStyles(codeTable: PosCodeTable.westEur));

    // ticket.text('Bold text', styles: PosStyles(bold: true));
    // ticket.text('Reverse text', styles: PosStyles(reverse: true));
    // ticket.text('Underlined text',
    //     styles: PosStyles(underline: true), linesAfter: 1);
    // ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
    // ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
    // ticket.text('Align right',
    //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    // ticket.row([
    //   PosColumn(
    //     text: 'col3',
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col6',
    //     width: 6,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    //   PosColumn(
    //     text: 'col3',
    //     width: 3,
    //     styles: PosStyles(align: PosAlign.center, underline: true),
    //   ),
    // ]);

    // ticket.text('Text size 200%',
    //     styles: PosStyles(
    //       height: PosTextSize.size2,
    //       width: PosTextSize.size2,
    //     ));


    // Print barcode
    // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    // ticket.barcode(Barcode.upcA(barData));

    ticket.feed(2);

    ticket.cut();
    return ticket;
  }

  void _testPrint(PrinterBluetooth printer) async {
    printerManager.selectPrinter(printer);

    // select papersize
    const PaperSize paper = PaperSize.mm58;

    // Test print
    final PosPrintResult res = await printerManager.printTicket(await testTicket(paper));

    showToast(res.msg);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Print"),
      ),
      body: ListView.builder(
          itemCount: _devices.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () => _testPrint(_devices[index]),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.print),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_devices[index].name ?? ''),
                              Text(_devices[index].address),
                              Text(
                                'Click to print a test receipt',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          }),
      floatingActionButton: StreamBuilder<bool>(
        stream: printerManager.isScanningStream,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data) {
            return FloatingActionButton(
              child: Icon(Icons.stop),
              onPressed: _stopScanDevices,
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
              child: Icon(Icons.search),
              onPressed: _startScanDevices,
            );
          }
        },
      ),
    );
  }
}