import 'package:flutter/material.dart';

class PaginatedTable extends StatefulWidget {
  const PaginatedTable(
      {super.key,
      required this.title,
      required this.headers,
      required this.dataSource});

  final String title;
  final List<DataColumn> headers;
  final DataTableSource dataSource;

  @override
  State<PaginatedTable> createState() => _PaginatedTableState();
}

class _PaginatedTableState extends State<PaginatedTable> {
  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      rowsPerPage: 2,
      header: Text(widget.title),
      columns: widget.headers,
      source: widget.dataSource,
    );
  }
}
