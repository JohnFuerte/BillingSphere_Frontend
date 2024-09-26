// ignore_for_file: file_names

import 'package:billingsphere/data/models/user/new_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/user/user_group_model.dart';
import '../../data/repository/user_group_repository.dart';
import '../../data/repository/user_repository.dart';
import '../SE_common/SE_form_buttons.dart';
import 'UE_custom_textfield.dart';

class EditUser extends StatefulWidget {
  final String userid;
  const EditUser({super.key, required this.userid});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  bool selectAll = false;
  bool cardPayment = false;
  bool cash = false;
  bool cheque = false;
  bool credit = false;
  bool multimode = false;
  int selectedRow = -1;
  bool isLoading = false;
  List<NUserModel> userModel = [];
  List<UserGroup> userGroups = [];
  UserGroupServices userGroupServices = UserGroupServices();
  String selectedType = ''; // Initial selected value

  UserRepository userRepo = UserRepository();
  NUserModel? userData;
  String id = '';
  String updated = '';
  String companycode = '';
  //Controller's
  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  // TextEditingController userPasswordController2 = TextEditingController();

  List<String> dashboardVisibilityOptions = ['Yes', 'No'];
  String selectedDashboardVisibility = 'Yes';

  List<String> backdateEntryOptions = ['Yes', 'No'];
  String selectedBackdateEntry = 'Yes';

  List<String> dashbotadCategoryControllerOptions = ['Yes', 'No'];
  String selectedDashbotadCategory = 'Yes';

  // List<String> userGrouprOptions = ['Admin', 'User', 'Manager', 'Supervisor'];
  // String selectedUserGroup = 'User';

  Future<void> fetchUserById() async {
    final user = await userRepo.fetchUserById(widget.userid);

    setState(() {
      userData = user;
      id = userData!.sId!;
      userNameController.text = userData!.fullName!;
      selectedType = userData!.userGroup!;
      selectedDashboardVisibility = userData!.dashboardAccess!;
      selectedBackdateEntry = userData!.backDateEntry!;
      userEmailController.text = userData!.email!;
      selectedDashbotadCategory = userData!.dashboardCategory!;
      updated = userData!.updatedOn!;

      userPasswordController.text = userData!.hintpassword!;
    });
  }

  Future<void> getUserGroups() async {
    setState(() {
      isLoading = true;
    });
    final List<UserGroup> userGroup = await userGroupServices.getUserGroups();
    setState(() {
      userGroups = userGroup;
      userGroups.insert(0, UserGroup(userGroupName: ''));
      selectedType = userGroups[0].userGroupName!;
      isLoading = false;
    });

    print(userGroups.length);
  }

  Future<void> updateUser() async {
    try {
      // Determine the password to use

      NUserModel updatedUser = NUserModel(
        sId: id,
        fullName: userNameController.text,
        userGroup: selectedType,
        dashboardAccess: selectedDashboardVisibility,
        backDateEntry: selectedBackdateEntry,
        email: userEmailController.text,
        dashboardCategory: selectedDashbotadCategory,
        password: userPasswordController.text,
        hintpassword: userPasswordController.text,
        updatedOn: userData!.updatedOn,
        companies: userData!.companies,
        id: userData!.id,
      );

      await userRepo.updateUser(updatedUser, context);

      Fluttertoast.showToast(
        msg: 'User updated successfully',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (error) {
      print('Error updating user: $error');
      // Show a toast message indicating the error
      Fluttertoast.showToast(
        msg: 'Error updating user: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _initData() async {
    await getUserGroups();
    await fetchUserById();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    userNameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40.0,
        backgroundColor: Colors.amber.shade700,
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
            "EDIT User",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 550,
            width: w * 0.75,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: w * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: w * 0.33,
                              height: 40,
                              child: CustomTextFields(
                                text: "User Name",
                                controller: userNameController,
                                onSaved: (newValue) {
                                  userNameController = newValue!;
                                },
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                SizedBox(
                                  width: w * 0.165,
                                  height: 40,
                                  child: Text(
                                    'User Group',
                                    style: GoogleFonts.poppins(
                                      color: Colors.purple,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade700)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      menuMaxHeight: 300,
                                      isExpanded: true,
                                      value: selectedType,
                                      underline: Container(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedType = newValue!;
                                        });
                                      },
                                      items: userGroups
                                          .map<DropdownMenuItem<String>>(
                                              (UserGroup value) {
                                        return DropdownMenuItem<String>(
                                          value: value.userGroupName,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(value.userGroupName!),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            SizedBox(
                              width: w * 0.33,
                              height: 40,
                              child: CustomTextFields(text: "User Mobile No"),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                SizedBox(
                                  width: w * 0.165,
                                  height: 40,
                                  child: Text(
                                    'Dashboard Visible',
                                    style: GoogleFonts.poppins(
                                      color: Colors.purple,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade700)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      menuMaxHeight: 300,
                                      isExpanded: true,
                                      value: selectedDashboardVisibility,
                                      underline: Container(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedDashboardVisibility =
                                              newValue!;
                                        });
                                      },
                                      items: dashboardVisibilityOptions
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(value),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                SizedBox(
                                  width: w * 0.165,
                                  height: 40,
                                  child: Text(
                                    'Allow Backdate Entry',
                                    style: GoogleFonts.poppins(
                                      color: Colors.purple,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade700)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      menuMaxHeight: 300,
                                      isExpanded: true,
                                      value: selectedBackdateEntry,
                                      underline: Container(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedBackdateEntry = newValue!;
                                        });
                                      },
                                      items: backdateEntryOptions
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(value),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text("Allowed Payment Types",
                                style: GoogleFonts.poppins(
                                    color: Colors.purple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8.0),
                            Container(
                              width: w * 0.33,
                              height: 200,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1.5)),
                              child: SingleChildScrollView(
                                child: Table(
                                  children: [
                                    _buildTableRow(
                                        "** Select All **", selectAll, 0),
                                    _buildTableRow(
                                        "CARD PAYMENT", cardPayment, 1),
                                    _buildTableRow("Cash", cash, 2),
                                    _buildTableRow("CHEQUE", cheque, 3),
                                    _buildTableRow("Credit", credit, 4),
                                    _buildTableRow("Multimode", multimode, 5),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: w * 0.35,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(
                            //   width: w * 0.33,
                            //   height: 40,
                            //   child: CustomTextFields(
                            //     text: "User Login ID",
                            //     controller: userEmailController,
                            //     onSaved: (newValue) {
                            //       userEmailController = newValue!;
                            //     },
                            //   ),
                            // ),
                            // const SizedBox(height: 8.0),
                            // SizedBox(
                            //   width: w * 0.33,
                            //   height: 40,
                            //   child: CustomTextFields(
                            //     text: "Password",
                            //     controller: userPasswordController,
                            //     onSaved: (newValue) {
                            //       userPasswordController = newValue!;
                            //     },
                            //   ),
                            // ),
                            const SizedBox(height: 8.0),
                            SizedBox(
                              width: w * 0.33,
                              height: 40,
                              child: CustomTextFields(text: "User TIN"),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                SizedBox(
                                  width: w * 0.165,
                                  height: 40,
                                  child: Text(
                                    'Category',
                                    style: GoogleFonts.poppins(
                                      color: Colors.purple,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade700)),
                                  width:
                                      MediaQuery.of(context).size.width * 0.08,
                                  height: 40,
                                  padding: const EdgeInsets.all(2.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      menuMaxHeight: 300,
                                      isExpanded: true,
                                      value: selectedDashbotadCategory,
                                      underline: Container(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedDashbotadCategory = newValue!;
                                        });
                                      },
                                      items: dashbotadCategoryControllerOptions
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(value),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8.0),
                            SizedBox(
                              width: w * 0.33,
                              height: 40,
                              child: CustomTextFields(
                                text: "User Email",
                                controller: userEmailController,
                                onSaved: (newValue) {
                                  userEmailController = newValue!;
                                },
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            SizedBox(
                              width: w * 0.33,
                              height: 40,
                              child: CustomTextFields(
                                text: "User Password",
                                controller: userPasswordController,
                                onSaved: (newValue) {
                                  userPasswordController = newValue!;
                                },
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            SizedBox(
                              width: w * 0.248,
                              height: 40,
                              child: CustomTextFields(
                                  text: "View Other User's Entry",
                                  flex1: 2,
                                  flex2: 1),
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: w * 0.35,
                    child: Row(
                      children: [
                        Expanded(
                            child: SEFormButton(
                          width: MediaQuery.of(context).size.width * 0.14,
                          height: 40,
                          onPressed: updateUser,
                          buttonText: 'Update',
                        )),
                        const SizedBox(width: 20),
                        Expanded(
                            child: SEFormButton(
                          width: MediaQuery.of(context).size.width * 0.14,
                          height: 40,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          buttonText: 'Cancel',
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String text, bool value, int index) {
    return TableRow(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              if (selectedRow == index) {
                selectedRow = -1;
              } else {
                selectedRow = index;
              }
            });
          },
          child: Container(
            color: selectedRow == index ? Colors.blue : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color:
                          selectedRow == index ? Colors.yellow : Colors.black,
                    ),
                  ),
                ),
                Checkbox(
                  value: selectedRow == index ? true : value,
                  onChanged: (bool? newValue) {
                    setState(() {
                      switch (index) {
                        case 0:
                          selectAll = newValue!;
                          break;
                        case 1:
                          cardPayment = newValue!;
                          break;
                        case 2:
                          cash = newValue!;
                          break;
                        case 3:
                          cheque = newValue!;
                          break;
                        case 4:
                          credit = newValue!;
                          break;
                        case 5:
                          multimode = newValue!;
                          break;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
