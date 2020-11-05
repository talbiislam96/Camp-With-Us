import 'dart:async';
import 'dart:io';
import 'package:camp_with_us/screens/events.dart';
import 'package:camp_with_us/screens/trending.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'reusable_card.dart';
import 'calender_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditEventForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new EditEventFormState();

  final void Function(Map<String, dynamic>) _submitFormCallback;
  final Map _startingData;
  EditEventForm(this._submitFormCallback, this._startingData);
}

const kNumberTextStyle = TextStyle(
  fontSize: 50,
  fontWeight: FontWeight.w900,
);

class EditEventFormState extends State<EditEventForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  num _latitude;
  num _longitude;
  final TextEditingController _startTimeController =
      new TextEditingController();
  final TextEditingController _endTimeController = new TextEditingController();
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();
  final TextEditingController _priceController = new TextEditingController();
  final TextEditingController _infolineController = new TextEditingController();
  final TextEditingController _placeController = new TextEditingController();
  final TextEditingController _typeController = new TextEditingController();
  int idConnectedUser;

  File _image;
  int nombre = 20;

  @override
  void initState() {
    if (!(widget._startingData == null)) {
      _startTimeController.text = DateFormat(CalendarPickerState.timeFormat)
          .format(widget._startingData["start-time"]);
      _endTimeController.text = DateFormat(CalendarPickerState.timeFormat)
          .format(widget._startingData["end-time"]);
      _titleController.text = widget._startingData["name"];
      _descriptionController.text = widget._startingData["description"];
      _priceController.text = widget._startingData["price"];
      _infolineController.text = widget._startingData["infoline"];
      _placeController.text = widget._startingData["place"];
      _typeController.text = widget._startingData["type"];
    }
    super.initState();
  }


  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      print(_image);
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        });
  }

  add() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    idConnectedUser = preferences.getInt("id");
    if (_image == null) return;
    String base64Image = base64Encode(_image.readAsBytesSync());
    String fileName = _image.path.split("/").last;
    final response =
        await http.post("http://localhost:1337/evenement/add", body: {
      "image": base64Image,
      "name": fileName,
      "nom_evenement": _titleController.text,
      "type_evenement": _typeController.text,
      "lieux_evenement": _placeController.text,
      "date_debut_evenement": _startTimeController.text,
      "date_fin_evenement": _endTimeController.text,
      "prix_evenement": _priceController.text,
      "infoline": _infolineController.text,
      "description_evenement": _descriptionController.text,
      "nbr_place": nombre.toString(),
      "id_user": idConnectedUser.toString(),
    });

    final data = jsonDecode(response.body);
    print(data);

    if (data == "Evenement ajouté avec succés") {
      successToast("Event added successfully !");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Events()),
      );
    } else {
      errorToast("Error Adding Event");
    }
  }

  successToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }

  errorToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  ///Submits the form
  ///
  /// The form fields are first validated, and then the event details are based
  /// to a the [widget._submitFormCallback]
  void submitForm() async {
    final FormState form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      add();
      widget._submitFormCallback(<String, dynamic>{
        "name": _titleController.text,
        "description": _descriptionController.text,
        "start-time":
            CalendarPickerState.stringToDate(_startTimeController.text),
        "end-time": CalendarPickerState.stringToDate(_endTimeController.text)
      });
    }
  }

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
                  controller: _titleController,
                  decoration: new InputDecoration(
                    labelText: "Event Name",
                    border: new OutlineInputBorder(),
                  ),
                  validator: (val) =>
                      val.isEmpty ? "Event name should not be empty" : null,
                  //onSaved: (val) => _eventName = val,
                ),
              ),
              new TextFormField(
                controller: _descriptionController,
                decoration: new InputDecoration(
                  labelText: "Description",
                  border: new OutlineInputBorder(),
                ),
                validator: (val) => val.isEmpty
                    ? "Event description should not be empty"
                    : null,
                maxLines: 6,
                //onSaved: (val) => _description = val,
              ),
              new CalendarPicker(_startTimeController),
              new CalendarPicker(_endTimeController),
              new Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: new TextFormField(
                  controller: _priceController,
                  decoration: new InputDecoration(
                    labelText: "Price",
                    //icon: new Icon(Icons.map),
                    border: new OutlineInputBorder(),
                  ),
                  validator: (val) => double.parse(val, (e) => null) == null
                      ? "Invalid Price. Should be number."
                      : null,
                  onSaved: (val) => _latitude = double.parse(val, (e) => null),
                ),
              ),
              new TextFormField(
                controller: _placeController,
                decoration: new InputDecoration(
                  labelText: "Place Event",
                  //icon: new Icon(Icons.map),
                  border: new OutlineInputBorder(),
                ),
                validator: (val) =>
                    val.isEmpty ? "Event place should not be empty" : null,
              ),
              new TextFormField(
                controller: _typeController,
                decoration: new InputDecoration(
                  labelText: "Category Event",
                  //icon: new Icon(Icons.map),
                  border: new OutlineInputBorder(),
                ),
                validator: (val) =>
                    val.isEmpty ? "Event Type should not be empty" : null,
              ),
              new TextFormField(
                controller: _infolineController,
                decoration: new InputDecoration(
                  labelText: "Infoline",
                  //icon: new Icon(Icons.map),
                  border: new OutlineInputBorder(),
                ),
                validator: (val) => double.parse(val, (e) => null) == null
                    ? "Invalid Price. Should be number."
                    : null,
              ),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new ReusableCard(
                    cardChild: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Number of places',
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          nombre.toString(),
                          style: kNumberTextStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RoundIconButton(
                              icon: Icons.minimize,
                              onPress: () {
                                setState(() {
                                  nombre--;
                                });
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RoundIconButton(
                              icon: Icons.add,
                              onPress: () {
                                setState(() {
                                  nombre++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      new RaisedButton(
                          child: new Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            _showPicker(context);
                          }),
                      new Text("Upload Event Photo")
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(50),
                child: new RaisedButton(
                  child: new Text("Add Event"),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () => submitForm(),
                  shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPress});
  final IconData icon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(icon),
      constraints: BoxConstraints.tightFor(
        width: 56,
        height: 56,
      ),
      shape: CircleBorder(),
      fillColor: Color(0xFF4C4F5E),
      elevation: 0,
      onPressed: onPress,
    );
  }
}
