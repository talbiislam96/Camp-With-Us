import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude ;

  Future<void> getCurrentLocation() async{
    try {
      print('your location is:');
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
      latitude = position.latitude;
      longitude = position.longitude;
      print(position);
    }
    catch (e){
      print(e);
    }

  }
}