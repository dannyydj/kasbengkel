import 'package:flutter/material.dart';
import 'main_bottom_navigation.dart';
import 'employees.dart';
import 'products.dart';
import 'general_settings.dart';

class SettingsPage extends StatefulWidget{
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>{
  
  final pages = [
    EmployeesPage(),
    ProductsPage(),
    GeneralSettingsPage(),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan Umum"),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 10,),
          ListTile(
            title: Text('Daftar Mekanik'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => onTapped(context, 0),
          ),
          const SizedBox(height: 10,),
          ListTile(
            title: Text('Daftar Barang & Jasa'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => onTapped(context, 1),
          ),
          const SizedBox(height: 10,),
          ListTile(
            title: Text('Pengaturan Umum'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () => onTapped(context, 2),
          ),
        ] 
      ),
      bottomNavigationBar: MainBottomNavigationBar(2),
    );
  }

  void onTapped (BuildContext context, int index){
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => pages[index])
    );
  }
}