//pkg
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kasbengkel/ui/settings.dart';
//ui
import 'ui/transactions.dart';
import 'ui/products.dart';
import 'ui/employees.dart';
import 'ui/general_settings.dart';
import 'ui/main_bottom_navigation.dart';
//model
import 'model/transaction.dart';
import 'model/employee.dart';
import 'model/product.dart';
import 'model/user.dart';
// import 'api/gsheet_api.dart';
// import 'ui/general_settings.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(EmployeeAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Employee>('employees');
  await Hive.openBox<Product>('products');
  await Hive.openBox<User>('users');
  await Hive.openBox<Transaction>('transactions');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: SettingsPage(),
      // home: EmployeesPage(),
      home: TransactionsPage(),
      // home: ProductsPage(isOpenLookup: false,),
      // home: MyHomePage(title: 'Kas Bengkel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNavigationBar(0),
    );
  }
}
