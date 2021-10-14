//pkg
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
//ui
import 'main_bottom_navigation.dart';
//model
import '/model/product.dart';
import '/model/transaction.dart';

class ProductsPage extends StatefulWidget{
  bool isOpenLookup;
  ProductsPage({this.isOpenLookup = false});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>{
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Barang"),
      ),
      body: ProductListScreen(isLookupTile: widget.isOpenLookup),
      bottomNavigationBar: MainBottomNavigationBar(2),
    );
  }
}

class ProductListScreen extends StatefulWidget{
  final bool isLookupTile;
  ProductListScreen({required this.isLookupTile});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>{
  late Box<Product> productBox;
  String query = "";
  Map<String, int> qtyProduct = Map();

  @override
  void initState(){
    super.initState();
    productBox = Hive.box<Product>('products');
  }

  @override
  void dispose(){
    Hive.box('products').close();
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
                    labelText: 'Cari Barang',
                  ),
                  onSubmitted: (value){
                    setState(() {
                      query = value;
                    });
                  },
                ),
              ),
              // const SizedBox(width: 10,),
              // buildSearchButton(context),
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
          valueListenable: productBox.listenable(),
          builder: (context, Box<Product> data, _){
            List<Product> products; 

            if(query == ""){
              products = data.values
                          .toList()
                          .cast<Product>();
            }else{
              products = data.values
                          .where((e) => e.name!.toLowerCase().contains(query))
                          .toList()
                          .cast<Product>();
            }

            if(products.length > 0){
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if(widget.isLookupTile)
                    return buildProductLookupListTile(context, products[index], products[index].key, 0);
                  else
                    return buildProductListTile(context, products[index], products[index].key);
                },
                itemCount: products.length,
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

  Widget buildProductListTile(BuildContext context, Product productData, int dataKey){
    return ListTile(
      title: Text(productData.name!),
      subtitle: Text(productData.price.toString()),
      onTap: () => onTapped(context, "Ubah ${productData.name}", productData, dataKey)
    );
  }

  Widget buildProductLookupListTile(BuildContext context, Product selectedProduct, int dataKey, double defaultValue) {

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SpinBox(
            min: 1,
            max: 100,
            value: defaultValue,
            onChanged: (value) {
              setState(() {
                qtyProduct[selectedProduct.name!] = value.toInt();
              });
              print(qtyProduct[selectedProduct.name].toString());
            }
          ),
        ),
        Expanded(
          flex: 5,
          child: ListTile(
            title: Text(selectedProduct.name!),
            subtitle: Text(selectedProduct.price!.toString()),
            onTap: () => {
              print("${selectedProduct.name} ${qtyProduct[selectedProduct.name]}")
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: IconButton(
            icon: Icon(Icons.add_box),
            onPressed: (){
              final TransactionDetail returnedProduct = TransactionDetail(
                product: selectedProduct,
                qty: qtyProduct[selectedProduct.name]!,
                subtotal: selectedProduct.price! * qtyProduct[selectedProduct.name]!,
              ); 
              print(returnedProduct);
              Navigator.of(context).pop(returnedProduct);
            },
          )
        ),
      ],
    );
  }

  ButtonStyle buttonStyle = TextButton.styleFrom(
    primary: Colors.white,
    backgroundColor: Colors.blue,
    padding: const EdgeInsets.symmetric(horizontal: 15.0), 
  );

  Widget buildAddButton(BuildContext context) => TextButton(
    child: Text("+ Baru"),
    style: buttonStyle,
    // icon: Icon(Icons.add),
    // style: ElevatedButton.styleFrom(
    //   minimumSize: Size(double.infinity, 50),
    // ),
    onPressed: () => onTapped(context, 'Tambah Baru', Product(), 0)
  );

  void onTapped (BuildContext context, String title, Product productData, int key){
    Navigator.push(
      context, MaterialPageRoute(
        builder: (context) => ProductDetailScreen(title: title, productData: productData, dataKey: key,)
      )
    );
  }

}

class ProductDetailScreen extends StatefulWidget{
  ProductDetailScreen({Key? key, required this.title, required this.productData, this.dataKey}) : super(key: key);
  final String title;
  final int? dataKey;
  Product productData;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>{

  final formKey = GlobalKey<FormBuilderState>();
  Product savedProduct = new Product();
  bool isLoading = false;
  bool isSaved = false;

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'productName',
                initialValue: widget.productData.name,
                decoration: InputDecoration(
                  labelText: 'Nama Barang atau Jasa',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                ]),
                onSaved: (value) => setState(() => savedProduct.name = value!),
              ),
              const SizedBox(height: 10,),
              FormBuilderTextField(
                name: 'productPrice',
                initialValue: widget.productData.price == null? "" : widget.productData.price.toString(),
                decoration: InputDecoration(
                  labelText: 'Harga',
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.numeric(context),
                  FormBuilderValidators.min(context, 1),
                ]),
                keyboardType: TextInputType.number,
                onSaved: (value) => setState(() => savedProduct.price = int.tryParse(value!)),
              ),
              const SizedBox(height: 40,),
              buildSaveButton(context, savedProduct, widget.dataKey),
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

  Widget buildSaveButton(BuildContext context, Product savedData, int? key) => ElevatedButton.icon(
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
          await addProduct(savedData);
        else
          await editProduct(key!, savedData);

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
                await deleteProduct(key);

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

  Future addProduct (Product productData) async {
    final savedData = Product()
      ..name = productData.name
      ..price = productData.price
      ..createdAt = DateTime.now();

    final box = Hive.box<Product>('products');
    box.add(savedData);
  }

  Future editProduct (int key, Product productData) async {
    // print("edit ${key}");

    final box = Hive.box<Product>('products');
    box.put(key, productData);
  }

  Future deleteProduct (int key) async {
    print("delete ${key}");

    final box = Hive.box<Product>('products');
    box.delete(key);
  }

}

