import 'dart:io';

import 'package:dima/firestore/firestore.dart';
import 'package:dima/models/field_model.dart';
import 'package:dima/pages/field_list/field_list_screen.dart';
import 'package:dima/pages/homepage.dart';
import 'package:flutter/material.dart';

class ModifyFieldScreen extends StatefulWidget {
  const ModifyFieldScreen({super.key});

  @override
  State<ModifyFieldScreen> createState() => _ModifyFieldScreenState();
}

class _ModifyFieldScreenState extends State<ModifyFieldScreen> {
  
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fieldNameController = TextEditingController();
  final TextEditingController _cropTypeController = TextEditingController();
  bool _frostController = false;
  bool _hailController = false;
  bool _frostModified = false;
  bool _hailModified = false;

  Future<void> _selectDate() async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2300)
    );

    if(picked!=null){
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    }
}

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, Object>{}) as Map;
    final index = arguments['index'] as int;
    final field = arguments['field'] as Field_model;

    
   
  
   

    if(_dateController.text == '') _dateController.text = field.datePlanted;
    if(_fieldNameController.text == '' ) _fieldNameController.text = field.name;
    if(_cropTypeController.text == '') _cropTypeController.text = field.cropType;
    if(!_frostModified) _frostController = field.frostAlert;
    if(!_hailModified) _hailController = field.hailAlert;   
  


    return Scaffold(
      appBar: AppBar(
        title: Text('Modify Field'),
      ),
      body:Container(
              height: 600,
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment(-0.92,0),
                    child: Text(
                      "Field name:",
                      textAlign:TextAlign.right,
                      ),
                  ),
                  const SizedBox(height: 5),
                  Form(child:
                    TextField(
                      controller: _fieldNameController,
                      decoration: InputDecoration(
                        hintText: 'Field name',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Align(
                    alignment: Alignment(-0.92,0),
                    child: Text(
                      "Crop type:",
                      textAlign:TextAlign.right,
                      ),
                  ),
                const SizedBox(height: 5),
                  Form(child:
                    TextField(
                      controller: _cropTypeController,
                      decoration: InputDecoration(
                        hintText: 'Crop type',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ), 
                  const SizedBox(height: 20),
                const Align(
                    alignment: Alignment(-0.92,0),
                    child: Text(
                      "Seeding date:",
                      textAlign:TextAlign.right,
                      ),
                  ),
                const SizedBox(height: 5),
                  Form(child:
                    TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month),
                        hintText: 'Seeding date',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      readOnly: true,
                      onTap: (){
                        _selectDate();
                      },
                    ),
                  ), 
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Enable frost notification"),
                      Switch(
                        value: _frostController,
                        inactiveTrackColor: Colors.grey,
                        inactiveThumbColor: Color.fromARGB(255, 75, 75, 75),
                        activeTrackColor: Color.fromARGB(255, 153, 208, 3),
                        activeColor: const Color.fromARGB(255, 77, 115, 78),
                        onChanged: (bool value){
                          setState(() {
                            _frostModified = true;
                            _frostController = value;
                          });
                        }),
                        
                  ],),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                    const Text("Enable hail notification"),
                    Switch(
                      value: _hailController,
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Color.fromARGB(255, 75, 75, 75),
                      activeTrackColor: Color.fromARGB(255, 153, 208, 3),
                      activeColor: const Color.fromARGB(255, 77, 115, 78),
                      onChanged: (bool value){
                        setState(() {
                          _hailModified = true;  
                          _hailController = value;
                        });
                      }),
                  

                  ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:() async {

                      String name = _fieldNameController.text;
                      String cropType = _cropTypeController.text;
                      String datePlanted = _dateController.text;
                      bool hailAlert = _hailController;
                      bool frostAlert = _frostController;

                      await Firestore().updateField(index, name, cropType, datePlanted, frostAlert, hailAlert);

                      sleep(const Duration(seconds: 1));
                      //todo caricatore
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Homepage()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Icon(Icons.save),
                  )
                ],
                ),
            )
    );
  }
}