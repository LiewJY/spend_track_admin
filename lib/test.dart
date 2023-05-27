import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
//var
  bool sort = true;
  List<Data>? filterData;

  //column sorting function
  onsortColum(int columnIndex, bool ascending) {
    // if (columnIndex == 0) {
    //   if (ascending) {
    //     filterData!.sort((a, b) => a.name!.compareTo(b.name!));
    //   } else {
    //     filterData!.sort((a, b) => b.name!.compareTo(a.name!));
    //   }
    // }
    if (columnIndex == 2) {
      if (ascending) {
        filterData!.sort((a, b) => a.Age!.compareTo(b.Age!));
      } else {
        filterData!.sort((a, b) => b.Age!.compareTo(a.Age!));
      }
    }
  }

  //set the data when runned
  @override
  void initState() {
    filterData = myData;
    super.initState();
  }

//searching txt controller
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      sortColumnIndex: 0,
      sortAscending: sort,
      header: Container(
        child: TextField(
          controller: controller,
          onChanged: (value) {
            setState(() {
              myData = filterData!
                  .where((element) => element.name!.contains(value))
                  .toList();
            });
          },
        ),
      ),
      columns: [
        DataColumn(
            label: const Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });

              onsortColum(columnIndex, ascending);
            }),
        DataColumn(
            label: Text(
              "Phone",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });

              onsortColum(columnIndex, ascending);
            }),
         DataColumn(
          label: Text(
            "Age",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
              });

              onsortColum(columnIndex, ascending);
            }),      ],
      source: RowSource(myData: myData, count: myData.length),
    );
  }
}

//todo data mapped
class RowSource extends DataTableSource {
  var myData;
  final count;
  RowSource({
    required this.myData,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index]);
    } else
      return null;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  return DataRow(
    cells: [
      DataCell(Text(data.name ?? "Name")),
      DataCell(Text(data.phone.toString())),
      DataCell(Text(data.Age.toString())),
    ],
  );
}

//fixme test data
class Data {
  String? name;
  int? phone;
  int? Age;

  Data({required this.name, required this.phone, required this.Age});
}

List<Data> myData = [
  Data(name: "Khaliq", phone: 09876543, Age: 28),
  Data(name: "David", phone: 6464646, Age: 30),
  Data(name: "Kamal", phone: 8888, Age: 32),
  Data(name: "Ali", phone: 3333333, Age: 33),
  Data(name: "Muzal", phone: 987654556, Age: 23),
  Data(name: "Taimu", phone: 46464664, Age: 24),
  Data(name: "Mehdi", phone: 5353535, Age: 36),
  Data(name: "Rex", phone: 244242, Age: 38),
  Data(name: "Alex", phone: 323232323, Age: 29),
];
