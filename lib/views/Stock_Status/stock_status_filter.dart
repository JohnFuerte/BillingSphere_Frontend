import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/newCompany/new_company_model.dart';
import '../../data/models/newCompany/store_model.dart';
import '../../data/repository/new_company_repository.dart';
import '../DB_widgets/custom_footer.dart';
import '../RA_widgets/RA_M_Button.dart';
import 'stock_status.dart';
import 'stock_status_owner.dart';

class StockFilter extends StatefulWidget {
  const StockFilter({super.key});

  @override
  State<StockFilter> createState() => _StockFilterState();
}

class _StockFilterState extends State<StockFilter> {
  String selectedCompany = '';
  String selectedStore = '';
  String? userGroup;

  final List<NewCompany> _companyList = [];
  List<StoreModel> stores = [];
  List<String> _companies = [];

  late SharedPreferences _prefs;

  bool _isLoading = false;
  final NewCompanyRepository _newCompanyRepository = NewCompanyRepository();

  Future<void> getCompany() async {
    setState(() {
      _isLoading = true;
    });
    final allCompany = await _newCompanyRepository.getAllCompanies();

    allCompany.insert(
      0,
      NewCompany(
        id: '',
        acYear: '',
        companyType: '',
        companyCode: '',
        companyName: '',
        country: '',
        taxation: '',
        acYearTo: '',
        password: '',
        email: '',
      ),
    );

    setState(() {
      if (allCompany.isNotEmpty) {
        _companyList.addAll(allCompany);
      } else {
        _companyList.clear();
      }
      _isLoading = false;
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> initialize() async {
    await _initPrefs().then((value) => {
          setState(() {
            _companies = _prefs.getStringList('companies') ?? [];
            userGroup = _prefs.getString('usergroup');
          })
        });

    await getCompany();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Status Filter',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 65, 243),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * 0.01,
                      left: MediaQuery.of(context).size.width * 0.01,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 615,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  height: 330,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Report Criteria',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              child: const Text(
                                                '  Select Store',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all()),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              height: 30,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  value: selectedCompany,
                                                  underline: Container(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedCompany =
                                                          newValue!;
                                                    });
                                                    final selectedCompanyStores =
                                                        _companyList
                                                            .where((element) =>
                                                                element
                                                                    .companyCode ==
                                                                selectedCompany)
                                                            .toList();

                                                    print(
                                                        selectedCompanyStores);
                                                    final stores =
                                                        selectedCompanyStores[0]
                                                            .stores;
                                                    setState(() {
                                                      this.stores = stores!;
                                                      selectedStore =
                                                          stores[0].code!;
                                                    });
                                                  },
                                                  items: _companyList.map(
                                                      (NewCompany company) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value:
                                                          company.companyCode!,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(2.0),
                                                            child: Text(company
                                                                .companyName!
                                                                .toUpperCase()),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09,
                                              child: const Text(
                                                '  Select Location',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all()),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.40,
                                              height: 30,
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<String>(
                                                  menuMaxHeight: 300,
                                                  isExpanded: true,
                                                  value: selectedStore,
                                                  underline: Container(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      // selectedPlaceState =
                                                      //     newValue!;
                                                      // inwardChallanController
                                                      //         .placeController
                                                      //         .text =
                                                      //     selectedPlaceState;

                                                      selectedStore = newValue!;
                                                    });
                                                  },
                                                  items: stores
                                                      .map((StoreModel value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value.code,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(2.0),
                                                        child: Text(value.city),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.01,
                                              ),
                                              child: Row(
                                                children: [
                                                  RAMButtons(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.11,
                                                    height: 30,
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StockStatusOwner(
                                                            selectedCompany:
                                                                selectedCompany,
                                                            store:
                                                                selectedStore,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    text: 'Show [F4]',
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: RAMButtons(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.11,
                                                      onPressed: () {},
                                                      height: 30,
                                                      text: 'Close',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }
}
