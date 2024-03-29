import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../backEnd/models/inProgressForm_model.dart';
import '../../backEnd/repositories/inProgressForm_repo.dart';
import '../widgets/common.dart';
import 'package:turboapp/frontEnd/utils/customTextStyle.dart';
import 'package:turboapp/frontEnd/formPages/stepsIPF/detailsIPF1.dart';

class OutputIPFPage extends StatefulWidget {
  const OutputIPFPage({Key? key}) : super(key: key);

  @override
  State<OutputIPFPage> createState() => _OutputIPFPageState();
}

class _OutputIPFPageState extends State<OutputIPFPage> {
  final _inProgressFormRepo = InProgressFormRepo.instance;
  late List<InProgressFormModel> _formsIPF;
  late List<InProgressFormModel> _filteredFormsIPF;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formsIPF = [];
    _filteredFormsIPF = [];
    _getInProgressForms();
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

  void _getInProgressForms() async {
    try {
      final formsIPF = await _inProgressFormRepo.getInProgressForms();
      formsIPF.sort((a, b) => b.tarihIPF.compareTo(a.tarihIPF));
      setState(() {
        _formsIPF = formsIPF;
        _filteredFormsIPF = formsIPF;
      });
    } catch (error) {
      print('Error: $error');
    }
  }


  void _filterForms(String keyword) {
    Future.delayed(Duration.zero, () {
      setState(() {
        if (keyword.isNotEmpty) {
          _filteredFormsIPF = _formsIPF.where((form) {
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
                form.yapilanIslemler.toLowerCase().contains(keywordLower) ;
          }).toList();
        } else {
          _filteredFormsIPF = _formsIPF;
        }
      });
    });
  }


  bool _containsNullValue(InProgressFormModel form) {
    return
          form.tespitEdilen == "null" ||
          form.yapilanIslemler == "null" ||
          form.turboImageUrl== "null" ||
          form.balansImageUrl== "null" ||
          form.katricImageUrl== "null";
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
      bottomNavigationBar: bottomNav(context),
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
        child: _filteredFormsIPF.isEmpty
            ? Center(child: Text('Kayıt Bulunamadı', style: TextStyle(color: Colors.white, fontSize: isTablet ? 30 : 16),))
            : ListView.separated(
          itemCount: _filteredFormsIPF.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade600),
          itemBuilder: (context, index) {
            final form = _filteredFormsIPF[index];
            bool isFormIncomplete = _containsNullValue(form);
            Color tileColor = isFormIncomplete ? Colors.yellow : Colors.green;
            return ListTileTheme(
              textColor: Colors.white,
              iconColor: tileColor,
              child: ListTile(
                leading: Icon(Icons.build_circle_outlined),
                title: Text('${formatDate(form.tarihIPF)}', style: CustomTextStyle.outputTitleTextStyle.copyWith(
                  fontSize: isTablet ? 30 : 20,
                ),),
                subtitle: Text('Turbo No: ${form.turboNo} \nEge Turbo No: ${form.egeTurboNo}',style: CustomTextStyle.outputListTextStyle.copyWith(
                  fontSize: isTablet ? 20 : 15,
                ),),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsIPF1(formIPF: form),
                    ),
                  );
                },
                tileColor: tileColor,
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

