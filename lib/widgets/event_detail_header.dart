import 'package:camp_with_us/Entity/following.dart';
import 'package:flutter/material.dart';
import '../Entity/event.dart';


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
        RatingInformation(movie),
        SizedBox(height: 12.0),
        Row(children: _buildCategoryChips(textTheme)),
      ],
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: ArcBannerImage(movie.bannerUrl),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Poster(
                movie.posterUrl,
                height: 180.0,
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