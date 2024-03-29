import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:turboapp/frontEnd/utils/customTextField.dart';

import '../../../backEnd/models/accountingForm_model.dart';
import '../../../backEnd/repositories/accountingForm_repo.dart';
import '../../widgets/helperMethodsAccounting.dart';
import '../../widgets/helperMethodsDetails.dart';
import 'package:turboapp/frontEnd/accountingPages/accountingAddShow.dart';



class AccountingRatingPage extends StatefulWidget {

  final AccountingFormModel formAF;
  AccountingRatingPage({required this.formAF});

  @override
  _AccountingRatingPageState createState() => _AccountingRatingPageState();
}

class _AccountingRatingPageState extends State<AccountingRatingPage> {
  final _accountingFormRepo = AccountingFormRepo.instance;

  TextEditingController _controllerTamirUcreti = TextEditingController();
  TextEditingController _controllerOdemeSekli = TextEditingController();
  TextEditingController _controllerTaksitSayisi = TextEditingController();
  TextEditingController _controllerMuhasebeNotlari = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values from widget.formIPF
    _controllerTamirUcreti.text = widget.formAF.tamirUcreti.toString();
    _controllerOdemeSekli.text = widget.formAF.odemeSekli;
    _controllerTaksitSayisi.text = widget.formAF.taksitSayisi.toString();
    _controllerMuhasebeNotlari.text = widget.formAF.muhasebeNotlari;
  }

  Future<void> _saveChanges() async {
    if (widget.formAF.id == null) {
      Get.snackbar("Error", "Form numarası bulunamadı", backgroundColor: Colors.red);
      return;
    }

    double? parsedTamirUcreti = double.tryParse(_controllerTamirUcreti.text);
    int? parsedTaksitSayisi = int.tryParse(_controllerTaksitSayisi.text);

    if (parsedTamirUcreti == null) {
      Get.snackbar("Error", "Lütfen geçerli bir tamir ücreti girin", backgroundColor: Colors.red);
      return;
    }

    if (parsedTaksitSayisi == null) {
      Get.snackbar("Error", "Lütfen geçerli bir taksit sayısı girin", backgroundColor: Colors.red);
      return;
    }

    widget.formAF.tamirUcreti = parsedTamirUcreti;
    widget.formAF.odemeSekli = _controllerOdemeSekli.text;
    widget.formAF.taksitSayisi = parsedTaksitSayisi;
    widget.formAF.muhasebeNotlari = _controllerMuhasebeNotlari.text;

    await AccountingFormRepo.instance.updateAccountingForm(widget.formAF.id!, widget.formAF);

    // Navigate to the next page or go back
    // Logic to save changes to Firebase
    Navigator.of(context).pop(); // Close the dialog
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountingAddShowPage()));
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    return Scaffold(
      appBar: appBar(context, "Muhasebe"),
      bottomNavigationBar: bottomNavAcc(context),
      body: SafeArea(
          child: Stack(
              children: [
                background2(context),
                SingleChildScrollView(
                  padding: EdgeInsets.all(isTablet ? 64 : 16), child:
                Column(
                  children: [
                    CustomTextField(
                        controller: _controllerTamirUcreti,
                        label: 'Tamir Ücreti',
                        fieldSize: isTablet ? 30: 20,
                    ),CustomTextField(
                        controller: _controllerOdemeSekli,
                        label: 'Ödeme Şekli',
                        fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                      controller: _controllerTaksitSayisi,
                      label: 'Taksit Sayısı',
                      fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),CustomTextField(
                        controller: _controllerMuhasebeNotlari,
                        label: 'Muhasebe Notları',
                        fieldSize: isTablet ? 30: 20,
                      // ... other properties ...
                    ),
                    isTablet ? SizedBox(height: 60,):SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () => showSaveAlertDialog(context, _saveChanges, AccountingAddShowPage()),
                      child: Text(
                        'Kaydet',
                        style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.black), // Text styling
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyanAccent, // Button color
                        onPrimary: Colors.black, // Text color when button is pressed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal: isTablet ? 60: 30, vertical: isTablet ? 30: 15),
                      ),
                    ),
                    isTablet ? SizedBox(height: 60,):SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: () => _confirmDeleteForm(),
                      child: Text(
                        'Formu Sil',
                        style: TextStyle(fontSize: isTablet ? 32:16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, // Button color
                        onPrimary: Colors.white, // Text color when button is pressed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        padding: EdgeInsets.symmetric(horizontal: isTablet ? 60: 30, vertical: 15),
                      ),
                    ),

                  ],
                ),
                ),
              ])
      ),
    );
  }
  Future<void> _confirmDeleteForm() async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Form Silinecek"),
          content: Text("Formu silmek istediğinize emin misiniz?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel the delete operation
              },
              child: Text("Vazgeç"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm the delete operation
              },
              child: Text("Sil"),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Call the deleteWorkOrderForm method to delete the form
      try {
        await AccountingFormRepo.instance.deleteAccountingForm(widget.formAF.id!);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountingAddShowPage())); // Close the page after successful deletion
      } catch (e) {
        Get.snackbar("Form Silinemedi", "Failed to delete form: $e", backgroundColor: Colors.red);
      }
    }
  }
}
