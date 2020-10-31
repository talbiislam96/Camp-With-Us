import 'package:camp_with_us/Entity/following.dart';
import 'package:camp_with_us/widgets/rating_imformation.dart';
import 'package:flutter/material.dart';
import '../Entity/event.dart';
import 'banner_image.dart';


class MovieDetailHeader extends StatelessWidget {
  MovieDetailHeader(this.event);
  final Event event;
  //MovieDetailHeader();
  //List<Widget> _buildCategoryChips(TextTheme textTheme) {
    //return mo.categories.map((category) {
      //return Padding(
        //padding: const EdgeInsets.only(right: 8.0),
        //child: Chip(
         // label: Text(category),
          //labelStyle: textTheme.caption,
         // backgroundColor: Colors.black12,
       // ),
      //);
   // }).toList();
  //}

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var movieInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event name',
          style: textTheme.title,
        ),
        SizedBox(height: 8.0),
        RatingInformation(event),
        SizedBox(height: 12.0),
        Row(children: <Widget>[
          Flexible(
            child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Chip(
           label: Text('location'),
          labelStyle: textTheme.caption,
           backgroundColor: Colors.black12,
           ),
          ),

          ),



          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Chip(
                label: Text('distance'),
                labelStyle: textTheme.caption,
                backgroundColor: Colors.black12,
              ),
            ),

          )

        ],),
      ],
    );

    return Stack(
      children: [

        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: ArcBannerImage(),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                //backgroundImage: AssetImage(following.image),
                backgroundImage: NetworkImage('https://img.freepik.com/free-psd/young-man-placing-his-hands-hips_1187-6830.jpg?size=338&ext=jpg'),
                radius: 40.0,
              ),
              SizedBox(width: 16.0),
              Expanded(child: movieInformation),
            ],
          ),
        ),
      ],
    );
  }
}