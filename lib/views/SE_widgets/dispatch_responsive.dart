import 'package:flutter/material.dart';

class FullScreenDialog extends StatefulWidget {
  const FullScreenDialog({super.key, required this.dispacthDetails});

  final Map<String, dynamic> dispacthDetails;

  @override
  State<FullScreenDialog> createState() => _FullScreenDialogState();
}

class _FullScreenDialogState extends State<FullScreenDialog> {
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
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppBar(
              title: const Text('Dispatch Details',
                  style: TextStyle(color: Colors.white)),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blueAccent[400],
              actions: <Widget>[
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Text(
                        "Basic Details",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Basic Details Fields....
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Trans. Agency",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 50),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Docket No",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 75),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Vehicle No",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 74),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "From Station",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 58),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "From District",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 58),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Trans. Mode",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Parcel",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 45),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Freight",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 40),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Kms",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 57.5),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "To State",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 32),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "E Way Bill Required",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 16),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Text(
                        "Other Details",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // Other Details Fields....
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Billing Address",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 45),
                            SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.width * 0.70,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Shipped to",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 75),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Shipping Address",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 27),
                            SizedBox(
                              height: 81,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Phone No",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 82),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "GST No",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Remarks",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 90),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),
                    // Drivers Details...
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      child: Text(
                        "Driver's Details",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Licence No",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 73),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Issue State",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Name",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 110),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: const Text(
                                "Address",
                                style: TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // const SizedBox(width: 94),
                            SizedBox(
                              height: 30,
                              width: MediaQuery.of(context).size.width * 0.7,
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
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Buttons...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            foregroundColor:
                                WidgetStateProperty.all(Colors.black),
                            backgroundColor: WidgetStateProperty.all(
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
                            foregroundColor:
                                WidgetStateProperty.all(Colors.black),
                            backgroundColor: WidgetStateProperty.all(
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

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
