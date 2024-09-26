import 'package:billingsphere/views/DB_widgets/custom_footer.dart';
import 'package:billingsphere/views/DB_widgets/custom_table.dart';
import 'package:billingsphere/views/DB_widgets/sections/account_report.dart';
import 'package:billingsphere/views/DB_widgets/sections/master_report.dart';
import 'package:billingsphere/views/DB_widgets/sections/reminders.dart';
import 'package:billingsphere/views/DB_widgets/sections/todo_list.dart';
import 'package:billingsphere/views/DB_widgets/sections/transaction.dart';
import 'package:billingsphere/views/RV_responsive/RV_desktopBody.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../PM_responsive/payment_desktop.dart';
import '../SE_responsive/SE_desktop_body.dart';

class DBMyMobileBody extends StatelessWidget {
  const DBMyMobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    final List<Map<String, dynamic>> menuItems = [
      {'text': 'Accounts', 'icon': CupertinoIcons.person},
      {'text': 'Inventory', 'icon': CupertinoIcons.archivebox},
      {'text': 'SMS', 'icon': CupertinoIcons.chat_bubble},
      {'text': 'Admin', 'icon': CupertinoIcons.gear},
      {'text': 'Utility', 'icon': CupertinoIcons.settings},
    ];

    final List<Map<String, dynamic>> transactions = [
      {
        'text': 'Sales',
        'icon': CupertinoIcons.cart,
        'page': const SEMyDesktopBody()
      },
      {
        'text': 'Receipt',
        'icon': CupertinoIcons.doc,
        'page': RVDesktopBody(),
      },
      {
        'text': 'Purchase',
        'icon': CupertinoIcons.shopping_cart,
        'page': PMMyPaymentDesktopBody()
      },
      {
        'text': 'Payment',
        'icon': CupertinoIcons.creditcard,
        'page': PMMyPaymentDesktopBody()
      },
      {
        'text': 'Receivable',
        'icon': CupertinoIcons.money_dollar_circle,
        'page': PMMyPaymentDesktopBody()
      },
      {
        'text': 'Payable',
        'icon': CupertinoIcons.money_dollar,
        'page': PMMyPaymentDesktopBody()
      },
    ];

    final List<Map<String, dynamic>> accountReport = [
      {'text': 'Trial Balance', 'icon': CupertinoIcons.chart_bar},
      {'text': 'Ledger Stmnt.', 'icon': CupertinoIcons.doc_text},
      {'text': 'Voucher Regi.', 'icon': CupertinoIcons.book},
      {'text': 'Inventory Reports', 'icon': CupertinoIcons.doc_plaintext},
      {'text': 'Stock Status', 'icon': CupertinoIcons.cube_box},
      {'text': 'Stock Vouchers', 'icon': CupertinoIcons.cube},
      {'text': 'Sales', 'icon': CupertinoIcons.cart},
    ];

    final List<Map<String, dynamic>> masterReport = [
      {'text': 'Items', 'icon': CupertinoIcons.cube_box_fill},
      {'text': 'Ledgers', 'icon': CupertinoIcons.doc_plaintext},
    ];

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: CupertinoButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(CupertinoIcons.list_bullet),
        ),
        title: Text(
          'DASH BOARD',
          style: GoogleFonts.poppins(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          CupertinoButton(
            onPressed: () {
              // Add your menu logic here
            },
            child: const Icon(
              CupertinoIcons.square_arrow_right,
              color: Colors.black,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF6C0082),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.fitHeight,
                        // color: const Color(0xFF6C0082),
                      )),
                  const SizedBox(height: 10),
                  Text(
                    'Main Office',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'nagparayd@gmail.com',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ...menuItems.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  dense: true,
                  leading: Icon(item['icon'], color: Colors.black54),
                  title: Text(
                    item['text'],
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF6C0082),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    // Handle the tap event
                    print('Tapped on ${item['text']}');
                  },
                ),
              );
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Transactions',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RVDesktopBody(),
                    ),
                  );
                },
                child: const Text('Receipt'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PMMyPaymentDesktopBody(),
                    ),
                  );
                },
                child: const Text('Payment'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 220,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 3.0,
                      mainAxisSpacing: 3.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => transactions[index]['page'],
                            ),
                          );
                        },
                        child: SizedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red.withOpacity(0.5),
                                child: Icon(
                                  transactions[index]['icon'],
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 100,
                                child: Text(transactions[index]['text'],
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 14,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ' Account Reports',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 220,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: accountReport.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.withOpacity(0.5),
                            child: Icon(
                              accountReport[index]['icon'],
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              accountReport[index]['text'],
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  ' Master Reports',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 100,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: masterReport.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.amber.withOpacity(0.5),
                            child: Icon(
                              masterReport[index]['icon'],
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 100,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              masterReport[index]['text'],
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       border: Border.all(
              //         color: Colors.black,
              //         width: 2.0,
              //       ),
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.start,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Container(
              //               width: MediaQuery.of(context).size.width,
              //               padding: const EdgeInsets.all(8.0),
              //               decoration: const BoxDecoration(
              //                 color: Colors.red,
              //               ),
              //               child: const Text(
              //                 'QUICK ACCESS',
              //                 textAlign: TextAlign.center,
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: 20,
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //               ),
              //             ),
              //             const SizedBox(height: 5),
              //             const Row(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //               children: [
              //                 Transaction(),
              //                 Spacer(),
              //                 AccountReport(),
              //               ],
              //             ),
              //             const MasterReport(),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),

              const CustomTable(),
              const TodoList(),
              const Reminders(),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const CustomFooter(),
    );
  }
}
