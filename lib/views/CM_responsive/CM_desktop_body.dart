import 'package:billingsphere/data/models/newCompany/new_company_model.dart';
import 'package:billingsphere/data/repository/new_company_repository.dart';
import 'package:billingsphere/views/DB_homepage.dart';
import 'package:billingsphere/views/DB_widgets/Desktop_widgets/d_custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../screens/foundation/Login_screen_resposive.dart/loginScreen.dart';

class CMDesktopBody extends StatefulWidget {
  const CMDesktopBody({super.key});

  @override
  State<CMDesktopBody> createState() => _CMDesktopBodyState();
}

class _CMDesktopBodyState extends State<CMDesktopBody> {
  final List<NewCompany> _companyList = [];
  bool _isLoading = false;
  final NewCompanyRepository _newCompanyRepository = NewCompanyRepository();

  Future<void> getCompany() async {
    setState(() {
      _isLoading = true;
    });
    final allCompany = await _newCompanyRepository.getAllCompanies();

    setState(() {
      _companyList.addAll(allCompany);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _companyList.clear();
  }

  Future<void> saveCompany(NewCompany company) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('companyCode', company.companyCode!);
    await prefs.setString('companyName', company.companyName!);
  }

  // Check if the user is already logged in using if user_id is saved in shared preferences
  Future<void> checkLogin() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? user = prefs.getString('user_id');

    if (user != null) {
      Navigator.pushNamed(context, DBHomePage.routeName);
    } else {
      await getCompany();
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white54,
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 30,
                        width: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'BillingSphere Business Software - Desktop Version 1.0.0',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 700,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 40, 37, 199),
                                // #074691
                              ),
                              child: Text(
                                'SELECT COMPANY',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            _companyList.isEmpty
                                ? Center(
                                    child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'No Company Found!, Please Create a New Company.',
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _companyList.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        elevation: 1,
                                        child: ListTile(
                                          dense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 0,
                                          ),
                                          tileColor: Colors.white,
                                          leading: Text(
                                            _companyList[index].companyCode!,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          title: Text(
                                            _companyList[index]
                                                .companyName!
                                                .toUpperCase(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          trailing: Text(
                                            '${_companyList[index].acYear} - ${_companyList[index].acYearTo}',
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          onTap: () async {
                                            await saveCompany(
                                                _companyList[index]);

                                            Navigator.pushNamed(context,
                                                LoginScreen.routeName);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                      Container(
                        width: 700,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 4,
                                height: 30,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      const Color.fromARGB(255, 247, 241, 187),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(1.0),
                                        side: const BorderSide(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Download Sample Data',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 110,
                                      child: DButtons(
                                        text: 'OPEN',
                                        alignment: Alignment.center,
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: DButtons(
                                        text: 'COPY',
                                        alignment: Alignment.center,
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: 120,
                                      child: DButtons(
                                        text: 'RESTORE',
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: 130,
                                      child: DButtons(
                                        text: 'REMOTE',
                                        onPressed: () {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: 110,
                                      child: DButtons(
                                        text: 'EXIT',
                                        alignment: Alignment.center,
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
