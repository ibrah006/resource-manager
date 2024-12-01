import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resource_manager/data_provider.dart';
import 'package:resource_manager/entry.dart';
import 'package:resource_manager/item.dart';
import 'package:resource_manager/search_field.dart';
import 'package:uuid/uuid.dart';

class AddEntryScreen extends StatefulWidget {


  const AddEntryScreen({Key? key}) : super(key: key);

  static InputDecoration inputDecoration(String hintText) => InputDecoration(
    filled: true,
    fillColor: const Color(0xFF222244),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(width: 1, color: Colors.red.shade600),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white54),
    border: InputBorder.none,
  );

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {

  late final List<Item> items;

  bool isSell = false;

  String category = "";

  final nameController = TextEditingController(), amountController = TextEditingController(), notesController = TextEditingController(), quantityController = TextEditingController(text: "0");

  bool nameValidate = false, amountValidate = false, quantityValidate = false;

  final FocusNode quantityFocusNode = FocusNode();

  late Entry? inputEntry;

  void updateQuantityState() {
    int quantityAvailable = 0;
    try {
    quantityAvailable = items.firstWhere((item) {
      return item.name.toLowerCase() == nameController.text.toLowerCase();
    }).netQuantity();
    } catch(e) {}

    if (int.parse(quantityController.text.isNotEmpty? quantityController.text : "0") > quantityAvailable) {
    quantityValidate = true;
    } else {
    quantityValidate = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    try {
      inputEntry;
    } catch(e) {
      inputEntry = ModalRoute.of(context)?.settings.arguments as Entry?;
      if (inputEntry != null) {
        nameController.text = inputEntry!.name;
        amountController.text = inputEntry!.price.toStringAsFixed(3);
        isSell = inputEntry!.isSell;
        //TODO initlaize the category from the input passed in as well

        setState(() {});
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          "Add Entry",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Entry Type Toggle (Income or Spending)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        isSell = false;
                        updateQuantityState();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: !isSell? Color(0xFF222244) : null,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Spending",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        isSell = true;

                        updateQuantityState();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSell? Color(0xFF222244) : null, 
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Sell",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 10),

                    // Name Input Field
                    const Text(
                      "Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SearchField(
                      controller: nameController,
                      items: items,
                      isSell: isSell,
                      onSelected: (selectedName) {
                        if (!isSell) return;

                        int quantityAvailable = 0;
                        try {
                          quantityAvailable = items.firstWhere((item) {
                            return item.name.toLowerCase() == selectedName.toLowerCase();
                          }).netQuantity();
                        } catch(e) {}

                        if (int.parse(quantityController.text.isNotEmpty? quantityController.text : "0") > quantityAvailable) {
                          quantityValidate = true;
                        } else {
                          quantityValidate = false;
                        }
                        setState(() {});
                      },
                      // AddEntryScreen.inputDecoration("Enter name").copyWith(errorText: nameValidate? "Field can't be empty" : null),
                    ),
                    // TextField(
                    //   controller: nameController,
                    //   style: TextStyle(color: Colors.white),
                    //   decoration: AddEntryScreen.inputDecoration("Enter name").copyWith(errorText: nameValidate? "Field can't be empty" : null)
                    // ),
                    const SizedBox(height: 20),

                    // Quantity input field
                    const Text(
                      "Quantity",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      focusNode: quantityFocusNode,
                      controller: quantityController,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      onChanged: (newValue) {
                        if (!isSell) return;

                        int quantityAvailable = 0;
                        try {
                          quantityAvailable = items.firstWhere((item) {
                            return item.name.toLowerCase() == nameController.text.toLowerCase();
                          }).netQuantity();
                        } catch(e) {}

                        if (int.parse(quantityController.text.isNotEmpty? quantityController.text : "0") > quantityAvailable) {
                          quantityValidate = true;
                        } else {
                          quantityValidate = false;
                        }
                        setState(() {});
                      },
                      decoration: AddEntryScreen.inputDecoration("Enter quantity").copyWith(errorText: quantityValidate? "No sufficient quantity in hand" : null)
                    ),
                    const SizedBox(height: 20),

                    // Amount Input Field
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Price ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "per/qty",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: amountController,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: AddEntryScreen.inputDecoration("Enter amount").copyWith(errorText: amountValidate? "Field can't be empty" : null)
                    ),
                    const SizedBox(height: 20),
                
                    // Category Dropdown
                    const Text(
                      "Category",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF222244),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: DropdownButtonFormField<String>(
                        dropdownColor: const Color(0xFF222244),
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration.collapsed(hintText: ''),
                        hint: const Text(
                          "Select category",
                          style: TextStyle(color: Colors.white54),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Housing",
                            child: Text("Housing"),
                          ),
                          DropdownMenuItem(
                            value: "Food",
                            child: Text("Food"),
                          ),
                          DropdownMenuItem(
                            value: "Transport",
                            child: Text("Transport"),
                          ),
                          DropdownMenuItem(
                            value: "Other",
                            child: Text("Other"),
                          ),
                        ],
                        onChanged: (value) {
                          // Handle category change
                          value!=null? category = value : null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                
                    // Notes Input Field
                    const Text(
                      "Notes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: notesController,
                      style: TextStyle(color: Colors.white),
                      maxLines: 4,
                      decoration: AddEntryScreen.inputDecoration("Optional notes...")
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Add Entry Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF4D4DFF), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: addEntry,
                  child: const Text(
                    "Add Entry",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addEntry() async {
    // try {
    final name = nameController.text.trim();

    if (name.isEmpty || amountController.text.trim().isEmpty || (isSell? quantityValidate : false)) {
      nameValidate = name.isEmpty;
      amountValidate = amountController.text.trim().isEmpty;
      setState(() {
        
      });
      return;
    }

    final datetime = DateTime.now();
    final amount = double.parse(amountController.text);
    final quantity = int.parse(quantityController.text);

    
    late final String? existingProductId;
    try {
      existingProductId = items.firstWhere((item)=> item.name.toLowerCase() == nameController.text.trim().toLowerCase()).itemId;
    } catch (e) {
      existingProductId = null;
    }

    late final Entry entry;
    try {
    entry = Entry(
      isSell? existingProductId! : (existingProductId?? "ITEM-${Uuid().v1()}"),
      entryId: "ENTRY-${Uuid().v1()}",
      name: name,
      dateTime: datetime,
      price: amount,
      isSell: isSell,
      category: category,
      quantity: quantity);
    } catch (e) {
      // suspected error: null check operator used on null value
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add entry'),
        ),
      );
      return;
    }
    // } on Exception {
    //   //
    // }

    await Provider.of<DataProvider>(context, listen: false).addEntry(context, newEntry: entry);

    // await entry.addEntry();

    Navigator.pop(context, entry);
  }

  onQuantityFocusChange() {
    if (!quantityFocusNode.hasFocus) {
      if (quantityController.text.isEmpty) {
        quantityController.text = "0";
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    items = Provider.of<DataProvider>(context, listen: false).items;

    quantityFocusNode.addListener(onQuantityFocusChange);
  }
}
