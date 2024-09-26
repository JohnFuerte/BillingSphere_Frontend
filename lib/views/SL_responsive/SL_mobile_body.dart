import 'package:billingsphere/views/SL_widgets/SL_M_Button.dart';
import 'package:billingsphere/views/SL_widgets/SL_M_appbar.dart';
import 'package:billingsphere/views/SL_widgets/SL_M_table_data_helper.dart';
import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

class SLMyMobileBody extends StatefulWidget {
  const SLMyMobileBody({super.key});

  @override
  State<SLMyMobileBody> createState() => _SLMyMobileBodyState();
}

class _SLMyMobileBodyState extends State<SLMyMobileBody> {
  LinkedScrollControllerGroup controllerGroup = LinkedScrollControllerGroup();

  ScrollController? headerScrollController;
  ScrollController? dataScrollController;
  @override
  void initState() {
    super.initState();
    headerScrollController = controllerGroup.addAndGet();
    dataScrollController = controllerGroup.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SLMCustomAppBar(text: 'Stock List Report'),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock List Report',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      decorationThickness:
                          MediaQuery.of(context).size.width * 0.005,
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            tableContent(),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              child: tableHeader(),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.width * 0.01,
                            bottom: MediaQuery.of(context).size.width * 0.01,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SLMButtons(
                                width: MediaQuery.of(context).size.width * 0.30,
                                height: 30.0,
                                text: 'Report',
                              ),
                              SLMButtons(
                                width: MediaQuery.of(context).size.width * 0.30,
                                height: 30.0,
                                text: 'Print',
                              ),
                              SLMButtons(
                                width: MediaQuery.of(context).size.width * 0.30,
                                height: 30.0,
                                text: 'Find',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SLMButtons(
                                width: MediaQuery.of(context).size.width * 0.47,
                                height: 30.0,
                                text: 'Export-Excel',
                              ),
                              SLMButtons(
                                width: MediaQuery.of(context).size.width * 0.47,
                                height: 30.0,
                                text: 'Find Next',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.width * 0.01),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SLMButtons(
                                width: MediaQuery.of(context).size.width * 0.47,
                                height: 30.0,
                                text: 'Copy Sr\'s',
                              ),
                              SLMButtons(
                                width: MediaQuery.of(context).size.width * 0.47,
                                height: 30.0,
                                text: 'Prnt B/Code',
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
          ],
        ),
      ),
    );
  }

  Widget tableContent() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      height: MediaQuery.of(context).size.height * 0.6,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: dataScrollController,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.white),
                  dataRowColor: MaterialStateProperty.all(Colors.white),
                  border: const TableBorder(
                    verticalInside: BorderSide(color: Colors.black),
                  ),
                  columns: SLTableDataHelper.kTableColumnsList.map((e) {
                    return DataColumn(
                      label: SizedBox(
                        width: e.width ?? 0,
                        child: Text(
                          e.title ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  rows: List.generate(100, (index) {
                    return DataRow(cells: [
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[0].width,
                          child: Text(
                            '${index + 1}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[1].width,
                          child: const Text(
                            '11,500.00',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[2].width,
                          child: const Text(
                            '0',
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[3].width,
                          child: const Text(
                            '0.00',
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[4].width,
                          child: const Text(
                            '0',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[5].width,
                          child: const Text(
                            'N/A',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[6].width,
                          child: const Text(
                            '351756051524002',
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[7].width,
                          child: const Text(
                            'N/A',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[8].width,
                          child: const Text(
                            'N/A',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: SLTableDataHelper.kTableColumnsList[9].width,
                          child: const Text(
                            'NETCOM',
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ]);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableHeader() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: headerScrollController,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.white),
              dataRowColor: MaterialStateProperty.all(Colors.white),
              border: const TableBorder(
                verticalInside: BorderSide(color: Colors.black),
              ),
              columns: SLTableDataHelper.kTableColumnsList
                  // .getRange(1, SLTableDataHelper.kTableColumnsList.length)
                  .map((e) {
                return DataColumn(
                  label: SizedBox(
                    child: Text(e.title ?? ''),
                    width: e.width ?? 0,
                  ),
                );
              }).toList(),
              rows: const [],
            ),
          ),
        ),
      ],
    );
  }
}
