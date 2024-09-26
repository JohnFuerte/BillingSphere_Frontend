import 'dart:async';

import 'package:billingsphere/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/ledger/ledger_model.dart';
import '../../data/models/ledgerGroup/ledger_group_model.dart';
import '../../data/repository/ledger_group_respository.dart';
import '../../data/repository/ledger_repository.dart';
import '../DB_homepage.dart';
import '../DB_responsive/DB_desktop_body.dart';
import '../LG_homepage.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';
import 'LG_update.dart';

class LedgerHome extends StatefulWidget {
  const LedgerHome({super.key});

  @override
  State<LedgerHome> createState() => _LedgerHomeState();
}

class _LedgerHomeState extends State<LedgerHome> {
  // Ledger Service
  LedgerService ledgerService = LedgerService();
  final LedgerGroupService ledgerGroupService = LedgerGroupService();
  final TextEditingController _searchController = TextEditingController();

  // Fetched Ledger List
  List<Ledger> fectedLedgers = [];
  List<Ledger> fectedLedgers2 = [];
  List<LedgerGroup> selectedLGroup = [];
  LedgerGroupService ledgerGroupRepo = LedgerGroupService();

  ValueNotifier<String?> selectedId = ValueNotifier<String?>(null);
  final ValueNotifier<int> currentIndexNotifier = ValueNotifier<int>(0);
  Timer? _debounce;

  bool isLoading = false;
  FocusNode _focusNode = FocusNode();

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit"),
          content: const Text("Do you want to exit without saving?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DBHomePage(), // Replace with your dashboard screen widget
                  ),
                );
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchLedgers();
    fetchLedgerGroup();
    currentIndexNotifier.value = 1;
    RawKeyboard.instance.addListener(_handleKey);
  }

  Future<void> fetchLedgerGroup() async {
    try {
      final List<LedgerGroup> allLedger =
          await ledgerGroupRepo.fetchLedgerGroups();

      setState(() {
        selectedLGroup = allLedger;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchLedgers() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<Ledger> ledger = await ledgerService.fetchLedgers();
      setState(() {
        fectedLedgers = ledger;
        fectedLedgers2 = ledger;
        if (fectedLedgers.isNotEmpty) {
          selectedId.value = fectedLedgers[0].id;
        }
        isLoading = false;
      });
    } catch (error) {
      print('Failed to fetch ledger name: $error');
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      searchItem(query);
    });
  }

  void searchItem(String query) {
    if (query.isNotEmpty) {
      final lowerCaseQuery = query.toLowerCase();

      List<Ledger> filteredList = fectedLedgers2.where((ledger) {
        // Check if the ledger name contains the query
        bool nameMatch = ledger.name.toLowerCase().contains(lowerCaseQuery);

        // Fetch the ledger group by ID
        LedgerGroup? group = selectedLGroup.firstWhere(
          (group) => group.id == ledger.ledgerGroup,
          orElse: () =>
              LedgerGroup(id: '', name: ''), // Provide a default LedgerGroup
        );

        // Check if the ledger group name contains the query
        bool groupMatch = group.name.toLowerCase().contains(lowerCaseQuery);

        return nameMatch || groupMatch;
      }).toList();

      setState(() {
        fectedLedgers = filteredList;
      });
    } else {
      setState(() {
        fectedLedgers = fectedLedgers2;
      });
    }
  }

  String getLedgerGroup(String ledgerGroup) {
    for (var company in selectedLGroup) {
      if (company.id == ledgerGroup) {
        return company.name.toString();
      }
    }
    return '';
  }

  void deleteLedger() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('Delete'),
            content: const Text('Are you sure you want to delete this entry?'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Yes'),
                onPressed: () {
                  ledgerService.deleteLedger(selectedId.value!, context).then(
                      (value) => {Navigator.of(context).pop(), fetchLedgers()});
                },
              ),
              CupertinoDialogAction(
                child: const Text('No', style: TextStyle(color: Colors.red)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.f12) {
      // Execute your function when F3 key is pressed
      deleteLedger();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();

    _focusNode.dispose();

    RawKeyboard.instance.removeListener(_handleKey);
    super.dispose();
  }

  void _navigateToEditScreen(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LGUpdateEntry(
          id: id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalItems = fectedLedgers.length;
    final textAlignments = [
      TextAlign.center,
      TextAlign.left,
      TextAlign.left,
      TextAlign.right,
      TextAlign.right,
      TextAlign.center,
    ];

    return isLoading
        ? Scaffold(
            body: Center(
              child: Constants.loadingIndicator,
            ),
          )
        : RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (RawKeyEvent event) {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.escape) {
                _showExitConfirmationDialog();
              }
            },
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: AppBar(
                  title: const Text(
                    'LEDGERS MASTER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const DBMyDesktopBody(),
                        ),
                      );
                    },
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF0000FF),
                  centerTitle: true,
                ),
              ),
              body: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 890,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  height: 820,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              child: Text(
                                                "Search",
                                                style: GoogleFonts.poppins(
                                                  color:
                                                      const Color(0xFF6C0082),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.64,
                                                child: Container(
                                                  color: Colors.black,
                                                  height: 35,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextField(
                                                      controller:
                                                          _searchController,
                                                      onChanged:
                                                          _onSearchChanged,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        height: 0.8,
                                                      ),
                                                      // cursorHeight: 15,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  0.0), // Adjust the border radius as needed
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      0.0),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: Row(
                                          children: [
                                            _buildHeaderCell(
                                                'Sr', 1, TextAlign.center),
                                            _buildHeaderCell('Ledger Name', 4,
                                                TextAlign.left),
                                            _buildHeaderCell('Ledger Group', 3,
                                                TextAlign.left),
                                            _buildHeaderCell('Op. Balance', 2,
                                                TextAlign.left),
                                            _buildHeaderCell('Debit Balance', 2,
                                                TextAlign.center),
                                            _buildHeaderCell(
                                                'Active', 1, TextAlign.center),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: fectedLedgers.length,
                                          itemBuilder: (context, i) {
                                            final ledger = fectedLedgers[i];
                                            final cellData = [
                                              (i + 1).toString(),
                                              fectedLedgers[i].name,
                                              getLedgerGroup(
                                                  fectedLedgers[i].ledgerGroup),
                                              fectedLedgers[i]
                                                  .openingBalance
                                                  .toStringAsFixed(2),
                                              fectedLedgers[i]
                                                  .debitBalance
                                                  .toStringAsFixed(2),
                                              fectedLedgers[i].status,
                                            ];

                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedId.value = ledger.id;
                                                });

                                                currentIndexNotifier.value = i +
                                                    1; // Update currentIndex
                                              },
                                              onDoubleTap: () {
                                                _navigateToEditScreen(
                                                    ledger.id);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: selectedId.value ==
                                                          ledger.id
                                                      ? const Color(0xFF4169E1)
                                                      : null,
                                                  border: Border.all(),
                                                ),
                                                child: Row(
                                                  children: List.generate(
                                                      cellData.length, (j) {
                                                    return Expanded(
                                                      flex: [
                                                        1,
                                                        4,
                                                        3,
                                                        2,
                                                        2,
                                                        1
                                                      ][j], // Adjust flex as needed
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          border: Border(
                                                            right: BorderSide(
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          cellData[j],
                                                          textAlign:
                                                              textAlignments[j],
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: selectedId
                                                                        .value ==
                                                                    ledger.id
                                                                ? Colors.yellow
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      ValueListenableBuilder<int>(
                                        valueListenable: currentIndexNotifier,
                                        builder: (context, index, child) {
                                          return Text(
                                            'Row No: $index of $totalItems (Total: $totalItems)',
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF1A138F),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Shortcuts(
                        shortcuts: {
                          LogicalKeySet(LogicalKeyboardKey.f3):
                              const ActivateIntent(),
                          LogicalKeySet(LogicalKeyboardKey.f4):
                              const ActivateIntent(),
                        },
                        child: Focus(
                          autofocus: true,
                          onKey: (node, event) {
                            // ignore: deprecated_member_use
                            if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.f2) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LGHomePage(),
                                ),
                              );

                              return KeyEventResult.handled;
                            } else if (event is RawKeyDownEvent &&
                                event.logicalKey == LogicalKeyboardKey.f4) {
                              _navigateToEditScreen(
                                  selectedId.value.toString());

                              return KeyEventResult.handled;
                            }
                            return KeyEventResult.ignored;
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.099,
                            child: Column(
                              children: [
                                CustomList(
                                    Skey: "F2",
                                    name: "New",
                                    onTap: () {
                                      final result = Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LGHomePage(),
                                        ),
                                      );

                                      result.then((value) {
                                        if (value != null) {
                                          setState(() {
                                            fectedLedgers2.add(value);
                                            fectedLedgers.add(value);
                                          });
                                        }
                                      });
                                    }),
                                CustomList(
                                    Skey: "F4",
                                    name: "Edit",
                                    onTap: () {
                                      _navigateToEditScreen(
                                          selectedId.value.toString());
                                    }),

                                CustomList(
                                  Skey: "D",
                                  name: "Delete",
                                  onTap: deleteLedger,
                                ),
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
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(
                                //     Skey: "X",
                                //     name: "Export-Excel",
                                //     onTap: () {}),
                                // CustomList(
                                //     Skey: "B", name: "BulkUpt", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(
                                //     Skey: "F", name: "Filters", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(
                                //     Skey: "B", name: "Label Prn", onTap: () {}),
                                // CustomList(
                                //     Skey: "P",
                                //     name: "Envelop Prn",
                                //     onTap: () {}),
                                // CustomList(
                                //     Skey: "E", name: "Envelopes", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(
                                //     Skey: "O", name: "Op. Bal", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(
                                //     Skey: "S", name: "Statment", onTap: () {}),
                                // CustomList(
                                //     Skey: "",
                                //     name: "Dup Ledgers",
                                //     onTap: () {}),
                                // CustomList(
                                //     Skey: "", name: "Non/ Used", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                                // CustomList(Skey: "", name: "", onTap: () {}),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildHeaderCell(String text, int flex, TextAlign textAlign) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.black),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: const Color(0xFF6C0082),
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
        ),
      ),
    );
  }
}

class List1 extends StatelessWidget {
  final String? name;
  final String? Skey;
  final Function onPressed;
  const List1({Key? key, this.name, this.Skey, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        splashColor: Colors.grey[350],
        onTap: onPressed as void Function()?,
        child: Container(
          height: 35,
          width: w * 0.1,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  width: 2, color: Colors.purple[900] ?? Colors.purple),
              right: BorderSide(
                  width: 2, color: Colors.purple[900] ?? Colors.purple),
              left: BorderSide(
                  width: 2, color: Colors.purple[900] ?? Colors.purple),
              bottom: BorderSide(
                  width: 2, color: Colors.purple[900] ?? Colors.purple),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    Skey ?? "",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    name ?? " ",
                    style: TextStyle(
                      color: Colors.purple[900] ?? Colors.purple,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
