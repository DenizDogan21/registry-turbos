import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../BackEnd/Models/workOrderForm_model.dart';
import '../../BackEnd/Repositories/workOrderForm_repo.dart';
import '../widgets/common.dart';
import 'detailsWOF.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';

class OutputWOFPage extends StatefulWidget {
  const OutputWOFPage({Key? key}) : super(key: key);

  @override
  State<OutputWOFPage> createState() => _OutputWOFPageState();
}

class _OutputWOFPageState extends State<OutputWOFPage> {
  final _workOrderFormRepo = WorkOrderFormRepo.instance;
  late List<WorkOrderFormModel> _formsWOF;
  late List<WorkOrderFormModel> _filteredFormsWOF;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formsWOF = [];
    _filteredFormsWOF = [];
    _getWorkOrderForms();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterForms(_searchController.text);
  }

  void _getWorkOrderForms() async {
    try {
      final formsWOF = await _workOrderFormRepo.getWorkOrderForms();
      formsWOF.sort((a, b) => b.tarihWOF.compareTo(a.tarihWOF));
      setState(() {
        _formsWOF = formsWOF;
        _filteredFormsWOF = formsWOF;
      });
    } catch (error) {
      print('Error: $error');
    }
  }


  void _filterForms(String keyword) {
    Future.delayed(Duration.zero, () {
      setState(() {
        if (keyword.isNotEmpty) {
          _filteredFormsWOF = _formsWOF.where((form) {
            final tasimaUcretiString = form.tasimaUcreti.toString().toLowerCase();
            final keywordLower = keyword.toLowerCase();
            return form.turboNo.toLowerCase().contains(keywordLower) ||
                form.aracBilgileri.toLowerCase().contains(keywordLower) ||
                form.musteriAdi.toLowerCase().contains(keywordLower) ||
                form.musteriSikayetleri.toLowerCase().contains(keywordLower) ||
                form.onTespit.toLowerCase().contains(keywordLower) ||
                form.turboyuGetiren.toLowerCase().contains(keywordLower) ||
                tasimaUcretiString.contains(keywordLower) ||
                form.teslimAdresi.toLowerCase().contains(keywordLower);
          }).toList();
        } else {
          _filteredFormsWOF = _formsWOF;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ara...",
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          onChanged: (value) => _filterForms(value),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              _searchController.clear();
            },
          ),
        ],
      ),
      bottomNavigationBar: bottomNav(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              Colors.grey.shade800,
              Colors.black87,
            ],
          ),
        ),
        child: _filteredFormsWOF.isEmpty
            ? Center(child: Text('No Records Found', style: TextStyle(color: Colors.white)))
            : ListView.separated(
          itemCount: _filteredFormsWOF.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade600),
          itemBuilder: (context, index) {
            final form = _filteredFormsWOF[index];
            return ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.cyanAccent,
              child: ListTile(
                leading: Icon(Icons.build_circle_outlined),
                title: Text('${formatDate(form.tarihWOF)}', style: CustomTextStyle.outputTitleTextStyle),
                subtitle: Text('Turbo No: ${form.turboNo}', style: CustomTextStyle.outputListTextStyle),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsWOFPage(formWOF: form),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
  }
}

