import 'package:billingsphere/data/models/user/new_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../NU_responsive/NU_desktop_body.dart';
import '../../data/repository/user_repository.dart';
import '../UE_responsive/UE_desktop_body.dart';
import '../sumit_screen/voucher _entry.dart/voucher_list_widget.dart';

class UserMaster extends StatefulWidget {
  const UserMaster({super.key});

  @override
  State<UserMaster> createState() => _UserMasterState();
}

class _UserMasterState extends State<UserMaster> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = -1;
  UserRepository userRepo = UserRepository();
  List<NUserModel> userModel = [];
  String? selectedId;
  bool isLoading = false;
  int? activeIndex;
  String activeid = '';

  late SharedPreferences _prefs;
  String? userGroup;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void initialize() async {
    await _initPrefs().then((value) => {
          setState(() {
            userGroup = _prefs.getString('usergroup');
          })
        });
  }

  List<String>? companyCode;
  Future<List<String>?> getCompanyCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('companies');
  }

  Future<void> setCompanyCode() async {
    List<String>? code = await getCompanyCode();
    setState(() {
      companyCode = code;
    });
  }

  Future<void> getUserGroups() async {
    setState(() {
      isLoading = true;
    });
    final List<NUserModel> userModels = await userRepo.fetchUsers();

    final filteredUserModel = userModels
        .where((usermodel) => usermodel.companies!.contains(companyCode!.first))
        .toList();

    setState(() {
      userModel = userGroup == "Owner" ? userModels : filteredUserModel;
      print(userModel);
      if (userModel.isNotEmpty) {
        selectedId = userModel[0].id;
      }
    });
  }

  void _handleTap(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  void filterUserGroups(String query) {
    // Filter user groups based on query
    if (query.isNotEmpty) {
      List<NUserModel> filteredList = userModel.where((group) {
        return group.fullName!.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        userModel = filteredList;
      });
    } else {
      getUserGroups();
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
    setCompanyCode();
    getUserGroups();
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
            "USER MASTER",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        // actions: const [
        //   Icon(
        //     Icons.close,
        //     color: Colors.white,
        //   ),
        // ],
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
                          height: 30,
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
                                    height: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: _searchController,
                                        onChanged: (value) {
                                          setState(() {
                                            filterUserGroups(value);
                                          });
                                        },
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
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
                                            // borderSide:
                                            //     const BorderSide(
                                            //         color:
                                            //             Colors.grey),
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
                                    "User Name",
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
                                    "User Group",
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
                                    "E-mail",
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
                                    "BackDateEntry",
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
                        SingleChildScrollView(
                          child: SizedBox(
                            height: 500,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: userModel.length,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.135,
                                          child: Text(
                                            userModel[index].fullName!,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.135,
                                          child: Text(
                                            userModel[index].userGroup!,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.133,
                                          child: Text(
                                            userModel[index].email!,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          child: Text(
                                            userModel[index].backDateEntry!,
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
                                      activeid = userModel[index].sId!;

                                      print(activeid);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            'ROW COUNT: ${userModel.length}',
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
              SizedBox(
                height: 600,
                width: MediaQuery.of(context).size.width * 0.085,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CustomList(
                        Skey: "N",
                        name: "New",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NUDesktopBody(),
                            ),
                          );
                        },
                      ),
                      CustomList(
                        Skey: "E",
                        name: "Edit",
                        onTap: () {
                          activeid.isEmpty
                              ? null
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditUser(userid: activeid),
                                  ),
                                );
                        },
                      ),
                      CustomList(Skey: "", name: "", onTap: () {}),
                      CustomList(
                          Skey: "D",
                          name: "Delete",
                          onTap: () {
                            activeid.isEmpty
                                ? null
                                : showCupertinoDialog(
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
                                              userRepo
                                                  .deleteUser(activeid, context)
                                                  .then(
                                                    (value) => {
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const UserMaster(),
                                                        ),
                                                      )
                                                    },
                                                  );
                                            },
                                          ),
                                          CupertinoDialogAction(
                                            child: const Text('No',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                          }),
                      CustomList(Skey: "X", name: "Excel", onTap: () {}),
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
            ],
          ),
        ],
      ),
    );
  }

  void _selectRow(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = -1; // Reset selection
      } else {
        _selectedIndex = index;
      }
    });
  }
}
