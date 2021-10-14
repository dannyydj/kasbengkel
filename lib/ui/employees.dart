//pkg
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//ui
import 'main_bottom_navigation.dart';
//model
import '/model/employee.dart';

class EmployeesPage extends StatefulWidget{
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Mekanik"),
      ),
      body: EmployeeListScreen(),
      bottomNavigationBar: MainBottomNavigationBar(2),
    );
  }
}

class EmployeeListScreen extends StatefulWidget{
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen>{
  late Box<Employee> employeeBox;
  String query = "";

  @override
  void initState(){
    super.initState();
    employeeBox = Hive.box<Employee>('employees');
  }

  @override
  void dispose(){
    Hive.box('employees').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Cari Mekanik',
                  ),
                  onSubmitted: (value){
                    setState(() {
                      query = value;
                    });
                  },
                ),
              ),
              // const SizedBox(width: 10,),
              // buildSearchButton(context), //no need 
              const SizedBox(width: 10,),
              buildAddButton(context),
            ],
          ),
          const SizedBox(height: 25,),
          buildListView(context),
        ],
      ),
    );
  }

  Widget buildListView(BuildContext context){
    return Expanded(
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: employeeBox.listenable(),
          builder: (context, Box<Employee> data, _){
            List<Employee> employees;

            if(query == ""){
              employees = data.values
                          .toList()
                          .cast<Employee>();
            }else{
              employees = data.values
                          .where((e) => e.name!.toLowerCase().contains(query))
                          .toList()
                          .cast<Employee>();
            }
            // print(employees[0].key);
            // print(keys);

            if(employees.length > 0){
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return buildEmployeeListTile(context, employees[index], employees[index].key);
                },
                itemCount: employees.length,
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Text('Data kosong')
              );
            } 
            // return const CircularProgressIndicator(); 
          },
        ),
      ),
    );
  }

  Widget buildEmployeeListTile(BuildContext context, Employee employeeData, int? dataKey){
    return ListTile(
      title: Text(employeeData.name!),
      subtitle: Text(employeeData.phoneNumber!),
      onTap: () => onTapped(context, "Ubah ${employeeData.name!}", employeeData, dataKey)
    );
  }

  ButtonStyle buttonStyle = TextButton.styleFrom(
    primary: Colors.white,
    backgroundColor: Colors.blue,
    padding: const EdgeInsets.symmetric(horizontal: 15.0), 
  );

  Widget buildSearchButton(BuildContext context) => TextButton(
    child: Text("Cari"),
    style: buttonStyle,
    // icon: Icon(Icons.search),
    // style: ElevatedButton.styleFrom(
    //   minimumSize: Size(double.infinity, 50),
    // ),
    onPressed: () {}
  );

  Widget buildAddButton(BuildContext context) => TextButton(
    child: Text("+ Baru"),
    style: buttonStyle,
    // icon: Icon(Icons.add),
    // style: ElevatedButton.styleFrom(
    //   minimumSize: Size(double.infinity, 50),
    // ),
    onPressed: () => onTapped(context, 'Tambah Baru', Employee(), null)
  );

  void onTapped (BuildContext context, String title, Employee employeeData, int? dataKey){
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => EmployeeDetailScreen(title: title, employeeData: employeeData, dataKey: dataKey)
      )
    );
  }

}

class EmployeeDetailScreen extends StatefulWidget{
  EmployeeDetailScreen({Key? key, required this.title, required this.employeeData, this.dataKey}) : super(key: key);
  final String title;
  final int? dataKey;
  Employee employeeData;

  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen>{

  final formKey = GlobalKey<FormBuilderState>();
  Employee savedEmployee = new Employee();
  bool isLoading = false;
  bool isSaved = false;

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                name: 'EmployeeName',
                initialValue: widget.employeeData.name,
                decoration: InputDecoration(
                  labelText: 'Nama Mekanik',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                onSaved: (value) => setState(() => savedEmployee.name = value!),
              ),
              const SizedBox(height: 10,),
              FormBuilderTextField(
                name: 'EmployeePhoneNumber',
                initialValue: widget.employeeData.phoneNumber,
                decoration: InputDecoration(
                  labelText: 'Nomor Whatsapp',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.numeric(context),
                ]),
                keyboardType: TextInputType.number,
                onSaved: (value) => setState(() => savedEmployee.phoneNumber = value!),
              ),
              const SizedBox(height: 40,),
              buildSaveButton(context, savedEmployee, widget.dataKey),
              if(widget.title != "Tambah Baru")...[
                const SizedBox(height: 10,),
                buildDeleteButton(context, widget.dataKey!)
              ]
            ],
          ),
        )
      ),
      bottomNavigationBar: MainBottomNavigationBar(2),
    );
  }

  Widget buildSaveButton(BuildContext context, Employee savedData, int? key) => ElevatedButton.icon(
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

        if(widget.title == 'Tambah Baru')
          await addEmployee(savedData);
        else
          await editEmployee(key!, savedData);

        Future.delayed(Duration(milliseconds: 500), (){
          Navigator.pop(context, true);
        });

      }
    }
  );

  Widget buildDeleteButton(BuildContext context, int key) => ElevatedButton.icon(
    label: Text("Hapus"),
    icon: Icon(Icons.delete),
    style: ElevatedButton.styleFrom(
      primary: Colors.red,
      minimumSize: Size(double.infinity, 50),
    ),
    onPressed: () { // munculin confirm dialog
      showDialog(
        context: context, 
        builder: (_) => AlertDialog(
          title: Text("Apakah anda yakin menghapus data ini?"),
          actions: [
            TextButton(
              child: Text("Tidak"), //klo gak ya back ke screen awal
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("Ya"),
              onPressed: () async {
                Navigator.pop(context, true); // close alertdialog 
                setState(() => {isLoading = true});
                await deleteEmployee(key);

                Future.delayed(Duration(milliseconds: 500), (){
                  Navigator.pop(context, true); // balik ke list
                });

              }, // to do untuk bikin delete data func
            ),
          ],
        )
      );
    }
  );

  Future addEmployee (Employee employeeData) async {
    final savedData = Employee()
      ..name = employeeData.name
      ..phoneNumber = employeeData.phoneNumber
      ..createdAt = DateTime.now();

    final box = Hive.box<Employee>('employees');
    box.add(savedData);
  }

  Future editEmployee (int key, Employee employeeData) async {
    // print("edit ${key}");

    final box = Hive.box<Employee>('employees');
    box.put(key, employeeData);
  }

  Future deleteEmployee (int key) async {
    print("delete ${key}");

    final box = Hive.box<Employee>('employees');
    box.delete(key);
  }

}