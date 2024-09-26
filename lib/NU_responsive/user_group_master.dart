import 'package:billingsphere/data/models/user/user_group_model.dart';
import 'package:billingsphere/data/repository/user_group_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NU_edit_group.dart';

class UserGroupMaster extends StatefulWidget {
  const UserGroupMaster({super.key});

  @override
  State<UserGroupMaster> createState() => _UserGroupMasterState();
}

class _UserGroupMasterState extends State<UserGroupMaster> {
  UserGroupServices userGroupServices = UserGroupServices();
  List<String>? companyCode;
  List<UserGroup> userGroup = [];
  int? activeIndex;
  String activeid = '';
  TextEditingController userGroupNameController = TextEditingController();

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

  // Create a new user group
  void createUserGroup({
    required String companyCode,
    required String userGroupName,
    required String ownerGroup,
    required String misReport,
    required String report,
    required String addMaster,
    required String editMaster,
    required String deleteMaster,
    required String purchase,
    required String sales,
    required String purchaseReturn,
    required String salesReturn,
    required String stock,
    required String shortage,
    required String jobcard,
    required String receiptNote,
    required String deliveryNote,
    required String purchaseOrder,
    required String salesOrder,
    required String salesQuotation,
    required String purchaseEnquiry,
    required String journal,
    required String conta,
    required String receipt2,
    required String payment,
    required BuildContext context,
  }) async {
    await userGroupServices
        .createUserGroup(
          companyCode: companyCode,
          userGroupName: userGroupName,
          ownerGroup: ownerGroup,
          misReport: misReport,
          report: report,
          addMaster: addMaster,
          editMaster: editMaster,
          deleteMaster: deleteMaster,
          purchase: purchase,
          sales: sales,
          purchaseReturn: purchaseReturn,
          salesReturn: salesReturn,
          stock: stock,
          shortage: shortage,
          jobcard: jobcard,
          receiptNote: receiptNote,
          deliveryNote: deliveryNote,
          purchaseOrder: purchaseOrder,
          salesOrder: salesOrder,
          salesQuotation: salesQuotation,
          purchaseEnquiry: purchaseEnquiry,
          journal: journal,
          conta: conta,
          receipt2: receipt2,
          payment: payment,
          context: context,
        )
        .then((value) => {setState(() {})});
  }

  // Fech user group
  Future<void> fetchUserGroup() async {
    final List<UserGroup> userGroup = await userGroupServices.getUserGroups();

    setState(() {
      this.userGroup = userGroup;
    });
  }

  @override
  void dispose() {
    super.dispose();
    userGroupNameController.dispose();
  }

  void _inilliazation() async {
    await setCompanyCode();
    await fetchUserGroup();
  }

  @override
  void initState() {
    super.initState();
    _inilliazation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 4, 12, 241),
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
                SizedBox(width: MediaQuery.of(context).size.width * 0.45),
                Text(
                  'USER GROUP MASTER',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {
                    _showDialog(context);
                  },
                  child: Text(
                    'ADD',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: activeid.isEmpty
                      ? null
                      : () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) => NUEditUserGroup(
                                    id: activeid,
                                  ),
                                ),
                              )
                              .then((value) => {
                                    setState(() {
                                      activeIndex = null;
                                      activeid = '';
                                    })
                                  });
                        },
                  child: Text(
                    'EDIT',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: activeid.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Delete User Group'),
                                content: const Text(
                                    'Are you sure you want to delete this user group?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      userGroupServices.deleteUserGroup(
                                          activeid, context);
                                      Navigator.of(context).pop();
                                      fetchUserGroup();
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  child: Text(
                    'DELETE',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    //   return const NUAddUserGroup();
                    // }));
                  },
                  child: Text(
                    'PRINT',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 600,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white10,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            'Search',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.deepPurple),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.23,
                        height: 30,
                        child: TextField(
                          cursorHeight: 18,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          onChanged: (value) {
                            filterUserGroups(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 500,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1.0,
                                color: Colors.black,
                              ), // Adjust width and color as needed
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              'User Group Name',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                          ),
                        ),
                        userGroup.isEmpty
                            ? Center(
                                child: Text(
                                  '',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 450,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: userGroup.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      elevation: 1,
                                      child: ListTile(
                                        hoverColor: const Color.fromARGB(
                                            255, 4, 12, 241),
                                        tileColor: activeIndex == index
                                            ? const Color.fromARGB(
                                                255, 4, 12, 241)
                                            : Colors.white,
                                        title: Text(
                                          userGroup[index].userGroupName!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            color: activeIndex == index
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          _handleTap(index);
                                          activeid = userGroup[index].id!;

                                          print(activeid);
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                  Text(
                    'ROW COUNT: ${userGroup.length}',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTap(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  void filterUserGroups(String query) {
    // Filter user groups based on query
    if (query.isNotEmpty) {
      List<UserGroup> filteredList = userGroup.where((group) {
        return group.userGroupName!.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        userGroup = filteredList;
      });
    } else {
      fetchUserGroup();
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: AlertDialog(
              title: Text(
                "Add User Group",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: userGroupNameController,
                      decoration: const InputDecoration(
                        labelText: 'Group Name',
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      createUserGroup(
                        companyCode: companyCode!.first,
                        userGroupName: userGroupNameController.text,
                        ownerGroup: 'No',
                        misReport: 'No',
                        report: 'No',
                        addMaster: 'No',
                        editMaster: 'No',
                        deleteMaster: 'No',
                        purchase: 'No',
                        sales: 'No',
                        purchaseReturn: 'No',
                        salesReturn: 'No',
                        stock: 'No',
                        shortage: 'No',
                        jobcard: 'No',
                        receiptNote: 'No',
                        deliveryNote: 'No',
                        purchaseOrder: 'No',
                        salesOrder: 'No',
                        salesQuotation: 'No',
                        purchaseEnquiry: 'No',
                        journal: 'No',
                        conta: 'No',
                        receipt2: 'No',
                        payment: 'No',
                        context: context,
                      );
                      userGroupNameController.clear();
                      Navigator.of(context).pop(); // Close the dialog
                      fetchUserGroup();
                    }),
                TextButton(
                  child: const Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
