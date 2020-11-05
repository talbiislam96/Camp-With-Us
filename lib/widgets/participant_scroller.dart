import 'package:camp_with_us/Entity/following.dart';
import 'package:flutter/material.dart';
import '../Entity/event.dart';

class ActorScroller extends StatelessWidget {
  //ActorScroller(this.followers);
  //final List<Following> followers;
  ActorScroller();

  Widget _buildActor(BuildContext ctx, int index) {
    //var following = followers[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            //backgroundImage: AssetImage(following.image),
            backgroundImage: NetworkImage('https://img.freepik.com/free-psd/young-man-placing-his-hands-hips_1187-6830.jpg?size=338&ext=jpg'),
            radius: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            //child: Text(following.name),
            child: Text('test'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Participants',
            style: textTheme.subhead.copyWith(fontSize: 18.0),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            //itemCount: followers.length,
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 12.0, left: 20.0),
            itemBuilder: _buildActor,
          ),
        ),
      ],
    );
  }
}
