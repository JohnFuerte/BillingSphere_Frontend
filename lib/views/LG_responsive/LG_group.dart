import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/ledgerGroup/ledger_group_model.dart';
import '../../data/repository/ledger_group_respository.dart';
import '../sumit_screen/sumit_responsive.dart';
import '../sumit_screen/voucher _entry.dart/voucher_button_widget.dart';
import 'LG_desktop_body.dart';

class LedgerGroupScreen extends StatefulWidget {
  const LedgerGroupScreen({super.key});

  @override
  State<LedgerGroupScreen> createState() => _LedgerGroupState();
}

class _LedgerGroupState extends State<LedgerGroupScreen> {
  final TextEditingController _controller = TextEditingController();
  String? companyCode;
  Future<String?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('companyCode');
  }

  Future<void> setCompanyCode() async {
    String? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  void createGroup() {
    final String groupName = _controller.text;
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter group name'),
        ),
      );
      return;
    } else {
      final LedgerGroup ledgerGroup = LedgerGroup(
        id: '',
        name: groupName,
      );
      LedgerGroupService().addLedgerGroup(ledgerGroup);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group added successfully'),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LGMyDesktopBody(),
        ),
      );
    }
  }

  @override
  @override
  void initState() {
    super.initState();
    setCompanyCode();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: Container(),
        tablet: Container(),
        desktop: Column(
          children: [
            Container(
              height: 30,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.deepPurple[400],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                  const Center(
                    child: Text(
                      "New Ledger Group",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Container(
                    height: 270,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  "Group Name",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.white,
                                  height: 30,
                                  child: TextFormField(
                                    controller: _controller,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      height: 1,
                                    ),
                                    cursorHeight: 15,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            0.0), // Adjust the border radius as needed
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 55),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.10,
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        onPressed: createGroup,
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                172, 236, 226, 137),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 88, 81, 11),
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Save [F4]',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.10,
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    child: SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                172, 236, 226, 137),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                              side: const BorderSide(
                                                color: Color.fromARGB(
                                                    255, 88, 81, 11),
                                              ),
                                            ),
                                          ),
                                        ),
                                        child: const Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 228, 227, 227),
                      border: Border.all(
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.27,
                          height: 75,
                          child: Image.asset(
                            'images/logo.png',
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  height: 15,
                                  child: const Text(
                                    'www.fuertedevelopers.in',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.12,
                                  height: 15,
                                  child: const Text(
                                    'Ph: +91 799 0486 477',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.0,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              border: Border.all(
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Copyright ©${DateTime.now().year}, All Rights Reserved. | Powered by Fuerte Developers',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.0,
                                      color:
                                          Color.fromARGB(255, 253, 253, 253)),
                                ),
                              ],
                            ),
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
}
