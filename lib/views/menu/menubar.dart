import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../NU_responsive/user_group_master.dart';
import '../Barcode_print_homepage.dart';
import '../CM_responsive/CM_master_list_desktop_body.dart';
import '../CM_responsive/CM_new_desktop_body.dart';
import '../Company_Setup/Company_setup_desktop.dart';
import '../DC_homepage.dart';
import '../Daily_cash_resposive/daily_cash_master.dart';
import '../GST_Report/GST_report_desktop.dart';
import '../IC_homepage.dart';
import '../PURCHASE_RETURN/purchase_return.dart';
import '../TrailBalance_resposive/trail_balance.dart';
import '../UM_responsive/UM_desktop_body.dart';
import '../export_excel.dart';
import '../import_excel.dart';
import '../item_brand_edit.dart';
import '../item_group_edit.dart';
import '../item_hsn_edit.dart';
import '../item_mesurement_unit_edit.dart';
import '../item_secondary_unit.dart';
import '../sales_summary_homepage.dart';
import '../sumit_screen/cheque_return_entry/cheque_return_desktop.dart';
import '../sumit_screen/gst_payment/gst_payment_desktop.dart';
import '../sumit_screen/ledger_dashboard/ledger_dashboard_desktop.dart';
import '../sumit_screen/voucher _entry.dart/voucher_desktop.dart';

class CustomAppBarMenuAdmin {
  CustomAppBarMenuAdmin(BuildContext context);

  static Widget buildTitleMenu(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: buildFileMenu1(context, 'Accounts'),
        ),
        VerticalDivider(
          width: MediaQuery.of(context).size.width * 0.00,
          thickness: 2,
          indent: 0,
          endIndent: 0,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: buildFileMenu2(context, 'Inventory'),
        ),
        VerticalDivider(
          width: MediaQuery.of(context).size.width * 0.00,
          thickness: 2,
          indent: 0,
          endIndent: 0,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: buildFileMenu3(context, 'SMS'),
        ),
        VerticalDivider(
          width: MediaQuery.of(context).size.width * 0.00,
          thickness: 2,
          indent: 0,
          endIndent: 0,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: buildFileMenu4(context, 'Admin'),
        ),
        VerticalDivider(
          width: MediaQuery.of(context).size.width * 0.00,
          thickness: 2,
          indent: 0,
          endIndent: 0,
          color: Colors.black,
        ),
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: buildFileMenu5(context, 'Utility'),
        ),
      ],
    );
  }

  static Widget buildFileMenu1(BuildContext context, String title) {
    return buildMenu(context, title, [
      const PopupMenuItem<String>(
        height: 0,
        value: 'Voucher Entry',
        child: Text("Voucher Entry"),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Quick Voucher Entry',
        child: Text('Quick Voucher Entry'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Cheque Return Entry',
        child: Text('Cheque Return Entry'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Recivable Adjustment',
        child: Text('Recivable Adjustment'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Payable Adjustment',
        child: Text('Payable Adjustment'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Daily Cash Denomination',
        child: Text('Daily Cash Denomination'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Auto Voucher Entry',
        child: Text('Auto Voucher Entry'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'GST Payment/Adjustment',
        child: Text('GST Payment/Adjustment'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'State Master',
        child: Text('State Master'),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Ledger Master',
        child: Text('Ledger Master'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Ledger Dashboard',
        child: Text('Ledger Dashboard'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Ledger Group Master',
        child: Text('Ledger Group Master'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Ledger S. Man Master',
        child: Text('Ledger S. Man Master'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Tax Category',
        child: Text('Tax Category'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Tax Category (GST)',
        child: Text('Tax Category (GST)'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Sundry Component',
        child: Text('Sundry Component'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'HSN Commodity Master',
        child: Text('HSN Commodity Master'),
      ),
      const PopupMenuDivider(),
      PopupMenuItem<String>(
        height: 0,
        value: 'Reports',
        child: buildSubMenu2(context, 'Reports', [
          'Ledger Statment',
          'Ledger Statment (T-Format)',
          'Ledger (per Sales Statment)',
          'Bank Reconcillation',
          'Ledger Group Vouchers',
          'Agewise Outstanding Report',
          'Voucher Register',
          ' Voucher Summary',
          ' Cheque Deposit Register',
          'Sundry Transaction Register',
          'Day Book',
          'Statistics Report',
          'Ledger Month/Daywise Summary',
          'Multi Ledger Printing'
        ]),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'MIS Reports',
        child: buildSubMenu1(context, 'MIS Reports', [
          'Ledger Periodic Summary',
          'Ledger Group Periodic Summary',
          'Ledger Group Summary',
          'VAT Reports',
          'GST Reports',
          'Cash Flow Summary',
          'Group Cash Flow Summary'
        ]),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Final Reports',
        child: buildSubMenu2(context, 'Final Reports',
            ['Trail Balance', 'Profit Loss A/c', 'Balance Sheet']),
      ),

      // const PopupMenuItem<String>(
      //   value: 'Profit Sharing Ratio',
      //   child: Text(
      //     'Profit Sharing Ratio',
      //   ),
      // ),
      // const PopupMenuItem<String>(
      //   value: 'Transaction Types',
      //   child: Text('Transaction Types'),
      // ),
      // const PopupMenuItem<String>(
      //   value: 'Accounts Groups',
      //   child: Text('Accounts Groups'),
      // ),
      // const PopupMenuItem<String>(
      //   value: 'Branch Master',
      //   child: Text('Branch Master'),
      // ),
      // const PopupMenuItem<String>(
      //   value: 'Control Parameter',
      //   child: Text('Control Parameter'),
      // ),
    ]);
  }

  static Widget buildFileMenu2(BuildContext context, String title) {
    return buildMenu(context, title, [
      PopupMenuItem<String>(
        height: 0,
        value: 'Purchase',
        child: Text(
          'Purchase',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Inward Challan',
        child: Text(
          'Inward Challan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Sales',
        child: Text(
          'Sales',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Statement of Sales',
        child: Text(
          'Statement of Sales',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Delivery Challan',
        child: Text(
          'Delivery Challan',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Purchase Return / Debit Note',
        child: Text(
          'Purchase Return / Debit Note',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'EWay Bill JSON Generate',
        child: Text(
          'EWay Bill JSON Generate',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Sales Return / Credit Note',
        child: Text(
          'Sales Return / Credit Note',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem<String>(
        height: 0,
        value: 'Proforma Invoice',
        child: Text(
          'Proforma Invoice',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Sales Quotation',
        child: Text(
          'Sales Quotation',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Stock Transfer',
        child: Text(
          'Stock Transfer',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Stock Physical Verification',
        child: Text(
          'Stock Physical Verification',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Stock Shortage',
        child: Text(
          'Stock Shortage',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Manual Stock Value Sheet',
        child: Text('Manual Stock Value Sheet'),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Quick Order List',
        child: Text('Quick Order List'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Item Info',
        child: Text('Item Info'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Store Master',
        child: Text('Store Master'),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Other Reports',
        child: buildSubMenu2(context, 'Other Reports', [
          'Region / Partywise Item Sales',
          'Pending Orders',
          'Pending Challans',
          'Agent Commission Register',
          'Agent Commission Summary',
          'Auto Production Register',
          'Stock Transfer Register',
          ' E Invoice / Eway Register',
          ' PineLab Payment Register',
        ]),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Barcode',
        child: buildSubMenu2(context, 'Barcode', [
          'Print Barcode',
          'Barcode Template',
        ]),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Reports',
        child: buildSubMenu2(context, 'Reports', [
          'Stock Status',
          'Stock Item Periodic Summary',
          'Stock Movement Summary',
          'Stock Item Movement Ledgerwise',
          'Stock Valution / Pricing / Margin Report',
          'Stock Statement',
          'Stock Statement (Multi Item)',
          'Dispatch Summary Report',
          'Stock Status Barcode Serialwise',
          'Stock Status Godown wise',
          'Sales Register',
          'Sales Return Register',
          'Sales Quotation Register',
          'Purchase Register',
          'Purchase Enquiry Register',
          'Purchase Return Register',
          'Delivery Challan Register',
          'Inward Challan Register',
          'Shortage Register',
          'Stock Transfer Register',
        ]),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'MIS Reports',
        child: buildSubMenu2(context, 'MIS Reports', [
          'Sales Summary',
          'Sales Return Summary',
          'Sales Return Summary',
          'Sales Qutation Summary',
          'Purchase Summary',
          'Purchase Return Summary',
          'Shortage Summary',
          'Stock Transfer Summary',
          'Delivery Challan Summary',
          'Inward Challan Summary',
          'Consolidated Summary',
          'Comparison Reports',
          'Party | Item Analysis',
          'Item | Party Analysis',
          'Sales Performance Analysis',
          'Purchase Performance Analysis',
          'Min / Max Qty vs Avg Sales Analysis',
          'InActive Items',
          'InActive Customers ',
        ]),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        height: 0,
        value: 'MIS Reports',
        child: Text('MIS Reports'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Item Group Master',
        child: Text('Item Group Master'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Item Brand Master',
        child: Text('Item Brand Master'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Hsn Code Master',
        child: Text('Hsn Code Master'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Measurement Unit Master',
        child: Text('Measurement Unit Master'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Secondary Unit Master',
        child: Text('Secondary Unit Master'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Misc. Master',
        child: Text('Misc. Master'),
      ),
    ]);
  }

  static buildFileMenu3(BuildContext context, String title) {
    return buildMenu(context, title, [
      PopupMenuItem<String>(
        height: 0,
        value: 'Company Parameter setup',
        child: buildSubMenu2(context, 'Company Parameter setup',
            ['Control Parameters', 'Profit Sharing Ratio', 'ShortHand Keys']),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Transaction Types',
        child: Text('Transaction Types'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Accounts Master Setup',
        child: Text('Accounts Master Setup'),
      ),
    ]);
  }

  static Widget buildFileMenu4(BuildContext context, String title) {
    return buildMenu(context, title, [
      const PopupMenuItem<String>(
        height: 0,
        value: 'Users',
        child: Text('Users'),
      ),
      // const PopupMenuItem<String>(
      //   height: 0,
      //   value: 'Users Group',
      //   child: Text('Users Group'),
      // ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'User Dashboard Category',
        child: Text('User Dashboard Category'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'User Favourite Menu',
        child: Text('User Favourite Menu'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Company Setup',
        child: Text('Company Setup'),
      ),
      // const PopupMenuDivider(),
      // const PopupMenuItem<String>(
      //   height: 0,
      //   value: 'Create Company',
      //   child: Text('Create Company'),
      // ),
      // const PopupMenuItem<String>(
      //   height: 0,
      //   value: 'Company List Master',
      //   child: Text('Company List Master'),
      // ),
    ]);
  }

  static Widget buildFileMenu5(BuildContext context, String title) {
    return buildMenu(context, title, [
      const PopupMenuItem<String>(
        height: 0,
        value: 'Start Remote Support',
        child: Text('Start Remote Support'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Check Internet Speed',
        child: Text('Check Internet Speed'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Calculator',
        child: Text('Calculator'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'To Do List',
        child: Text('To Do List'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Sign PDF File',
        child: Text('Sign PDF File'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Reminders',
        child: Text('Reminders'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Cash Denomination Calculation',
        child: Text('Cash Denomination Calculation'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Change Password',
        child: Text('Change Password'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Change A/c Year',
        child: Text('Change A/c Year'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Change Company',
        child: Text('Change Company'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Custom Reports',
        child: Text('Custom Reports'),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Backup Data',
        child: Text('Backup Data'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Backup Email/Whatsapp',
        child: Text('Backup Email/Whatsapp'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Restore Data',
        child: Text('Restore Data'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Delete Transactions / Masters',
        child: Text('Delete Transactions / Masters'),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Data Export',
        child: Text('Data Export'),
      ),
      PopupMenuItem<String>(
        height: 0,
        value: 'Data Import',
        child: buildSubMenu5(context, 'Data Import', [
          'Print Barcode',
          'Barcode Template',
        ]),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Optimize Database',
        child: Text('Optimize Database'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Software Update Patch',
        child: Text('Software Update Patch'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'A/c Balance Update',
        child: Text('A/c Balance Update'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Stock Balance Update',
        child: Text('Stock Balance Update'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'ReNumber Vouchers',
        child: Text('ReNumber Vouchers'),
      ),
      const PopupMenuItem<String>(
        height: 0,
        value: 'Item Display',
        child: Text('Item Display'),
      ),
    ]);
  }

  static Widget buildMenu(
      BuildContext context, String title, List<PopupMenuEntry<String>> items) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return items;
      },
      onSelected: (value) {
        // Handle menu item click

        if (value == 'Voucher Entry') {
          print(value);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VoucherEntryDesktop(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Daily Cash Denomination') {
          print(value);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DailyCashMaster(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Cheque Return Entry') {
          print(value);
          openDialog1(context);
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Users') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserMaster(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Users Group') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserGroupMaster(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Item Group Master') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItemGroupEdit(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Item Brand Master') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItemBrandEdit(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Hsn Code Master') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItemHSNEdit(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Measurement Unit Master') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItemMeasurementUnitEdit(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Secondary Unit Master') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ItemSecondaryUnitEdit(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Data Export') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExportExcel(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }

        if (value == 'Company Setup') {
          print(value);
          // Navigate to the RecentPage
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 10,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const CompanySetup()),
              );
            },
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Create Company') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CMNDesktopBody(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Company List Master') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CompanyListDesktopBody(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Auto Voucher Entry') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const NarrationMaster(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'GST Payment/Adjustment') {
          print(value);
          // Navigate to the RecentPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const Responsive_GSTPayment(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'State Master') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const AreaMaster(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Inward Challan') {
          print(value);

          // Navigate to the RecentPage
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const ICHomepage();
            },
          ));
        } else {}
        if (value == 'Purchase Return / Debit Note') {
          print(value);

          // Navigate to the RecentPage
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const PurchaseReturn();
            },
          ));
        } else {}
        if (value == 'Delivery Challan') {
          print(value);

          // Navigate to the RecentPage
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const DCHomepage();
            },
          ));
        } else {}
        if (value == 'Ledger Master') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const ProductClass(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Ledger Dashboard') {
          print(value);
          // Navigate to the RecentPage
          openDialog2(context);
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Ledger Group Master') {
          print(value);
          // // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const DispatchForm(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Ledger S. Man Master') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const SubAccountMaster(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Tax Category') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const StoreMaster(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Tax Category (GST)') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const BranchMaster(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Sundry Component') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const DebtorsOpening(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'HSN Commodity Master') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const Sales(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Reports') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const TransactionType(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'MIS Reports') {
          print(value);
          // Navigate to the RecentPage
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const AccountMaster(),
          //   ),
          // );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
        if (value == 'Trail Balance') {
          print(value);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrailBalance(),
            ),
          );
        } else {
          print(value);
          print('Clicked on $title > $value');
        }
      },
      offset: const Offset(30, 30),

      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ), // Adjust the offset as needed
    );
  }

  static buildSubMenu1(
      BuildContext context, String label, List<String> subMenuItems) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return subMenuItems.map((String item) {
          return PopupMenuItem<String>(
            height: 0,
            value: item,
            child: Text(item),
          );
        }).toList();
      },
      offset: const Offset(180, 20),
      child: Row(
        children: [
          Text(label),
          const Icon(Icons.arrow_right),
        ],
      ),
      onSelected: (selectedValue) {
        // Handle the selected value here, similar to _buildMenu
        print('Clicked on $label > $selectedValue');

        // Add your navigation logic here
        // For example, you can check the selected value and navigate accordingly
        if (label == 'MIS Reports' && selectedValue == 'GST Reports') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const GstReportDesktop(),
            ),
          );
        } else {
          print('Clicked on $label > $selectedValue');
        }
        // Add similar blocks for other cases as needed
      },
    );
  }

  static buildSubMenu2(
      BuildContext context, String label, List<String> subMenuItems) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return subMenuItems.map((String item) {
          return PopupMenuItem<String>(
            height: 0,
            value: item,
            child: Text(item),
          );
        }).toList();
      },
      offset: const Offset(213, 20),
      child: Row(
        children: [
          Text(label),
          const Icon(Icons.arrow_right),
        ],
      ),
      onSelected: (selectedValue) {
        // Handle the selected value here, similar to _buildMenu
        print('Clicked on $label > $selectedValue');

        // Add your navigation logic here
        // For example, you can check the selected value and navigate accordingly
        if (label == 'MIS Reports' && selectedValue == 'Sales Summary') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SalesSummaryhomepage(),
            ),
          );
        } else if (label == 'Final Reports' &&
            selectedValue == 'Trail Balance') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrailBalance(),
            ),
          );
        } else if (label == 'Barcode' && selectedValue == 'Print Barcode') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BarcodePrintHomepage(),
            ),
          );
        } else {
          print('Clicked on $label > $selectedValue');
        }
        // Add similar blocks for other cases as needed
      },
    );
  }

  static buildSubMenu5(
      BuildContext context, String label, List<String> subMenuItems) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return subMenuItems.map((String item) {
          return PopupMenuItem<String>(
            height: 0,
            value: item,
            child: Text(item),
          );
        }).toList();
      },
      offset: const Offset(180, 20),
      child: Row(
        children: [
          Text(label),
          const Icon(Icons.arrow_right),
        ],
      ),
      onSelected: (selectedValue) {
        // Handle the selected value here, similar to _buildMenu
        print('Clicked on $label > $selectedValue');

        // Add your navigation logic here
        // For example, you can check the selected value and navigate accordingly
        if (label == 'Data Import' && selectedValue == 'Import Item') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                elevation: 10,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 280,
                    child: const ImportExcel()),
              );
            },
          );
        } else if (label == 'Data Import' && selectedValue == 'Import Ledger') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ImportExcel(),
            ),
          );
        } else {
          print('Clicked on $label > $selectedValue');
        }
        // Add similar blocks for other cases as needed
      },
    );
  }
}

void openDialog1(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const ChequeReturnEntry(),
  );
}

void openDialog2(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const LedgerDashboard(),
  );
}
