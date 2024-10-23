import 'package:billingsphere/views/Stock_Status/filter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportStatus extends StatefulWidget {
  const ReportStatus({super.key});

  @override
  State<ReportStatus> createState() => _ReportStatusState();
}

class _ReportStatusState extends State<ReportStatus> {
  bool checkBox1 = false;
  bool checkBox2 = false;
  bool checkBox3 = false;
  bool checkBox4 = false;
  bool checkBox5 = false;
  bool checkBox6 = false;
  bool checkBox7 = false;
  bool checkBox8 = false;
  bool checkBox9 = false;

  FilterCriteria filterCriteria = FilterCriteria();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
      if (constraint.maxWidth < 600) {
        return mobileWidget();
      } else if (constraint.maxWidth >= 600 && constraint.maxWidth < 1200) {
        return desktopWidget();
      } else {
        return desktopWidget();
      }
    });
  }

  // For Mobile Screen
  Widget mobileWidget() {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Stock Status"),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: MyFont(
                    text: "Report Critaria",
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DataWidgetMobile(
                  text: "As On",
                  textwidth: MediaQuery.of(context).size.width / 8,
                  child: Container(),
                ),
                DataWidgetMobile(
                  text: "Stock Grouping",
                  selectedValue: filterCriteria.stockGrouping,
                  item: DropDownValue.stockGrouping,
                  onChanged: (value) {
                    setState(() {
                      filterCriteria.stockGrouping = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                const MyFont(
                  text: "Filter",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                MyCheckBox(
                    value: checkBox1,
                    text: "Show Individual Item Stock",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox1 = newvalue!;
                      });
                    }),
                MyCheckBox(
                    value: checkBox2,
                    text: "Include Zero Value Item",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox2 = newvalue!;
                      });
                    }),
                MyCheckBox(
                    value: checkBox3,
                    text: "Show Reorder Level Only",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox3 = newvalue!;
                      });
                    }),
                MyCheckBox(
                    value: checkBox4,
                    text: "Show Item with Negative Qty Only",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox4 = newvalue!;
                      });
                    }),
                MyCheckBox(
                    value: checkBox5,
                    text: "Display Print Name of Item",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox5 = newvalue!;
                      });
                    }),
                MyCheckBox(
                    value: checkBox6,
                    text: "Show Item with © Qty Only",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox6 = newvalue!;
                      });
                    }),
                MyCheckBox(
                    value: checkBox7,
                    text: "Show Rate with Tax",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox7 = newvalue!;
                      });
                    }),
                MyCheckBox(
                    value: checkBox8,
                    text: "Show Code No",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox8 = newvalue!;
                      });
                    }),
                MyCheckBox(
                    value: checkBox9,
                    text: "Show Rate/Valuation",
                    onchanged: (newvalue) {
                      setState(() {
                        checkBox9 = newvalue!;
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(filterCriteria);
                      },
                      child: Container(
                        height: 35,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          border: Border.all(
                            color: Colors.amber,
                          ),
                        ),
                        child: const Center(
                            child: MyFont(
                          text: "Save [F4]",
                          color: Colors.black,
                        )),
                      ),
                    ),
                    const SizedBox(
                      width: 1.5,
                    ),
                    Container(
                      height: 35,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade100,
                        border: Border.all(
                          color: Colors.amber,
                        ),
                      ),
                      child: const Center(
                          child: MyFont(
                        text: "Close",
                        color: Colors.black,
                      )),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ));
  }

  // For Desktop and Tablet Screen
  Widget desktopWidget() {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Stock Status"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: s.width > 1200 ? s.width / 2 : s.width / 1.2,
              height: s.width > 1200 ? s.height / 1.14 : 420,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: MyFont(
                      text: "Report Critaria",
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DataWidget(
                    text: "As On",
                    textwidth: MediaQuery.of(context).size.width / 8,
                    child: Container(),
                  ),
                  DataWidget(
                    text: "Stock Grouping",
                    selectedValue: filterCriteria.stockGrouping,
                    item: DropDownValue.stockGrouping,
                    onChanged: (value) {
                      setState(() {
                        filterCriteria.stockGrouping = value;
                      });
                    },
                  ),
                  // DataWidget(
                  //     text: "Valuation",
                  //     textwidth: MediaQuery.of(context).size.width / 6,
                  //     selectedValue: filterCriteria.valuation,
                  //     item: stockgroupingitems,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         filterCriteria.valuation = value;
                  //       });
                  //     }),
                  const SizedBox(
                    height: 8,
                  ),
                  const MyFont(
                    text: "Filter",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  // DataWidget(
                  //     text: "Group",
                  //     selectedValue: filterCriteria.group,
                  //     item: stockgroupingitems,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         filterCriteria.group = value;
                  //       });
                  //     }),
                  // DataWidget(
                  //     text: "Brand",
                  //     selectedValue: filterCriteria.brand,
                  //     item: stockgroupingitems,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         filterCriteria.brand = value;
                  //       });
                  //     }),
                  const SizedBox(
                    height: 15,
                  ),
                  // DataWidget(
                  //     text: "Item Name",
                  //     selectedValue: filterCriteria.itemName,
                  //     item: stockgroupingitems,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         filterCriteria.itemName = value;
                  //       });
                  //     }),
                  // DataWidget(
                  //     text: "Rack/Bin",
                  //     selectedValue: filterCriteria.rack,
                  //     item: stockgroupingitems,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         filterCriteria.rack = value;
                  //       });
                  //     }),
                  // DataWidget(
                  //     text: "Tax Category",
                  //     selectedValue: filterCriteria.taxCategory,
                  //     item: stockgroupingitems,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         filterCriteria.taxCategory = value;
                  //       });
                  //     }),
                  Row(
                    children: [
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox1,
                            text: "Show Individual Item Stock",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox1 = newvalue!;
                              });
                            }),
                      ),
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox2,
                            text: "Include Zero Value Item",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox2 = newvalue!;
                              });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox3,
                            text: "Show Reorder Level Only",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox3 = newvalue!;
                              });
                            }),
                      ),
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox4,
                            text: "Show Item with Negative Qty Only",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox4 = newvalue!;
                              });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox5,
                            text: "Display Print Name of Item",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox5 = newvalue!;
                              });
                            }),
                      ),
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox6,
                            text: "Show Item with © Qty Only",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox6 = newvalue!;
                              });
                            }),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox7,
                            text: "Show Rate with Tax",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox7 = newvalue!;
                              });
                            }),
                      ),
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox8,
                            text: "Show Code No",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox8 = newvalue!;
                              });
                            }),
                      ),
                      Expanded(
                        child: MyCheckBox(
                            value: checkBox9,
                            text: "Show Rate/Valuation",
                            onchanged: (newvalue) {
                              setState(() {
                                checkBox9 = newvalue!;
                              });
                            }),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop(filterCriteria);
                        },
                        child: Container(
                          height: 35,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            border: Border.all(
                              color: Colors.amber,
                            ),
                          ),
                          child: const Center(
                              child: MyFont(
                            text: "Save [F4]",
                            color: Colors.black,
                          )),
                        ),
                      ),
                      const SizedBox(
                        width: 1.5,
                      ),
                      Container(
                        height: 35,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          border: Border.all(
                            color: Colors.amber,
                          ),
                        ),
                        child: const Center(
                            child: MyFont(
                          text: "Close",
                          color: Colors.black,
                        )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DataWidget extends StatelessWidget {
  final String text;
  final TextEditingController? controller;
  final double? textwidth;
  final List<String>? item;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final Widget? child;

  const DataWidget({
    super.key,
    required this.text,
    this.controller,
    this.textwidth,
    this.child,
    this.item,
    this.onChanged,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: Row(
        children: [
          SizedBox(width: 120, child: MyFont(text: text)),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 30,
              child: child ??
                  DropdownButtonFormField(
                    value: selectedValue,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    items: item!.map((value) {
                      return DropdownMenuItem(value: value, child: Text(value));
                    }).toList(),
                    onChanged: onChanged,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyFont extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  const MyFont(
      {super.key,
      required this.text,
      this.color,
      this.fontWeight,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: fontSize ?? 13,
          fontWeight: fontWeight ?? FontWeight.w500,
          color: color ?? Colors.purple),
    );
  }
}

class MyCheckBox extends StatefulWidget {
  final bool value;
  final String text;
  final Function(bool?) onchanged;
  const MyCheckBox(
      {super.key,
      required this.value,
      required this.text,
      required this.onchanged});

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      title: MyFont(text: widget.text),
      value: widget.value,
      onChanged: widget.onchanged,
    );
  }
}

class DataWidgetMobile extends StatelessWidget {
  final String text;
  final TextEditingController? controller;
  final double? textwidth;
  final List<String>? item;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final Widget? child;

  const DataWidgetMobile({
    super.key,
    required this.text,
    this.controller,
    this.textwidth,
    this.child,
    this.item,
    this.onChanged,
    this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyFont(text: text),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 45,
          child: child ??
              DropdownButtonFormField(
                value: selectedValue,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                items: item!.map((value) {
                  return DropdownMenuItem(value: value, child: Text(value));
                }).toList(),
                onChanged: onChanged,
              ),
        ),
      ],
    );
  }
}




  // TextFormField(
                //   style: const TextStyle(
                //     fontSize: 13,
                //     fontWeight: FontWeight.w500,
                //   ),
                //   controller: controller,
                //   decoration: const InputDecoration(
                //     contentPadding:
                //         EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide(
                //         color: Colors.black,
                //       ),
                //       borderRadius: BorderRadius.zero,
                //     ),
                //   ),
                // ),