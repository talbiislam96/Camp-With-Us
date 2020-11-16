import 'package:camp_with_us/Entity/event.dart';
import 'package:camp_with_us/widgets/event_description.dart';
import 'package:camp_with_us/widgets/event_detail_header.dart';
import 'package:camp_with_us/widgets/participant_scroller.dart';
import 'package:camp_with_us/widgets/rating_imformation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';


class EventDetailsPage extends StatefulWidget {
  EventDetailsPage(this.id);
  final int id;

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}
class _EventDetailsPageState extends State<EventDetailsPage> {
   int idEvent;
   int idConnectedUser;
   double moyenneRating = 0;

   addRating(double note, double moy) async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     idEvent = preferences.getInt("idEvent");
     idConnectedUser = preferences.getInt("id");

     final response = await http.post("http://localhost:1337/rating/add", body: {
       "id_evenement": idEvent.toString(),
       "id_user": idConnectedUser.toString(),
       "note": note.toString(),
     });
     successToast("Rating attributed successfully, Thank You !");
     moyRating();

   }
 moyRating() async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     idEvent = preferences.getInt("idEvent");
     idConnectedUser = preferences.getInt("id");
     final response = await http.get("http://localhost:1337/rating/show/$idEvent");
     setState(()  {
       final data = jsonDecode(response.body);
       moyenneRating = double.parse((data['moyenneNote']).toString());
       print("moy rating:$moyenneRating");

     });
     final response2 = await http
         .put("http://localhost:1337/event/note/$idEvent", body: {
       "note": moyenneRating.round().toString(),
     });
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
   Widget ratingBar(){
     var textTheme = Theme.of(context).textTheme;
     return Column(
       children: <Widget>[
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 20.0),
           child: Text(
             'Rating',
             style: textTheme.subhead.copyWith(fontSize: 18.0),
           ),
         ),
         RatingBar(
           initialRating: 3,
           minRating: 1,
           direction: Axis.horizontal,
           allowHalfRating: true,
           itemCount: 5,
           itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
           itemBuilder: (context, _) => Icon(
             Icons.star,
             color: Colors.amber,
           ),
           onRatingUpdate: (rating) {
             print(rating);
             // this.deactivate();
             addRating(rating, moyenneRating);
           },

         ),
       ],
     );
   }
   @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EventDetailHeader(),
            SizedBox(height: 20.0),
            Storyline(),
            SizedBox(height: 20.0),
            ActorScroller(),
            SizedBox(height: 20.0),
            ratingBar(),
            SizedBox(height: 50.0),

          ],
        ),
      ),
    );
  }
}
