import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0','1','2','3','4'];

  // from values
  String _currentName;
  String _currentSugars;
  int _currentStrength;
  @override
  Widget build(BuildContext context) {

    final user =Provider.of<CustomUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        if(snapshot.hasData) {

          UserData userData = snapshot.data;

          return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Update your brew settings', // title of the form
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                initialValue: userData.name,
                decoration: textInputDecoration.copyWith(hintText: 'Name'), // from constants file
                validator: (val) => val.isEmpty ? 'Please enter a name' : null, // check if name field is filled or not
                onChanged: (val) => setState(() => _currentName = val) , // set currentName to value entered
              ),SizedBox(height: 20.0,),
              // dropdown for sugars
              DropdownButtonFormField(
                decoration: textInputDecoration,
                value: _currentSugars ?? userData.sugars, // display this in the space in the form , if null display 0 as a fall back option
                items: sugars.map((sugar) {
                  return DropdownMenuItem(
                    value: sugar, // value clicked stored here
                    child: Text('$sugar sugars'), // shown in dropdown
                  );
                }).toList(),
                onChanged: (val) => setState(() => _currentSugars = val) ,
              ),
              // slider for strength
              Slider(
                value: (_currentStrength ?? userData.strength).toDouble(), // if currentState exists then show that if not than 100
                activeColor: Colors.brown[_currentStrength ?? userData.strength],
                inactiveColor: Colors.brown,
                min: 100,
                max: 900,
                divisions: 8,
                onChanged: (val) => setState(() => _currentStrength = val.round()), // val will be double like 100.0,200.0 so round it of to nearest integer
              ),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    await DatabaseService(uid: user.uid).updateUserData(
                      _currentSugars ?? userData.sugars,
                      _currentName ?? userData.name,
                      _currentStrength ?? userData.strength
                    );
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        );
        }else {
          return Loading();
        }
      }
    );
  }
}
