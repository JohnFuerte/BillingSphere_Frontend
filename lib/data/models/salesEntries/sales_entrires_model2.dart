// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// class SalesEntry {
//   final String id;
//   final String user_id;
//   final int no;
//   final String date;
//   final String type;
//   final String party;
//   final String place;
//   final String dcNo;
//   final String date2;
//   final String totalamount;
//   // String dueAmount;
//   final List<Entry> entries;
//   final List<Sundry2> sundry;
//   final List<Dispatch> dispatch;
//   final String remark;

//   SalesEntry({
//     required this.id,
//     required this.user_id,
//     required this.dispatch,
//     required this.no,
//     required this.date,
//     required this.type,
//     required this.party,
//     required this.place,
//     required this.dcNo,
//     required this.date2,
//     required this.totalamount,
//     // required this.dueAmount,
//     required this.entries,
//     required this.sundry,
//     required this.remark,
//   });

//   factory SalesEntry.fromJson(Map<String, dynamic> json) {
//     return SalesEntry(
//       user_id: json['user_id'],
//       id: json['_id'],
//       no: json['no'],
//       date: json['date'],
//       type: json['type'],
//       party: json['party'],
//       place: json['place'],
//       dcNo: json['dcNo'],
//       date2: json['date'],
//       totalamount: json['totalamount'],
//       // dueAmount: json['dueAmount'],
//       entries: (json['entries'] as List<dynamic>)
//           .map((entryJson) => Entry.fromJson(entryJson))
//           .toList(),
//       sundry: (json['sundry'] as List<dynamic>)
//           .map((sundryJson) => Sundry2.fromJson(sundryJson))
//           .toList(),
//       dispatch: (json['dispatch'] as List<dynamic>)
//           .map((dispatchJson) => Dispatch.fromMap(dispatchJson))
//           .toList(),
//       remark: json['remark'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user_id': user_id,
//       'no': no,
//       'date': date,
//       'type': type,
//       'party': party,
//       'place': place,
//       'dcNo': dcNo,
//       'date2': date2,
//       'totalamount': totalamount,
//       // 'dueAmount': dueAmount,
//       'entries': entries.map((entry) => entry.toJson()).toList(),
//       'sundry': sundry.map((sundry) => sundry.toJson()).toList(),
//       'dispatch': dispatch.map((dispatch) => dispatch.toMap()).toList(),
//       'remark': remark,
//     };
//   }

//   factory SalesEntry.fromMap(Map<String, dynamic> map) {
//     return SalesEntry(
//       dispatch: (map['dispatch'] as List<dynamic>)
//           .map((dispatchJson) => Dispatch.fromMap(dispatchJson))
//           .toList(),
//       id: map['_id'] as String,
//       user_id: map['user_id'] as String,
//       no: map['no'] as int,
//       date: map['date'] as String,
//       type: map['type'] as String,
//       party: map['party'] as String,
//       place: map['place'] as String,
//       dcNo: map['dcNo'] as String,
//       date2: map['date2'] as String,
//       totalamount: map['totalamount'] as String,
//       // dueAmount:  map['totalamount'] as String,
//       entries: (map['entries'] as List<dynamic>)
//           .map((entryJson) => Entry.fromJson(entryJson))
//           .toList(),
//       sundry: (map['sundry'] as List<dynamic>)
//           .map((sundryJson) => Sundry2.fromJson(sundryJson))
//           .toList(),
//       remark: map['remark'] as String,
//     );
//   }
// }

// class Entry {
//   final String itemName;
//   final int qty;
//   final double rate;
//   final String unit;
//   final double amount;
//   final String tax;
//   final double sgst;
//   final double cgst;
//   final double igst;
//   final double netAmount;

//   Entry({
//     required this.itemName,
//     required this.qty,
//     required this.rate,
//     required this.unit,
//     required this.amount,
//     required this.tax,
//     required this.sgst,
//     required this.cgst,
//     required this.igst,
//     required this.netAmount,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'itemName': itemName,
//       'qty': qty,
//       'rate': rate,
//       'unit': unit,
//       'amount': amount,
//       'tax': tax,
//       'sgst': sgst,
//       'cgst': cgst,
//       'igst': igst,
//       'netAmount': netAmount,
//     };
//   }

//   factory Entry.fromJson(Map<String, dynamic> json) {
//     return Entry(
//       itemName: json['itemName'],
//       qty: json['qty'],
//       rate: json['rate'],
//       unit: json['unit'],
//       amount: json['amount'],
//       tax: json['tax'],
//       sgst: json['sgst'],
//       cgst: json['cgst'],
//       igst: json['igst'],
//       netAmount: json['netAmount'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'itemName': itemName,
//       'qty': qty,
//       'rate': rate,
//       'unit': unit,
//       'amount': amount,
//       'tax': tax,
//       'sgst': sgst,
//       'cgst': cgst,
//       'igst': igst,
//       'netAmount': netAmount,
//     };
//   }
// }

// class Sundry2 {
//   final String sundryName;
//   final double amount;

//   Sundry2({
//     required this.sundryName,
//     required this.amount,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'sundryName': sundryName,
//       'amount': amount,
//     };
//   }

//   factory Sundry2.fromJson(Map<String, dynamic> json) {
//     return Sundry2(
//       sundryName: json['sundryName'],
//       amount: json['amount'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'sundryName': sundryName,
//       'amount': amount,
//     };
//   }
// }

// class Dispatch {
//   final String transAgency;
//   final String docketNo;
//   final String vehicleNo;
//   final String fromStation;
//   final String fromDistrict;
//   final String transMode;
//   final String parcel;
//   final String freight;
//   final String kms;
//   final String toState;
//   final String ewayBill;
//   final String billingAddress;
//   final String shippedTo;
//   final String shippingAddress;
//   final String phoneNo;
//   final String gstNo;
//   final String remarks;
//   final String licenceNo;
//   final String issueState;
//   final String name;
//   final String address;

//   Dispatch({
//     required this.transAgency,
//     required this.docketNo,
//     required this.vehicleNo,
//     required this.fromStation,
//     required this.fromDistrict,
//     required this.transMode,
//     required this.parcel,
//     required this.freight,
//     required this.kms,
//     required this.toState,
//     required this.ewayBill,
//     required this.billingAddress,
//     required this.shippedTo,
//     required this.shippingAddress,
//     required this.phoneNo,
//     required this.gstNo,
//     required this.remarks,
//     required this.licenceNo,
//     required this.issueState,
//     required this.name,
//     required this.address,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'transAgency': transAgency,
//       'docketNo': docketNo,
//       'vehicleNo': vehicleNo,
//       'fromStation': fromStation,
//       'fromDistrict': fromDistrict,
//       'transMode': transMode,
//       'parcel': parcel,
//       'freight': freight,
//       'kms': kms,
//       'toState': toState,
//       'ewayBill': ewayBill,
//       'billingAddress': billingAddress,
//       'shippedTo': shippedTo,
//       'shippingAddress': shippingAddress,
//       'phoneNo': phoneNo,
//       'gstNo': gstNo,
//       'remarks': remarks,
//       'licenceNo': licenceNo,
//       'issueState': issueState,
//       'name': name,
//       'address': address,
//     };
//   }

//   factory Dispatch.fromMap(Map<String, dynamic> map) {
//     return Dispatch(
//       transAgency: map['transAgency'] as String,
//       docketNo: map['docketNo'] as String,
//       vehicleNo: map['vehicleNo'] as String,
//       fromStation: map['fromStation'] as String,
//       fromDistrict: map['fromDistrict'] as String,
//       transMode: map['transMode'] as String,
//       parcel: map['parcel'] as String,
//       freight: map['freight'] as String,
//       kms: map['kms'] as String,
//       toState: map['toState'] as String,
//       ewayBill: map['ewayBill'] as String,
//       billingAddress: map['billingAddress'] as String,
//       shippedTo: map['shippedTo'] as String,
//       shippingAddress: map['shippingAddress'] as String,
//       phoneNo: map['phoneNo'] as String,
//       gstNo: map['gstNo'] as String,
//       remarks: map['remarks'] as String,
//       licenceNo: map['licenceNo'] as String,
//       issueState: map['issueState'] as String,
//       name: map['name'] as String,
//       address: map['address'] as String,
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Dispatch.fromJson(String source) =>
//       Dispatch.fromMap(json.decode(source) as Map<String, dynamic>);
// }
