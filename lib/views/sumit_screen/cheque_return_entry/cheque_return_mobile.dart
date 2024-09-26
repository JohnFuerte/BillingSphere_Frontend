import 'package:flutter/material.dart';

import '../voucher _entry.dart/voucher_button_widget.dart';

class Mobile_ChequeReturnEntry extends StatefulWidget {
  const Mobile_ChequeReturnEntry({Key? key}) : super(key: key);

  @override
  State<Mobile_ChequeReturnEntry> createState() =>
      _Mobile_ChequeReturnEntryState();
}

class _Mobile_ChequeReturnEntryState extends State<Mobile_ChequeReturnEntry> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          openDialog();
        },
        child: const Text("Cheque Return Entry [POP UP]"),
      ),
    );
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => Phone_ChequeReturnEntry(),
      );
}

class Phone_ChequeReturnEntry extends StatefulWidget {
  const Phone_ChequeReturnEntry({Key? key}) : super(key: key);

  @override
  State<Phone_ChequeReturnEntry> createState() =>
      _Phone_ChequeReturnEntryState();
}

class _Phone_ChequeReturnEntryState extends State<Phone_ChequeReturnEntry> {
  int? selectedRadio;

  @override
  void initState() {
    super.initState();
    selectedRadio = 1; // Set the default selected radio button value
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        width: MediaQuery.of(context).size.width * 0.7,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.blueAccent[400],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(flex: 1),
                    Text(
                      "Cheque Return Entry",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      icon: Icon(Icons.cancel_presentation),
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Cheque No",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  0.0), // Adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 100,
                        child: Buttons(
                          text: "Get Details",
                          color: Colors.black,
                          onPressed: () {},
                        )),
                    Container(
                        width: 100,
                        child: Buttons(
                          text: "Close",
                          color: Colors.black,
                          onPressed: () {},
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Party Name",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  0.0), // Adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Receipt Details",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  0.0), // Adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Bank Name",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  0.0), // Adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Bank Charges",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  0.0), // Adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Charge to be taken from Customer",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Spacer(flex: 2),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  0.0), // Adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Expense Head",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  0.0), // Adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Posting Date",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 30,
                        child: TextField(
                          cursorHeight: 15,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  0.0), // Adjust the border radius as needed
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Original Receipt",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 0.5,
                            child: Radio(
                              value: 1,
                              groupValue: selectedRadio,
                              onChanged: (value) {
                                setState(() {
                                  selectedRadio = value as int?;
                                });
                              },
                            ),
                          ),
                          Text("Post Reversal Voucher"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 0.5,
                            child: Radio(
                              value: 2,
                              groupValue: selectedRadio,
                              onChanged: (value) {
                                setState(() {
                                  selectedRadio = value as int?;
                                });
                              },
                            ),
                          ),
                          Text("Delete Original Receipt"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 150,
                        child: Buttons(
                            text: "Post Voucher",
                            color: Colors.black,
                            onPressed: () {})),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
