//pkg
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//ui
import 'main_bottom_navigation.dart';
//model
import '/model/user.dart';

class GeneralSettingsPage extends StatefulWidget{
  @override
  _GeneralSettingsPageState createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage>{
  
  final formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  bool isSaved = false;
  late Box<User> userBox;
  late User userProfile = (userBox.isEmpty) ? User() : userBox.values.toList().cast<User>()[0];

  @override
  void initState(){
    super.initState();
    userBox = Hive.box<User>('users');
  }

  @override
  void dispose(){
    Hive.box('users').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan Umum"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: 
        isLoading ? 
        Align(alignment: Alignment.center,child: CircularProgressIndicator()):
        FormBuilder(
          key: formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'phoneNumber',
                enabled: false,
                initialValue: userProfile.workshopPhoneNumber,
                decoration: InputDecoration(
                  labelText: 'Nomor Whatsapp',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.numeric(context),
                ]),
                keyboardType: TextInputType.number,
                onSaved: (value) => setState(() => userProfile.workshopPhoneNumber = value!),
              ),
              const SizedBox(height: 10,),
              FormBuilderTextField(
                name: 'name',
                initialValue: userProfile.workshopName,
                decoration: InputDecoration(
                  labelText: 'Nama Bengkel',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                onSaved: (value) => setState(() => userProfile.workshopName = value!),
              ),
              const SizedBox(height: 10,),
              FormBuilderDropdown(
                name: 'type',
                initialValue: (userProfile.workshopType == "") ? "Mobil" : userProfile.workshopType,
                hint: Text('Pilih Jenis Bengkel'),
                decoration: InputDecoration(
                  labelText: 'Jenis Bengkel',
                ),
                items: [
                  DropdownMenuItem(
                    value: "Motor", 
                    child: Text("Motor")
                  ),
                  DropdownMenuItem(
                    value: "Mobil", 
                    child: Text("Mobil")
                  ),
                  DropdownMenuItem(
                    value: "Sepeda", 
                    child: Text("Sepeda")
                  ),
                  DropdownMenuItem(
                    value: "Lainnya", 
                    child: Text("Lainnya")
                  ),
                ],
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                onSaved: (value) => setState(() => userProfile.workshopType = value.toString()),
              ),
              const SizedBox(height: 10,),
              FormBuilderTextField(
                name: 'address',
                initialValue: userProfile.workshopAddress,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                onSaved: (value) => setState(() => userProfile.workshopAddress = value!),
              ),
              const SizedBox(height: 40,),
              buildSaveButton(context, userProfile)
            ],
          ),
        )
      ),
      bottomNavigationBar: MainBottomNavigationBar(2),
    );
  }

  Widget buildSaveButton(BuildContext context, User userProfile) => ElevatedButton.icon(
    label: Text("Simpan"),
    icon: Icon(Icons.save),
    style: ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, 50),
    ),
    onPressed: () async {
      final isValid = formKey.currentState!.validate();

      if(isValid){
        formKey.currentState!.save();
        setState(() => {isLoading = true}); 
        await saveUserProfile(userProfile);
        // debugPrint("old: ${userProfile.toString()}");

        Future.delayed(Duration(milliseconds: 500), (){
          Navigator.pop(context, true); //balik ke setting
        });

      }
    }
  );

  Future saveUserProfile (User userProfile) async {
    // print("edit ${key}");

    final box = Hive.box<User>('users');
    box.put(0, userProfile); //selalu di record pertama

  }

}
