import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:country_list_pick/country_list_pick.dart';

class ManageClientWidget extends StatelessWidget {
  const ManageClientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddClientWidget()),
              );
            },
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Your clients will show up here. Click the button above to create your first client.',
          style: TextStyle(color: Colors.grey, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const AppDrawerWidget(),
    );
  }
}

class AddClientWidget extends StatefulWidget {
  const AddClientWidget({Key? key}) : super(key: key);

  @override
  State<AddClientWidget> createState() => _AddClientWidgetState();
}

class _AddClientWidgetState extends State<AddClientWidget> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "SL", child: Text("Sri Lanka")),
      const DropdownMenuItem(value: "USA", child: Text("USA")),
      const DropdownMenuItem(value: "Canada", child: Text("Canada")),
      const DropdownMenuItem(value: "Brazil", child: Text("Brazil")),
      const DropdownMenuItem(value: "England", child: Text("England")),
    ];
    return menuItems;
  }

  String? selectedValue;
  final _formKey = GlobalKey<FormState>();

  void _submit() {
    final isValid = _formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _formKey.currentState?.save();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageClientWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Client'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name *',
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your first name';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your last name';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email Address',
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your email address';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: contactNoController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Contact No',
                ),
                style: const TextStyle(fontSize: 16),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your contact no';
                  }
                  if (value.length > 10) {
                    return 'Invalid contact no';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: addressController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Address',
                ),
                style: const TextStyle(fontSize: 16),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your address';
                  }
                  return null;
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: cityController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'City',
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: DropdownButton(
                  value: selectedValue,
                  hint: const Text("Select Country"),
                  style: const TextStyle(
                    color: Colors.blue, //<-- SEE HERE
                    fontSize: 16,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownItems),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(110, 0, 110, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shadowColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minimumSize: const Size(50, 50),
                  ),
                  child: const Text('Save', style: TextStyle(fontSize: 20)),
                  onPressed: () {
                    _submit();
                  },
                )),
          ])),
    );
  }
}
