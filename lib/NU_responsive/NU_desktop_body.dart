import 'package:billingsphere/data/models/user/user_group_model.dart';
import 'package:billingsphere/views/DB_widgets/Desktop_widgets/d_custom_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repository/user_repository.dart';
import '../data/models/newCompany/new_company_model.dart';
import '../data/models/newCompany/store_model.dart';
import '../data/repository/new_company_repository.dart';
import '../data/repository/user_group_repository.dart';

class NUDesktopBody extends StatefulWidget {
  const NUDesktopBody({super.key});

  @override
  State<NUDesktopBody> createState() => _NUDesktopBodyState();
}

class _NUDesktopBodyState extends State<NUDesktopBody> {
  String selectedType = ''; // Initial selected value
  String selectedDashboard = ''; // Initial selected value
  String selectedDashboardCat = ''; // Initial selected value
  String selectedBackDate = ''; // Initial selected value
  List<UserGroup> userGroups = [];
  bool isLoading = false;
  bool isPasswordVisible = false;
  String selectedCompany = '';
  List<StoreModel> stores = [];
  String? selectedStore;

  UserRepository userRepository = UserRepository();
  UserGroupServices userGroupServices = UserGroupServices();

  final List<NewCompany> _companyList = [];
  final NewCompanyRepository _newCompanyRepository = NewCompanyRepository();

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

  Future<void> getCompany() async {
    setState(() {
      isLoading = true;
    });
    final allCompany = await _newCompanyRepository.getAllCompanies();

    allCompany.insert(
      0,
      NewCompany(
        id: '',
        companyName: '',
        companyCode: '',
        companyType: '',
        country: '',
        taxation: '',
        acYear: '',
        acYearTo: '',
        email: '',
        password: '',
      ),
    );

    setState(() {
      _companyList.addAll(allCompany);
      selectedCompany = _companyList[0].companyCode!;
      isLoading = false;
    });
  }

  List<String> userType = [
    '',
    'Admin',
    'Audit',
    'Clerk',
    'Manager',
  ];

  List<String> dashboard = [
    '',
    'Yes',
    'No',
  ];

  List<String> backDate = [
    '',
    'Yes',
    'No',
  ];

  List<String> dashboardCat = [
    '',
    'Yes',
    'No',
  ];

  // lIST OF CONTROLLERS
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void createuser() {
    if (userNameController.text.isNotEmpty &&
        loginEmailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        selectedType.isNotEmpty &&
        selectedDashboard.isNotEmpty &&
        selectedDashboardCat.isNotEmpty &&
        selectedBackDate.isNotEmpty &&
        loginEmailController.text.contains('@')) {
      userRepository
          .createAccountByAdmin(
        email: loginEmailController.text,
        password: passwordController.text,

        // hintpassword: passwordController.text,
        name: userNameController.text,
        userGroup: selectedType,
        companies: [companyCode!.first],
        dashboardAccess: selectedDashboard,
        dashboardCategory: selectedDashboardCat,
        backDateEntry: selectedBackDate,
        context: context,
      )
          .then((value) {
        userNameController.clear();
        loginEmailController.clear();
        passwordController.clear();
        selectedBackDate = '';
        selectedDashboard = '';
        selectedDashboardCat = '';
        selectedType = '';
      }).catchError(
        (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
    }
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

  Future<void> _initData() async {
    await getCompany();
    await getUserGroups();
    await setCompanyCode();
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    loginEmailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
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
                  'CREATE NEW USER',
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
          const SizedBox(height: 20),

          // Make container and center it with the help of Center widget
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(0),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white10,
                    blurRadius: 2,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'User Name',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.052),
                        // Textfield
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: TextField(
                            controller: userNameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Login Email',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: TextField(
                            controller: loginEmailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Password',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.06),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            obscureText: isPasswordVisible ? true : false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'User Group',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.052),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedType,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedType = newValue!;
                                });
                              },
                              items: userGroups.map<DropdownMenuItem<String>>(
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
                  ),
                  const SizedBox(height: 10),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Select Company',
                  //         style: GoogleFonts.poppins(
                  //           textStyle: const TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 15,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //           width: MediaQuery.of(context).size.width * 0.025),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Colors.grey,
                  //             width: 1,
                  //           ),
                  //           borderRadius: BorderRadius.circular(5),
                  //         ),
                  //         width: MediaQuery.of(context).size.width * 0.2,
                  //         height: MediaQuery.of(context).size.height * 0.05,
                  //         child: DropdownButtonHideUnderline(
                  //           child: DropdownButton<String>(
                  //             value: selectedCompany,
                  //             onChanged: (String? newValue) {
                  //               setState(() {
                  //                 selectedCompany = newValue!;
                  //               });

                  //               final selectedCompanyStores = _companyList
                  //                   .where((element) =>
                  //                       element.companyCode == selectedCompany)
                  //                   .toList();
                  //               final stores = selectedCompanyStores[0].stores;
                  //               setState(() {
                  //                 this.stores = stores!;
                  //                 selectedStore = stores[0].code;
                  //               });
                  //             },
                  //             items: _companyList.map<DropdownMenuItem<String>>(
                  //                 (NewCompany value) {
                  //               return DropdownMenuItem<String>(
                  //                 value: value.companyCode,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 8),
                  //                   child: Text(value.companyName!),
                  //                 ),
                  //               );
                  //             }).toList(),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 32),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         'Select Location',
                  //         style: GoogleFonts.poppins(
                  //           textStyle: const TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 15,
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(
                  //           width: MediaQuery.of(context).size.width * 0.025),
                  //       Container(
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Colors.grey,
                  //             width: 1,
                  //           ),
                  //           borderRadius: BorderRadius.circular(5),
                  //         ),
                  //         width: MediaQuery.of(context).size.width * 0.2,
                  //         height: MediaQuery.of(context).size.height * 0.05,
                  //         child: DropdownButtonHideUnderline(
                  //           child: DropdownButton<String>(
                  //             value: selectedStore,
                  //             onChanged: (String? newValue) {
                  //               setState(() {
                  //                 selectedStore = newValue!;
                  //               });
                  //             },
                  //             items: stores.map<DropdownMenuItem<String>>(
                  //                 (StoreModel value) {
                  //               return DropdownMenuItem<String>(
                  //                 value: value.code,
                  //                 child: Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 8),
                  //                   child: Text(value.city),
                  //                 ),
                  //               );
                  //             }).toList(),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Dashboard',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.052),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedDashboard,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDashboard = newValue!;
                                });
                              },
                              items: dashboard.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(value),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Dashboard Cat.',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedDashboardCat,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedDashboardCat = newValue!;
                                });
                              },
                              items: dashboardCat.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(value),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'Allow Back Date',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: MediaQuery.of(context).size.width * 0.2,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedBackDate,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedBackDate = newValue!;
                                });
                              },
                              items: backDate.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(value),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.12,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: DButtons(
                          text: 'SAVE [F4]',
                          onPressed: createuser,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: DButtons(
                          text: 'CANCEL',
                          onPressed: () {},
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.18),
          // Expanded(
          //   child: Container(
          //     width: double.infinity,
          //     height: 200,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       border: Border.all(
          //         color: Colors.grey,
          //         width: 1,
          //       ),
          //       borderRadius: BorderRadius.circular(0),
          //       boxShadow: const [
          //         BoxShadow(
          //           color: Colors.white10,
          //           blurRadius: 2,
          //           offset: Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Row(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          //         Text(
          //           'User List',
          //           style: GoogleFonts.poppins(
          //             textStyle: const TextStyle(
          //               color: Colors.black,
          //               fontSize: 15,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
