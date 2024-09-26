import 'package:billingsphere/views/Daily_cash_resposive/daily_cash_create.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/dailyCash/daily_cash_model.dart';
import '../../data/repository/daily_cash_repository.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'daily_cash_edit.dart';
import 'daily_cash_receipt.dart';

class DailyCashMaster extends StatefulWidget {
  const DailyCashMaster({super.key});

  @override
  State<DailyCashMaster> createState() => _DailyCashMasterState();
}

class _DailyCashMasterState extends State<DailyCashMaster> {
  List<DailyCashEntry> dailyCashModel = [];
  int? activeIndex;
  bool isLoading = false;
  DailyCashServices dailyCashRepo = DailyCashServices();
  String? selectedId;
  String activeid = '';
  void _handleTap(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  String? userGroup;

  Future<void> getDailyGroups() async {
    setState(() {
      isLoading = true;
    });
    final List<DailyCashEntry> dailyModels =
        await dailyCashRepo.fetchDailyCash();

    setState(() {
      dailyCashModel = dailyModels;

      if (dailyCashModel.isNotEmpty) {
        selectedId = dailyCashModel[0].id;
      }
    });
    // print('PRINT $dailyCashModel');
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDailyGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: const Color.fromARGB(255, 10, 51, 234),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.arrow_left,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Center(
          child: Text(
            "DAILY CASH MASTER",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: 640,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Center(
                  child: Container(
                    height: 600,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Search",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    color: Colors.black,
                                    height: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (value) {
                                          // setState(() {
                                          //   filterUserGroups(value);
                                          // });
                                        },
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          height: 0.8,
                                        ),
                                        // cursorHeight: 15,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(0.0),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                0.0), // Adjust the border radius as needed
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Table(
                          columnWidths: const {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(4),
                            2: FlexColumnWidth(4),
                            3: FlexColumnWidth(4),
                            4: FlexColumnWidth(4),
                            5: FlexColumnWidth(4),
                          },
                          border: TableBorder.all(color: Colors.grey),
                          children: [
                            TableRow(
                              children: [
                                TableCell(
                                  child: Text(
                                    "Sr.",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Date",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Cashier",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Actual",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "System",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                TableCell(
                                  child: Text(
                                    "Diff",
                                    style: GoogleFonts.poppins(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 500,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: dailyCashModel.length,
                            itemBuilder: (context, index) {
                              int itemNumber = index + 1;
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                elevation: 1,
                                child: ListTile(
                                  hoverColor:
                                      const Color.fromARGB(255, 4, 12, 241),
                                  tileColor: activeIndex == index
                                      ? const Color.fromARGB(255, 4, 12, 241)
                                      : Colors.white,
                                  title: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        child: Text(
                                          "$itemNumber",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: activeIndex == index
                                                ? Colors.yellow
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.11,
                                        child: Text(
                                          dailyCashModel[index].date,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: activeIndex == index
                                                ? Colors.yellow
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.11,
                                        child: Text(
                                          dailyCashModel[index].cashier,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: activeIndex == index
                                                ? Colors.yellow
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.11,
                                        child: Text(
                                          dailyCashModel[index]
                                              .actualcash
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: activeIndex == index
                                                ? Colors.yellow
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: Text(
                                          dailyCashModel[index]
                                              .systemcash
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: activeIndex == index
                                                ? Colors.yellow
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        child: Text(
                                          dailyCashModel[index]
                                              .excesscash
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: activeIndex == index
                                                ? Colors.yellow
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    _handleTap(index);
                                    activeid = dailyCashModel[index].id;
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'ROW COUNT: ${dailyCashModel.length}',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Shortcuts(
                shortcuts: {
                  LogicalKeySet(LogicalKeyboardKey.f3): const ActivateIntent(),
                  LogicalKeySet(LogicalKeyboardKey.f4): const ActivateIntent(),
                },
                child: Focus(
                  autofocus: true,
                  onKey: (node, event) {
                    if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.f3) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DailyCashCreate(),
                        ),
                      );
                      return KeyEventResult.handled;
                    } else if (event is RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.f4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DailyCashEdit(
                            dailyID: activeid,
                          ),
                        ),
                      );
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.099,
                    child: Column(
                      children: [
                        CustomList(
                          Skey: "F3",
                          name: "New",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DailyCashCreate(),
                              ),
                            );
                          },
                        ),
                        CustomList(
                          Skey: "F4",
                          name: "Edit",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DailyCashEdit(
                                  dailyID: activeid,
                                ),
                              ),
                            );
                          },
                        ),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(
                            Skey: "D",
                            name: "Delete",
                            onTap: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Delete'),
                                    content: const Text(
                                        'Are you sure you want to delete this entry?'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('Yes'),
                                        onPressed: () {
                                          DailyCashServices dailyCashServices =
                                              DailyCashServices();

                                          dailyCashServices
                                              .deleteDailyCash(
                                                  activeid, context)
                                              .then((value) => {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const DailyCashMaster(),
                                                      ),
                                                    )
                                                  });
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text('No',
                                            style:
                                                TextStyle(color: Colors.red)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                        CustomList(
                            Skey: "X", name: "Export-Excel", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(
                            Skey: "P",
                            name: "Print",
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => DailyCashReceipt(
                                    dailyCashID: activeid,
                                    title: 'Print Daily Cash Receipt',
                                  ),
                                ),
                              );
                            }),
                        CustomList(
                            Skey: "M", name: "MultiUpdate", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                        CustomList(Skey: "", name: "", onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
