import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/newCompany/new_company_model.dart';
import '../../data/repository/new_company_repository.dart';
import 'CM_new_desktop_body_edit.dart';

class CompanyListDesktopBody extends StatefulWidget {
  const CompanyListDesktopBody({super.key});

  @override
  State<CompanyListDesktopBody> createState() => _CompanyListDesktopBodyState();
}

class _CompanyListDesktopBodyState extends State<CompanyListDesktopBody> {
  List<NewCompany> companyList = [];
  NewCompanyRepository newCompanyRepository = NewCompanyRepository();

  Future<void> fetchCompanies() async {
    final companyList = await newCompanyRepository.getAllCompanies();
    setState(() {
      this.companyList = companyList;
    });
  }

  @override
  initState() {
    super.initState();
    fetchCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
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
                  'COMPANY LIST MASTER',
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
          Center(
              child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.6,
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
            child: ListView.builder(
              itemCount: companyList.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    title: Text(
                      companyList[index].companyName!,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    subtitle: Text(
                        "${companyList[index].companyType!} | ${companyList[index].acYear!} | ${companyList[index].acYearTo!}",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        )),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CMNEditDesktopBody(
                              companyId: companyList[index].id,
                              companyName: companyList[index].companyName!,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        CupertinoIcons.eye,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          )),
        ],
      ),
    );
  }
}
