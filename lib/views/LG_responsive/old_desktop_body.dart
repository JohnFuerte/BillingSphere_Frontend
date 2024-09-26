import 'package:flutter/material.dart';

class MyDesktopBody extends StatelessWidget {
  const MyDesktopBody({super.key});
  @override
  Widget build(BuildContext context) {
    var _mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 215, 215),
      appBar: AppBar(
        title: const Text(
          'Accounts Pro',
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  width: _mediaQuery.size.width * 0.48,
                  height: _mediaQuery.size.height * 0.5,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 228, 227, 227),
                    border: Border.all(
                      width: 1,

                      //                   <--- border width here
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    child: const Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Ledger Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 500,
                                  height: 22,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 11.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Ledger Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 500,
                                  height: 22,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 11.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Ledger Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 500,
                                  height: 22,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 11.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Ledger Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 500,
                                  height: 22,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 11.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Ledger Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 500,
                                  height: 22,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 11.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Ledger Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 500,
                                  height: 22,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 11.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Ledger Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 500,
                                  height: 22,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 11.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Ledger Name',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12.0),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: SizedBox(
                                  width: 500,
                                  height: 22,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.center,
                                    style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.all(Radius.zero)),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  width: _mediaQuery.size.width * 0.48,
                  height: _mediaQuery.size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 228, 227, 227),
                    border: Border.all(
                      width: 1, //                   <--- border width here
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Container(
                  width: _mediaQuery.size.width * 0.96,
                  height: _mediaQuery.size.height * 0.1,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 228, 227, 227),
                    border: Border.all(
                      width: 1, //                   <--- border width here
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
