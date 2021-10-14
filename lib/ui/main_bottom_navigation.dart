import 'package:flutter/material.dart';
import 'transactions.dart';
import 'settings.dart';

class MainBottomNavigationBar extends StatefulWidget{

  final int navItemIndex;
  MainBottomNavigationBar(this.navItemIndex);

  @override
  _MainBottomNavigationBarState createState() => _MainBottomNavigationBarState(navItemIndex);
}

class _MainBottomNavigationBarState extends State<MainBottomNavigationBar>{

  int navItemIndex = 0;
  _MainBottomNavigationBarState(this.navItemIndex);

  final pages = [
    SettingsPage(),
    TransactionsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      currentIndex: navItemIndex,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Halaman utama"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: "Transaksi"
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "Pengaturan",
        ),
      ],
      onTap: (index){
        _onTapped(context, index);
      },
    );
  }

  void _onTapped(BuildContext context, int index){
    // Navigator.of(context).pop();

    // klo klik home maka pop sampai balik ke page 1
    if(index == 0){
      Navigator.of(context).popUntil((route) => route.isFirst);
    }else{
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => pages[index])
      );
    }

    // setState(() {
    //   navItemIndex = index;      
    // });

  }
}
