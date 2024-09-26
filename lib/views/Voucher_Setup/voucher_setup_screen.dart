// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VoucherSetupScreen extends StatefulWidget {
  const VoucherSetupScreen({super.key});

  @override
  State<VoucherSetupScreen> createState() => _VoucherSetupScreenState();
}

class _VoucherSetupScreenState extends State<VoucherSetupScreen> {
  List<String> isActive = ['Yes', 'No'];
  String selectedIsActive = 'Yes';
  List<String> numbering = ['Auto', 'Manual'];
  String selectedNumbering = 'Auto';
  List<String> verifyPayment = ['Yes', 'No'];
  String selectedVerifyPayment = 'Yes';
  List<String> resetOn = ['Yearly', 'Monthly', 'Daily'];
  String selectedResetOn = 'Yearly';
  List<String> remark = ['Yes', 'No'];
  String selectedRemark = 'Yes';
  List<String> defaultPayment = ['Not Required', 'Cash', 'debit', 'Multimode'];
  String selectedDefaultPayment = 'Not Required';
  List<String> showSavedNo = ['Yes', 'No'];
  String selectedShowSavedNo = 'Yes';
  List<String> askVoucher = ['Yes', 'No'];
  String selectedAskVoucher = 'Yes';
  List<String> discount = ['Yes', 'No'];
  String selectedDiscount = 'Yes';
  List<String> discount2 = ['Yes', 'No'];
  String selectedDiscount2 = 'Yes';
  List<String> taxVoucher = ['Yes', 'No'];
  String selectedTaxVoucher = 'Yes';
  List<String> rateIncludeTax = ['Yes', 'No'];
  String selectedRateIncludeTax = 'Yes';
  List<String> displayTaxAmt = ['Yes', 'No'];
  String selectedDisplayTaxAmt = 'Yes';
  List<String> transportDetails = ['Yes', 'No'];
  String selectedTransportDetails = 'Yes';
  List<String> promptAfterSave = ['Yes', 'No'];
  String selectedPromptAfterSave = 'Yes';
  List<String> itemGrouping = ['Yes', 'No'];
  String selectedItemGrouping = 'Yes';
  List<String> mrpColumn = ['Yes', 'No'];
  String selectedMrpColumn = 'Yes';
  List<String> itemCodeColumn = ['Yes', 'No'];
  String selectedItemCodeColumn = 'Yes';
  List<String> batchColumn = ['Yes', 'No'];
  String selectedBatchColumn = 'Yes';
  List<String> freeQtyColumn = ['Yes', 'No'];
  String selectedFreeQtyColumn = 'Yes';
  List<String> secondQtyColumn = ['Yes', 'No'];
  String selectedSecondQtyColumn = 'Yes';
  List<String> baseRateColumn = ['Yes', 'No'];
  String selectedBaseRateColumn = 'Yes';
  List<String> captureImage = ['Yes', 'No'];
  String selectedCaptureImage = 'Yes';
  List<String> captureSignature = ['Yes', 'No'];
  String selectedCaptureSignature = 'Yes';
  List<String> autoRoundOff = ['Yes', 'No'];
  String selectedAutoRoundOff = 'Yes';
  List<String> clubSameType = ['Yes', 'No'];
  String selectedClubSameType = 'Yes';
  List<String> sundryTaxInfo = ['Yes', 'No'];
  String selectedSundryTaxInfo = 'Yes';
  List<String> netRateColumn = ['Yes', 'No'];
  String selectedNetRateColumn = 'Yes';
  List<String> paymentOnSave = ['Yes', 'No'];
  String selectedPaymentOnSave = 'Yes';
  List<String> skipBatchSelect = ['Yes', 'No'];
  String selectedSkipBatchSelect = 'Yes';
  List<String> sundryDiscInfo = ['Yes', 'No'];
  String selectedSundryDiscInfo = 'Yes';
  List<String> stockColumn = ['Yes', 'No'];
  String selectedStockColumn = 'Yes';
  List<String> cashDenomination = ['Yes', 'No'];
  String selectedCashDenomination = 'Yes';
  List<String> customItemGroup = ['Yes', 'No'];
  String selectedCustomItemGroup = 'Yes';
  List<String> retailCustInput = ['Yes', 'No'];
  String selectedRetailCustInput = 'Yes';
  List<String> unitSelection = ['Yes', 'No'];
  String selectedUnitSelection = 'Yes';
  List<String> sundryVisible = ['Yes', 'No'];
  String selectedSundryVisible = 'Yes';
  List<String> refRequired1 = ['Yes', 'No'];
  String selectedRefRequired1 = 'Yes';
  List<String> refRequired2 = ['Yes', 'No'];
  String selectedRefRequired2 = 'Yes';
  List<String> refNoCaption1 = ['Yes', 'No'];
  String selectedRefNoCaption1 = 'Yes';
  List<String> refNoCaption2 = ['Yes', 'No'];
  String selectedRefNoCaption2 = 'Yes';
  List<String> rateDeciAuto = ['Yes', 'No'];
  String selectedRateDeciAuto = 'Yes';
  List<String> autoProduction = ['Yes', 'No'];
  String selectedAutoProduction = 'Yes';
  List<String> ignoreSplitBiils = ['Yes', 'No'];
  String selectedIgnoreSplitBiils = 'Yes';
  List<String> postingAC = ['Yes', 'No'];
  String selectedPostingAC = 'Yes';
  List<String> confirmOnSave = ['Yes', 'No'];
  String selectedConfirmOnSave = 'Yes';

  List<String> printTemplate = ['Yes', 'No'];
  String selectedPrintTemplate = 'Yes';
  List<String> altPrintTemplate = ['Yes', 'No'];
  String selectedAltPrintTemplate = 'Yes';
  List<String> printAfterSave = ['Yes', 'No'];
  String selectedPrintAfterSave = 'Yes';
  List<String> noOfCopies = ['Yes', 'No'];
  String selectedNoOfCopies = 'Yes';
  List<String> askTemplate = ['Yes', 'No'];
  String selectedAskTemplate = 'Yes';
  List<String> showPrintPrompt = ['Yes', 'No'];
  String selectedShowPrintPrompt = 'Yes';
  List<String> showPreview = ['Yes', 'No'];
  String selectedShowPreview = 'Yes';
  List<String> printBothTemplate = ['Yes', 'No'];
  String selectedPrintBothTemplate = 'Yes';
  List<String> showBankDetails = ['Yes', 'No'];
  String selectedShowBankDetails = 'Yes';
  List<String> printPrefix = ['Yes', 'No'];
  String selectedPrintPrefix = 'Yes';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.brown[400],
            ),
            child: Center(
              child: Text(
                'EDIT VOUCHER TYPE',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        child: Container(
                          height: size.height * 0.4,
                          width: size.width * 0.45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Basic Info',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.2),
                                    Text(
                                      'WhatsApp Settings',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                // Row
                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    const LabelText(labelName: "Name"),
                                    MyTextField2(size: size.width / 8.5),
                                    const LabelText(labelName: "Print Name"),
                                    MyTextField2(size: size.width / 8.5),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(labelName: "Short Name"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: isActive,
                                        selectedValue: selectedIsActive),
                                    const LabelText(labelName: "Is Active"),
                                    MyTextField2(size: size.width / 18.5),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(labelName: "Numbering"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: numbering,
                                        selectedValue: selectedNumbering),
                                    const LabelText(labelName: "Start From"),
                                    MyTextField2(size: size.width / 18.5),
                                    const LabelText(labelName: "Verify Paym"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: verifyPayment,
                                        selectedValue: selectedVerifyPayment),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(labelName: "Reset On"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: resetOn,
                                        selectedValue: selectedResetOn),
                                    const LabelText(labelName: "Padding"),
                                    MyTextField2(size: size.width / 18.5),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(labelName: "Ask Voucher"),
                                    MyTextField(
                                      size: size.width / 18.5,
                                      items: askVoucher,
                                      selectedValue: selectedAskVoucher,
                                    ),
                                    const LabelText(labelName: "Remarks"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: remark,
                                        selectedValue: selectedRemark),
                                    const LabelText(
                                        labelName: "Default Payment"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: defaultPayment,
                                        selectedValue: selectedDefaultPayment),
                                    const SizedBox(height: 8),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(labelName: "Show Saved No"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: showSavedNo,
                                        selectedValue: selectedShowSavedNo),
                                    const LabelText(labelName: "Title Color"),
                                    MyTextField2(size: size.width / 8.5),
                                    const SizedBox(height: 8),
                                    Container(
                                      color: Colors.green.shade700,
                                      height: 40,
                                      width: size.width / 10.0,
                                      child: const Center(
                                        child: Text(
                                          "Select",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 4.0),
                        child: Container(
                          height: size.height * 0.4,
                          width: size.width * 0.45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Printing Option',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    SizedBox(width: size.width * 0.2),
                                    Text(
                                      'Advance Option',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(
                                        labelName: "Print Template"),
                                    MyTextField(
                                        size: size.width / 4,
                                        items: printTemplate,
                                        selectedValue: selectedPrintTemplate),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(
                                        labelName: "Alt.Print Template"),
                                    MyTextField(
                                        size: size.width / 4,
                                        items: altPrintTemplate,
                                        selectedValue:
                                            selectedAltPrintTemplate),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(
                                        labelName: "Print After Save"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: printAfterSave,
                                        selectedValue: selectedPrintAfterSave),
                                    const LabelText(labelName: "No.Of copies"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: noOfCopies,
                                        selectedValue: selectedNoOfCopies),
                                    const LabelText(labelName: "Ask Templ."),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: askTemplate,
                                        selectedValue: selectedAskTemplate),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(
                                        labelName: "Show Print Prompt"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: showPrintPrompt,
                                        selectedValue: selectedShowPrintPrompt),
                                    const LabelText(labelName: "Show Preview"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: showPreview,
                                        selectedValue: selectedShowPreview),
                                    const LabelText(
                                        labelName: "Prnt Both Templ"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: printBothTemplate,
                                        selectedValue:
                                            selectedPrintBothTemplate),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(
                                        labelName: "Terms & Condition"),
                                    SizedBox(
                                      width: size.width / 4,
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.zero),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.zero),
                                          ),
                                          keyboardType: TextInputType.multiline,
                                          minLines: 2,
                                          maxLines: 2,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const LabelText(
                                        labelName: "Show Bank Detail"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: showBankDetails,
                                        selectedValue: selectedShowBankDetails),
                                    const LabelText(labelName: "Print Prefix"),
                                    MyTextField(
                                        size: size.width / 18.5,
                                        items: printPrefix,
                                        selectedValue: selectedPrintPrefix),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Container(
                      height: size.height * 0.44,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Stock Voucher Option',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LabelText(labelName: "1 Discount"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: discount,
                                    selectedValue: selectedDiscount),
                                const LabelText(labelName: "2 Discount 2"),
                                MyTextField(
                                    size: size.width / 24,
                                    items: discount2,
                                    selectedValue: selectedDiscount2),
                                const LabelText(labelName: "3 Tax Voucher"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: taxVoucher,
                                    selectedValue: selectedTaxVoucher),
                                const LabelText(labelName: "4 Tax Exclusive"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: rateIncludeTax,
                                    selectedValue: selectedRateIncludeTax),
                                const LabelText(
                                    labelName: "5 Rate Include Tax"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: displayTaxAmt,
                                    selectedValue: selectedRateIncludeTax),
                                const LabelText(
                                    labelName: "6 Display Tax Amount"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: displayTaxAmt,
                                    selectedValue: selectedDisplayTaxAmt),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              
                              children: [
                                const LabelText(
                                    labelName: "7 Transport Detail"),
                                MyTextField(
                                  size: size.width / 25,
                                  items: transportDetails,
                                  selectedValue: selectedTransportDetails,
                                ),
                                const SizedBox(width: 60),
                                const LabelText(
                                    labelName: "8 Prompt After Save"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: promptAfterSave,
                                    selectedValue: selectedPromptAfterSave),
                                const Spacer(),
                                const LabelText(labelName: "12 Item Grouping"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: itemGrouping,
                                    selectedValue: selectedItemGrouping),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LabelText(labelName: "13 MRF Columns"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: mrpColumn,
                                    selectedValue: selectedMrpColumn),
                                const LabelText(
                                    labelName: "14 Itemcode Columns"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: itemCodeColumn,
                                    selectedValue: selectedItemCodeColumn),
                                const LabelText(labelName: "15 Batch Columns"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: batchColumn,
                                    selectedValue: selectedBatchColumn),
                                const LabelText(
                                    labelName: "16 FreeQty Columns"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: freeQtyColumn,
                                    selectedValue: selectedFreeQtyColumn),
                                const LabelText(labelName: "17 2ndQty Column"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: secondQtyColumn,
                                    selectedValue: selectedSecondQtyColumn),
                                const LabelText(
                                    labelName: "18 Base Rate Column"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: baseRateColumn,
                                    selectedValue: selectedBaseRateColumn),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LabelText(labelName: "19 Capture Image"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: captureImage,
                                    selectedValue: selectedCaptureImage),
                                const LabelText(labelName: "20 Capture Sign"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: captureSignature,
                                    selectedValue: selectedCaptureSignature),
                                const LabelText(labelName: "21 Auto Round Off"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: autoRoundOff,
                                    selectedValue: selectedAutoRoundOff),
                                const LabelText(labelName: "22 Club SameItem"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: clubSameType,
                                    selectedValue: selectedClubSameType),
                                const LabelText(
                                    labelName: "23 Sundry Tax Info"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: sundryTaxInfo,
                                    selectedValue: selectedSundryTaxInfo),
                                const LabelText(
                                    labelName: "24 Net Rate Column"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: netRateColumn,
                                    selectedValue: selectedNetRateColumn),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LabelText(
                                    labelName: "25 Payment on Save"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: paymentOnSave,
                                    selectedValue: selectedPaymentOnSave),
                                const LabelText(
                                    labelName: "26 CustomLedgerGroup"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: customItemGroup,
                                    selectedValue: selectedCustomItemGroup),
                                const LabelText(
                                    labelName: "27 Skip Batch Select"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: skipBatchSelect,
                                    selectedValue: selectedSkipBatchSelect),
                                const Spacer(),
                                const LabelText(
                                    labelName: "29 Sundry Disc Info"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: sundryDiscInfo,
                                    selectedValue: selectedSundryDiscInfo),
                                const LabelText(labelName: "30 Stock Column"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: stockColumn,
                                    selectedValue: selectedStockColumn),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LabelText(labelName: "31 Cash Denom"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: cashDenomination,
                                    selectedValue: selectedCashDenomination),
                                const LabelText(
                                    labelName: "32 CustomItemGroup"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: customItemGroup,
                                    selectedValue: selectedCustomItemGroup),
                                const LabelText(
                                    labelName: "33 Retail Cust. Input"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: retailCustInput,
                                    selectedValue: selectedRetailCustInput),
                                const LabelText(labelName: "34 Rate Deci.Auto"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: rateDeciAuto,
                                    selectedValue: selectedRateDeciAuto),
                                const LabelText(labelName: "35 Unit Selection"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: unitSelection,
                                    selectedValue: selectedUnitSelection),
                                const LabelText(labelName: "36 Sundry Visible"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: sundryVisible,
                                    selectedValue: selectedSundryVisible),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const LabelText(
                                    labelName: "37 Auto Production"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: autoProduction,
                                    selectedValue: selectedAutoProduction),
                                const LabelText(
                                    labelName: "38 Ignore Bill Split"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: ignoreSplitBiils,
                                    selectedValue: selectedIgnoreSplitBiils),
                                const LabelText(
                                    labelName: "41 Ref Required (1)"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: refRequired1,
                                    selectedValue: selectedRefRequired1),
                                const LabelText(
                                    labelName: "42 Ref.No Caption (1)"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: refNoCaption1,
                                    selectedValue: selectedRefNoCaption1),
                                const LabelText(
                                    labelName: "43 Ref Required (2)"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: refRequired2,
                                    selectedValue: selectedRefRequired2),
                                const LabelText(
                                    labelName: "44 Ref.No Caption (2)"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: refNoCaption2,
                                    selectedValue: selectedRefNoCaption2),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const LabelText(labelName: "46 Posting A/c"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: postingAC,
                                    selectedValue: selectedPostingAC),
                                const LabelText(
                                    labelName: "47 Confirm on Save No"),
                                MyTextField(
                                    size: size.width / 25,
                                    items: confirmOnSave,
                                    selectedValue: selectedConfirmOnSave),
                                const Spacer(),
                                Container(
                                  color: Colors.yellow.shade300,
                                  height: 30,
                                  width: size.width / 8.5,
                                  child: const Center(
                                    child: Text(
                                      "Header",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  color: Colors.yellow.shade300,
                                  height: 30,
                                  width: size.width / 8.5,
                                  child: const Center(
                                    child: Text(
                                      "Detail",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  color: Colors.yellow.shade300,
                                  height: 30,
                                  width: size.width / 8.5,
                                  child: const Center(
                                    child: Text(
                                      "Field Focus",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Row
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 35,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        color: Colors.yellow.shade200),
                    child: const Center(
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    height: 35,
                    width: 120,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        color: Colors.yellow.shade200),
                    child: const Center(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
          //
        ],
      ),
    );
  }
}

class MyTextField extends StatefulWidget {
  final double size;
  final List<String> items;
  String selectedValue;

  MyTextField({
    super.key,
    required this.size,
    required this.items,
    this.selectedValue = '',
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        width: widget.size,
        height: 30,
        child: DropdownButton<String>(
          value: widget.selectedValue,
          items: widget.items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            );
          }).toList(),
          borderRadius: BorderRadius.circular(0),
          padding: const EdgeInsets.symmetric(horizontal: 5),
          isExpanded: true,
          icon: const SizedBox.shrink(),
          underline: Container(),
          onChanged: (value) {
            setState(() {
              widget.selectedValue = value!;
            });
          },
          isDense: true,
        ),
      ),
    );
  }
}

class MyTextField2 extends StatelessWidget {
  final double size;

  const MyTextField2({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        width: size,
        height: 30,
        child: TextFormField(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 35, horizontal: 10),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
          ),
        ),
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String labelName;
  const LabelText({
    super.key,
    required this.labelName,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 250,
      ),
      child: Text(
        labelName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 14,
          wordSpacing: 0.5,
          fontWeight: FontWeight.normal,
          color: Colors.deepPurple.shade700,
        ),
      ),
    );
  }
}
