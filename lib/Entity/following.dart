class Following {
   int id;
   String name;
   String surname;
   String image;



  Following(
      this.id,
      this.name,
      this.surname,
      this.image,
 );

   Following.fromJson(Map<String, dynamic> json) {
        id = json['id'];
        name =  json['name'];
        surname = json['prenom'];
        image =  json['image_user'];
  }
}