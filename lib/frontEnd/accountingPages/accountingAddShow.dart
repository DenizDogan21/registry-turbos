import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turboapp/frontEnd/accountingPages/accountingDetailsPages/accountingView.dart';
import '../../backEnd/repositories/accountingForm_repo.dart';
import '../../backEnd/models/accountingForm_model.dart';
import 'package:turboapp/frontEnd/widgets/helperMethodsAccounting.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';

class AccountingAddShowPage extends StatefulWidget {
  const AccountingAddShowPage({Key? key}) : super(key: key);

  @override
  State<AccountingAddShowPage> createState() => _AccountingAddShowPageState();
}

class _AccountingAddShowPageState extends State<AccountingAddShowPage> {
  final _accountingFormRepo = AccountingFormRepo.instance;
  late List<AccountingFormModel> _formsAF;
  late List<AccountingFormModel> _filteredFormsAF;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formsAF = [];
    _filteredFormsAF = [];
    _getAccountingForms();
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

  void _getAccountingForms() async {
    try {
      final formsAF = await _accountingFormRepo.getAccountingForms();
      formsAF.sort((a, b) => b.tarihWOF.compareTo(a.tarihWOF));
      setState(() {
        _formsAF = formsAF;
        _filteredFormsAF = formsAF;
      });
    } catch (error) {
      print('Error: $error');
    }
  }


  void _filterForms(String keyword) {
    Future.delayed(Duration.zero, () {
      setState(() {
        if (keyword.isNotEmpty) {
          _filteredFormsAF = _formsAF.where((form) {
            final keywordLower = keyword.toLowerCase();
            return form.turboNo.toLowerCase().contains(keywordLower) ||
                form.egeTurboNo.toString().toLowerCase().contains(keywordLower) ||
                form.aracBilgileri.toLowerCase().contains(keywordLower) ||
                form.aracPlaka.toLowerCase().contains(keywordLower) ||
                form.musteriAdi.toLowerCase().contains(keywordLower) ||
                form.musteriSikayetleri.toLowerCase().contains(keywordLower) ||
                form.onTespit.toLowerCase().contains(keywordLower) ||
                form.turboyuGetiren.toLowerCase().contains(keywordLower) ||
                form.teslimAdresi.toLowerCase().contains(keywordLower) ||
                form.yapilanIslemler.toLowerCase().contains(keywordLower)||
            form.tamirUcreti.toString().toLowerCase().contains(keywordLower) ||
                form.muhasebeNotlari.toLowerCase().contains(keywordLower) ||
                form.odemeSekli.toLowerCase().contains(keywordLower) ;
          }).toList();
        } else {
          _filteredFormsAF = _formsAF;
        }
      });
    });
  }

  bool _containsNullValue(AccountingFormModel form) {
    return
      form.tamirUcreti == -1 ||
          form.odemeSekli == "null" ||
          form.taksitSayisi == -1 ||
          form.muhasebeNotlari == "null";
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(isTablet ? 80 : 50), // Adjust height for tablets
        child: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: Padding(
            padding: isTablet ? EdgeInsets.only(top: 20): EdgeInsets.only(top: 5),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white, fontSize: isTablet ? 50 : 25), // Increase font size for tablets
              decoration: InputDecoration(
                hintText: "Ara...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
              ),
              onChanged: (value) => _filterForms(value),
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.cancel,size: isTablet ? 40 : 20,),
                onPressed: () {
                  _searchController.clear();
                },
                padding: isTablet ? EdgeInsets.only(top: 20,right: 20): EdgeInsets.only(top: 10,right: 10)
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNavAcc(context),
      body: Stack( children: [
        background(context),
        Container(
        child: _filteredFormsAF.isEmpty
            ? Center(child: Text('No Records Found', style: TextStyle(color: Colors.white, fontSize: isTablet ? 30 : 16),))
            : ListView.separated(
          itemCount: _filteredFormsAF.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade600),
          itemBuilder: (context, index) {
            final form = _filteredFormsAF[index];
            bool isFormIncomplete = _containsNullValue(form);
            Color tileColor = isFormIncomplete ? Colors.yellow : Colors.green;
            return ListTileTheme(
              textColor: Colors.white,
              iconColor: tileColor,
              child: ListTile(
                leading: Icon(Icons.build_circle_outlined),
                title: Text('${formatDate(form.tarihIPF)}', style: CustomTextStyle.outputTitleTextStyle.copyWith(fontSize: isTablet ? 30:20)),
                subtitle: Text('Turbo No: ${form.turboNo} \nEge Turbo No: ${form.egeTurboNo}', style: CustomTextStyle.outputListTextStyle.copyWith(
                  fontSize: isTablet ? 20 : 15,)),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AccountingViewPage(formAF: form),
                    ),
                  );
                },
                tileColor: tileColor,
              ),
            );
          },
        ),
      ),]),
    );
  }
  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
  }
}