import 'package:editable/editable.dart';
import 'package:flutter/material.dart';

class EditableTables extends StatefulWidget {
  const EditableTables({super.key});

  @override
  State<EditableTables> createState() => _EditableTablesState();
}

class _EditableTablesState extends State<EditableTables> {
  // Sample data
  List<Map<String, String>> rows = [
    {
      "name": 'James Peter',
      "date": '01/08/2007',
      "month": 'March',
      "status": 'beginner'
    },
    {
      "name": 'Okon Etim',
      "date": '09/07/1889',
      "month": 'January',
      "status": 'completed'
    },
    {
      "name": 'Samuel Peter',
      "date": '11/11/2002',
      "month": 'April',
      "status": 'intermediate'
    },
    {
      "name": 'Udoh Ekong',
      "date": '06/3/2020',
      "month": 'July',
      "status": 'beginner'
    },
    {
      "name": 'Essien Ikpa',
      "date": '12/6/1996',
      "month": 'June',
      "status": 'completed'
    },
  ];

  // Headers or Columns
  List<Map<String, dynamic>> headers = [
    {"title": 'Name', 'index': 1, 'key': 'name'},
    {"title": 'Date', 'index': 2, 'key': 'date'},
    {"title": 'Month', 'index': 3, 'key': 'month'},
    {"title": 'Status', 'index': 4, 'key': 'status'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Editable(
          columns: headers,
          rows: rows,
          showCreateButton: true,
          tdStyle: const TextStyle(fontSize: 20),
          showSaveIcon: true,
          borderColor: Colors.grey.shade300,
          onSubmitted: (value) {
            print(value);
          },
          onRowSaved: (value) {
            //added line
            print(value); //prints to console
          },
        ),
      ),
    );
  }
}
