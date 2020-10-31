import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/calendar_picker.dart';


class EditEventForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new EditEventFormState();

  final void Function(Map<String, dynamic>) _submitFormCallback;

  EditEventForm();

}

class EditEventFormState extends State<EditEventForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return new SingleChildScrollView(
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Form(
          //autovalidate: true,
          key: _formKey,
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Event Name",
                    border: new OutlineInputBorder(),
                  ),
                  validator: (val) => val.length < 5 ? "Event name is too short" : null,
                  //onSaved: (val) => _eventName = val,
                ),
              ),
              new TextFormField(

                decoration: new InputDecoration(
                  labelText: "Description",
                  border: new OutlineInputBorder(),
                ),
                validator: (val) => val.isEmpty ? "Event description should not be empty" : null,
                maxLines: 6,
                //onSaved: (val) => _description = val,
              ),
              new CalendarPicker(_startTimeController),
              new CalendarPicker(_endTimeController),
              new Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: new TextFormField(
                  controller: _latitudeController,
                  decoration: new InputDecoration(
                    labelText: "Lattitude",
                    //icon: new Icon(Icons.map),
                    border: new OutlineInputBorder(),
                  ),
                  validator: (val) => double.parse(val, (e) => null) == null ? "Invalid longitude. Should be number." : null,
                  onSaved: (val) => _latitude = double.parse(val, (e) => null),
                ),
              ),
              new TextFormField(
                controller: _longitudeController,
                decoration: new InputDecoration(
                  labelText: "Longitude",
                  //icon: new Icon(Icons.map),
                  border: new OutlineInputBorder(),
                ),
                validator: (val) => double.parse(val, (e) => null) == null ? "Invalid longitude. Should be number." : null,
                onSaved: (val) => _longitude = double.parse(val, (e) => null),
              ),
              new MaterialButton(
                onPressed: () => submitForm(),
                child: new Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
