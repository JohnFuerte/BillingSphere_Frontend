import 'package:billingsphere/helper/constants.dart';
import 'package:billingsphere/utils/constant.dart';
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
    Screen s = Screen(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Stock Status Filter',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(32, 91, 212, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: s.width,
        height: s.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background13.jpg'),
              opacity: .9,
              fit: BoxFit.cover),

          // border: Border.all(color: Colors.black),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: s.width < 720 ? s.width * 0.9 : 500,
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black12),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 8,
                      spreadRadius: 2,
                      color: Colors.grey.shade400)
                ]),
            child: reportBox(),
          ),
        ),
      ),
      bottomNavigationBar: const CustomFooter(),
    );
  }

  Widget reportBox() {
    Screen s = Screen(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SizedBox(height: s.width < 720 ? 20 : 50),
        const Text(
          'Report Criteria',
          style: TextStyle(
            fontSize: 24,
            color: black,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: 100,
          height: 3,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 36, 104, 240),
              borderRadius: BorderRadius.circular(50)),
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Store : ',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(6)),
              margin: const EdgeInsets.only(top: 6),
              width: double.infinity,
              height: 40,
              child: storeDropDown(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Location : ',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(), borderRadius: BorderRadius.circular(6)),
              width: double.infinity,
              height: 40,
              margin: const EdgeInsets.only(top: 6),
              child: locationDropDown(),
            ),
          ],
        ),
        const SizedBox(height: 20),
        s.width < 720
            ? Row(
                children: [
                  Expanded(child: showButton()),
                  const SizedBox(width: 10),
                  Expanded(child: closeButton())
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showButton(),
                  const SizedBox(width: 10),
                  closeButton()
                ],
              ),
      ],
    );
  }

  Widget storeDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(6),
        focusColor: Colors.transparent,
        value: selectedCompany,
        underline: Container(),
        onChanged: (String? newValue) {
          setState(() {
            selectedCompany = newValue!;
          });
          final selectedCompanyStores = _companyList
              .where((element) => element.companyCode == selectedCompany)
              .toList();

          print(selectedCompanyStores);
          final stores = selectedCompanyStores[0].stores;
          setState(() {
            this.stores = stores!;
            selectedStore = stores[0].code!;
          });
        },
        items: _companyList.map((NewCompany company) {
          return DropdownMenuItem<String>(
            value: company.companyCode!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(company.companyName!.toUpperCase()),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget locationDropDown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        menuMaxHeight: 300,
        isExpanded: true,
        value: selectedStore,
        underline: Container(),
        onChanged: (String? newValue) {
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
        items: stores.map((StoreModel value) {
          return DropdownMenuItem<String>(
            value: value.code,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(value.city),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buttons() {
    Screen s = Screen(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StockStatusOwner(
                  selectedCompany: selectedCompany,
                  store: selectedStore,
                ),
              ),
            );
          },
          child: Container(
              width: s.width < 720 ? 120 : 150,
              height: 35,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(32, 91, 212, 1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'Show [F4]',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              width: s.width < 720 ? 120 : 150,
              height: 35,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 220, 29, 29),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Center(
                child: Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              )),
        ),
      ],
    );
  }

  Widget showButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StockStatusOwner(
              selectedCompany: selectedCompany,
              store: selectedStore,
            ),
          ),
        );
      },
      child: Container(
          width: 150,
          height: 35,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(32, 91, 212, 1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text(
              'Show [F4]',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }

  Widget closeButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
          width: 150,
          height: 35,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 220, 29, 29),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          )),
    );
  }
}
