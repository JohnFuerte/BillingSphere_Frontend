import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Company_General/company_general.dart';
import '../SE_common/SE_form_buttons.dart';
import '../UE_responsive/gesture_button.dart';

class CompanySetup extends StatefulWidget {
  const CompanySetup({super.key});

  @override
  State<CompanySetup> createState() => _CompanySetupState();
}

class _CompanySetupState extends State<CompanySetup> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              "Company Setup",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: SEFormButton(
                    buttonText: 'General',
                    height: 40,
                    width: 40,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CompanyGeneral(),
                        ),
                      );
                    },
                  )),
                  const SizedBox(width: 25),
                  const Expanded(child: GestureButton(text: "Backup Schedules"))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: GestureButton(text: "Accounts")),
                  SizedBox(width: 20),
                  Expanded(child: GestureButton(text: "Email Setting"))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: GestureButton(text: "Inventory")),
                  SizedBox(width: 20),
                  Expanded(child: GestureButton(text: "SMS Setting"))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: GestureButton(text: "Default Ledger")),
                  SizedBox(width: 20),
                  Expanded(child: GestureButton(text: "WhatsApp Setting"))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: GestureButton(text: "Sales Statement")),
                  SizedBox(width: 20),
                  Expanded(child: GestureButton(text: "GST Setup"))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: GestureButton(text: "Favourite Menu")),
                  SizedBox(width: 20),
                  Expanded(child: GestureButton(text: "Reward System"))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: GestureButton(text: "Petrol Pump")),
                  SizedBox(width: 20),
                  Expanded(child: GestureButton(text: "Image Sync Setup"))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: GestureButton(text: "E-Invoice Setup")),
                  SizedBox(width: 20),
                  Expanded(child: GestureButton(text: "TCS Setup"))
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                children: [
                  Expanded(child: GestureButton(text: "Reporting Tool Setup")),
                  SizedBox(width: 20),
                  Expanded(child: GestureButton(text: "Update Settings [F4]"))
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                  ),
                  Text(
                    "Sync Data For Mobile App",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "Audit Trail",
                      style: GoogleFonts.poppins(
                        decoration: TextDecoration.underline,
                        color: Colors.indigo,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
