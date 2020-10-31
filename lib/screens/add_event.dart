import 'package:camp_with_us/widgets/event_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:geocoder/geocoder.dart';

class AddEventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AddEventPageState();
}

//const kGoogleApiKey = "AIzaSyB3hJv1HJTay3nwJBqbuV7d5Tt5nFfqEGA";

//GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class AddEventPageState extends State<AddEventPage> {
  void Function(Map<String,String> p1) get submitForm => null;


  @override
  Widget build(BuildContext context) {
    //return Scaffold(
       // body: Container(
        //    alignment: Alignment.center,
            //child: RaisedButton(
            //  onPressed: () async {
                // show input autocomplete with selected mode
                // then get the Prediction selected
               // Prediction p = await PlacesAutocomplete.show(
                    //context: context, apiKey: kGoogleApiKey);
                //displayPrediction(p);
              //},
              //child: Text('Find address'),

           // )
        //)
    //);


    return new Scaffold(
    appBar: new AppBar(title: new Text("Add Event"),),
    body: new EditEventForm(submitForm, null),
    );
  }
}
//Future<Null> displayPrediction(Prediction p) async {
  //if (p != null) {
    //PlacesDetailsResponse detail =
    //await _places.getDetailsByPlaceId(p.placeId);

    //var placeId = p.placeId;
    //double lat = detail.result.geometry.location.lat;
    //double lng = detail.result.geometry.location.lng;

    //var address = await Geocoder.local.findAddressesFromQuery(p.description);

   // print(lat);
   // print(lng);
 // }
//}
