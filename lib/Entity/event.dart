class Event {
   int id;
   String name;
   String type;
   String dStart;
   String dEnd;
   String distance;
   String photo;
   String place;
   String phone;
   int difficulty;
   int price;
   int nbrPlaces;
   String description;
   int userId;
   final double rating;
   final int starRating;


  Event(
      this.id,
      this.name,
      this.type,
      this.dStart,
      this.dEnd,
      this.distance,
      this.photo,
      this.place,
      this.phone,
      this.difficulty,
      this.price,
      this.nbrPlaces,
      this.description,
      this.userId,
      this.rating,
      this.starRating);

   Event.fromJson(Map<String, dynamic> json) {
        id = json['id_evenement'];
        name =  json['nom_evenement'];
        type = json['type_evenement'];
        dStart =  json['date_debut_evenement'];
        dEnd =  json['date_fin_evenement'];
        distance =  json['distance_evenement'];
        photo = json['photo_evenement'];
        place = json['lieux_evenement'];
        phone = json['infoline'];
        difficulty = json['difficulte_evenement'];
        price = json['prix_evenement'];
        nbrPlaces = json['nbr_place'];
        description = json['description_evenement'];
        userId = json['id_user'];


    /*name: json['nom_evenement'],
      type: json['type_evenement'],
        dStart: json['date_debut_evenement'],
        dEnd: json['date_fin_evenement'],
      distance: json['distance_evenement'],
      photo: json['photo_evenement'],
      place: json['lieux_evenement'],
      phone: json['infoline'],
      difficulty: json['difficulte_evenement'],
      price: json['prix_evenement'],
        nbrPlaces: json['nbr_place'],
      description: json['description_evenement'],
        userId: json['id_user']*/
  }
}