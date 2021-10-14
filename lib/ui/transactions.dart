//pkg
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//ui
import 'main_bottom_navigation.dart';
import 'products.dart';
//model
import '/model/transaction.dart';
import '/model/employee.dart';

class TransactionsPage extends StatefulWidget{
  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>{
  late Box<Transaction> transactionBox;
  String query = "";

  @override
  void initState(){
    super.initState();
    transactionBox = Hive.box<Transaction>('transactions');
  }

  @override
  void dispose(){
    Hive.box('transactions').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaksi"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Cari No Polisi',
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {

                    },
                  ),
                ),
                const SizedBox(width: 10,),
                buildAddButton(context),
              ],
            ),
            const SizedBox(height: 25,),
            buildListView(context),
            
          ],
        ),
      ),

      bottomNavigationBar: MainBottomNavigationBar(1),
    );
  }

  Widget buildListView(BuildContext context){
    return Expanded(
      child: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: transactionBox.listenable(),
          builder: (context, Box<Transaction> data, _){
            List<Transaction> transactions;

            if(query == ""){
              transactions = data.values
                          .toList()
                          .cast<Transaction>();
            }else{
              transactions = data.values
                          .where((e) => e.vehiclePlateNumber.toLowerCase().contains(query))
                          .toList()
                          .cast<Transaction>();
            }

            if(transactions.length > 0){
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return buildTransactionListTile(context, transactions[index], transactions[index].key);
                },
                itemCount: transactions.length,
              );
            } else {
              return Column(
                children: [
                  Text("Belum ada transaksi"),
                  const SizedBox(height: 10,),
                  TextButton(
                    child: Text("+ Transaksi"),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 15.0), 
                    ),
                    onPressed: () => onTapped(context, 'Tambah Baru', Transaction(), null)
                  ),
                ],
              );
            } 
            // return const CircularProgressIndicator(); 
          },
        ),
      ),
    );
  }
  
  Widget buildTransactionListTile(BuildContext context, Transaction transactionData, int? dataKey){
    return ListTile(
      title: Text(transactionData.vehiclePlateNumber),
      subtitle: Text(transactionData.vehicleOwnerName),
      onTap: () => onTapped(context, "Ubah ${transactionData.vehiclePlateNumber}", transactionData, dataKey)
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
    onPressed: () => onTapped(context, 'Tambah Baru', Transaction(), null)
  );

  void onTapped (BuildContext context, String title, Transaction transactionData, int? dataKey){
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => TransactionDetailScreen(title: title, transactionData: transactionData)
      )
    );
  }
}

class TransactionDetailScreen extends StatefulWidget{
  TransactionDetailScreen({Key? key, required this.title, required this.transactionData}) : super(key: key);
  final String title;
  Transaction transactionData;
  double qty = 0;

  @override
  _TransactionDetailScreenState createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen>{

  final formKey = GlobalKey<FormBuilderState>();
  Transaction savedTransaction = Transaction(totalTransaction: 0);
  bool isLoading = false;
  bool isSaved = false;

  late Box<Employee> employeeBox;

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
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'vehiclePlateNumber',
                        initialValue: widget.transactionData.vehiclePlateNumber,
                        decoration: InputDecoration(
                          labelText: 'Nomor Polisi',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
                        ],
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        onSaved: (value) => setState(() => savedTransaction.vehiclePlateNumber = value!),
                      ),
                      const SizedBox(height: 10,),
                      FormBuilderTextField(
                        name: 'vehicleOwnerName',
                        initialValue: widget.transactionData.vehicleOwnerName,
                        decoration: InputDecoration(
                          labelText: 'Nama Pemilik',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        onSaved: (value) => setState(() => savedTransaction.vehicleOwnerName = value!),
                      ),
                      const SizedBox(height: 10,),
                      FormBuilderTextField(
                        name: 'vehicleOwnerPhoneNumber',
                        initialValue: widget.transactionData.vehicleOwnerPhoneNumber,
                        decoration: InputDecoration(
                          labelText: 'Nomor Whatsapp Pemilik',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.numeric(context),
                        ]),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => setState(() => savedTransaction.vehicleOwnerPhoneNumber = value!),
                      ),
                      const SizedBox(height: 10,),
                      FormBuilderDropdown(
                        name: 'mechanicName',
                        hint: Text('Pilih Mekanik'),
                        items: employeeBox.values.map((Employee e) { 
                            return DropdownMenuItem(
                              value: e.name, 
                              child: Text(e.name!)
                            );
                          }
                        ).toList(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        onSaved: (value) => setState(() => savedTransaction.mechanicName = value.toString()),
                      ),
                      const SizedBox(height: 15,),
                      Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Total : ${savedTransaction.totalTransaction.toString()}", style: TextStyle(fontSize: 20))
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                child: Text(
                                  "+ Tambah Barang/Jasa",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black87,
                                  ),
                                ),
                                onPressed: () async {
                                  final TransactionDetail selectedProduct = await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductsPage(isOpenLookup: true)
                                    )
                                  );

                                  setState(() {
                                    savedTransaction.transactionDetails.add(selectedProduct);
                                    print("tambah ${savedTransaction.transactionDetails[0].product.name}");                                    
                                  });
                                  // ScaffoldMessenger.of(context)
                                  // ..removeCurrentSnackBar()
                                  // ..showSnackBar(SnackBar(content: Text('${selectedProduct.product.name} berhasil ditambahkan')));


                                } 
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      ...buildTransactionDetailRows(context)
                    ]
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    if(widget.title != "Tambah Baru")...[
                      Expanded(
                        child: buildDeleteButton(context, savedTransaction)
                      ),
                      const SizedBox(width: 5,),
                    ],
                    Expanded(
                      child: buildSaveButton(context, savedTransaction),
                    ),
                  ]
                ),
              ),
            ],
          ),
        )
      ),
      bottomNavigationBar: MainBottomNavigationBar(1),
    );
  }

  Widget buildSaveButton(BuildContext context, Transaction transactionData) => ElevatedButton.icon(
    label: Text("Simpan"),
    icon: Icon(Icons.save),
    // style: ElevatedButton.styleFrom(
    //   minimumSize: Size(double.infinity, 50),
    // ),
    onPressed: () {
      setState(() => {isLoading = true}); 
      final isValid = formKey.currentState!.validate();

      if(isValid){
        formKey.currentState!.save();
        debugPrint("old: ${transactionData.mechanicName.toString()}");

        Future.delayed(Duration(milliseconds: 500), (){
          setState(() => {isSaved = true}); 
          // Navigator.pop(context, true);
        });

      }
    }
  );

  Widget buildDeleteButton(BuildContext context, Transaction transactionData) => ElevatedButton.icon(
    label: Text("Hapus"),
    icon: Icon(Icons.delete),
    style: ElevatedButton.styleFrom(
      primary: Colors.red,
      // minimumSize: Size(double.infinity, 50),
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
              onPressed: (){}, // to do untuk bikin delete data func
            ),
          ],
        )
      );
    }
  );

  List<Widget> buildTransactionDetailRows(BuildContext context){
    List<Widget> tmp = [];
    
    for(int i = 0; i < savedTransaction.transactionDetails.length; i++){
      TransactionDetail e = savedTransaction.transactionDetails[i];

      tmp.add(
        Row(
          children:[
            Flexible(
              child: ListTile(
                title: Text(e.product.name!),
                subtitle: Text(e.qty.toString()),
              ),
            ),
            SizedBox(
              width: 150,
              child: Text(e.subtotal.toString()),
            ),
            ElevatedButton(
              child: Icon(
                Icons.delete,
                color: Colors.black54,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              onPressed: (){
                setState(() {
                  savedTransaction.transactionDetails.removeAt(i);
                });
              },
            ),
          ]
        )
      );
    }

    return tmp; 
  }

}