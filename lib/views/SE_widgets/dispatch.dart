import 'package:flutter/material.dart';

class DispatchDetailsDialog extends StatefulWidget {
  const DispatchDetailsDialog({super.key, required this.dispacthDetails});

  final Map<String, dynamic> dispacthDetails;

  @override
  State<DispatchDetailsDialog> createState() => _DispatchDetailsDialogState();
}

class _DispatchDetailsDialogState extends State<DispatchDetailsDialog> {
  String? selectedValue;

  final TextEditingController _transAgencyController = TextEditingController();
  final TextEditingController _docketNoController = TextEditingController();
  final TextEditingController _vehicleNoController = TextEditingController();
  final TextEditingController _fromStationController = TextEditingController();
  final TextEditingController _fromDistrictController = TextEditingController();
  final TextEditingController _transModeController = TextEditingController();
  final TextEditingController _parcelController = TextEditingController();
  final TextEditingController _freightController = TextEditingController();
  final TextEditingController _kmsController = TextEditingController();
  final TextEditingController _toStateController = TextEditingController();
  final TextEditingController _ewayBillController = TextEditingController();
  final TextEditingController _billingAddressController =
      TextEditingController();
  final TextEditingController _shippedToController = TextEditingController();
  final TextEditingController _shippingAddressController =
      TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _gstNoController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _licenceNoController = TextEditingController();
  final TextEditingController _issueStateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void saveDispatchValues() {
    widget.dispacthDetails['transAgency'] = _transAgencyController.text;
    widget.dispacthDetails['docketNo'] = _docketNoController.text;
    widget.dispacthDetails['vehicleNo'] = _vehicleNoController.text;
    widget.dispacthDetails['fromStation'] = _fromStationController.text;
    widget.dispacthDetails['fromDistrict'] = _fromDistrictController.text;
    widget.dispacthDetails['transMode'] = _transModeController.text;
    widget.dispacthDetails['parcel'] = _parcelController.text;
    widget.dispacthDetails['freight'] = _freightController.text;
    widget.dispacthDetails['kms'] = _kmsController.text;
    widget.dispacthDetails['toState'] = _toStateController.text;
    widget.dispacthDetails['ewayBill'] = _ewayBillController.text;
    widget.dispacthDetails['billingAddress'] = _billingAddressController.text;
    widget.dispacthDetails['shippedTo'] = _shippedToController.text;
    widget.dispacthDetails['shippingAddress'] = _shippingAddressController.text;
    widget.dispacthDetails['phoneNo'] = _phoneNoController.text;
    widget.dispacthDetails['gstNo'] = _gstNoController.text;
    widget.dispacthDetails['remarks'] = _remarksController.text;
    widget.dispacthDetails['licenceNo'] = _licenceNoController.text;
    widget.dispacthDetails['issueState'] = _issueStateController.text;
    widget.dispacthDetails['name'] = _nameController.text;
    widget.dispacthDetails['address'] = _addressController.text;

    print(widget.dispacthDetails);

    Navigator.of(context).pop(); // Close the dialog
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.745,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blueAccent[400],
                ),
                child: const Text(
                  "Dispatch Details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Basic Details",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Trans. Agency",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 50),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _transAgencyController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Docket No",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 75),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _docketNoController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Vehicle No",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 74),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _vehicleNoController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "From Station",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 58),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _fromStationController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "From District",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 58),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _fromDistrictController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      
                      
                      
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Trans. Mode",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _transModeController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Parcel",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 45),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _parcelController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Freight",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 40),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _freightController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Kms",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 57.5),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _kmsController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "To State",
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  // const SizedBox(width: 32),
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: TextFormField(
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          height: 1,
                                        ),
                                        controller: _toStateController,
                                        cursorColor: Colors.deepPurple,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      
                      
                      
                      
                      
                      
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "E Way Bill Required",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 16),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  height: 1,
                                ),
                                controller: _ewayBillController,
                                cursorColor: Colors.deepPurple,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                
                
                
                
                
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "Other Details",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Billing Address",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 45),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  height: 1,
                                ),
                                controller: _billingAddressController,
                                cursorColor: Colors.deepPurple,
                                maxLines: 2,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Shipped to",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 75),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  height: 1,
                                ),
                                controller: _shippedToController,
                                cursorColor: Colors.deepPurple,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Shipping Address",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 27),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 81,
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  height: 1,
                                ),
                                controller: _shippingAddressController,
                                cursorColor: Colors.deepPurple,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                
                
                
                
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Phone No",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 82),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      height: 1,
                                    ),
                                    controller: _phoneNoController,
                                    cursorColor: Colors.deepPurple,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "GST No",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 24),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      height: 1,
                                    ),
                                    controller: _gstNoController,
                                    cursorColor: Colors.deepPurple,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                  
                  
                  
                  
                  
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Remarks",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 90),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  height: 1,
                                ),
                                controller: _remarksController,
                                cursorColor: Colors.deepPurple,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                
                
                
                
                
                
                
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Drivers Details",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Licence No",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                              // const SizedBox(width: 73),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      height: 1,
                                    ),
                                    controller: _licenceNoController,
                                    cursorColor: Colors.deepPurple,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  "Issue State",
                                  style: TextStyle(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  child: TextFormField(
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      height: 1,
                                    ),
                                    controller: _issueStateController,
                                    cursorColor: Colors.deepPurple,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                   
                   
                   
                   
                   
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Name",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 110),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  height: 1,
                                ),
                                controller: _nameController,
                                cursorColor: Colors.deepPurple,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Text(
                              "Address",
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 94),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 40,
                              width: MediaQuery.of(context).size.width,
                              child: TextFormField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  height: 1,
                                ),
                                controller: _addressController,
                                cursorColor: Colors.deepPurple,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
               
               
               
               
               
               
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 226, 201, 126)),
              ),
              onPressed: saveDispatchValues,
              child: const Text(
                'Save [F4]',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 3),
            ElevatedButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black),
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 226, 201, 126)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
