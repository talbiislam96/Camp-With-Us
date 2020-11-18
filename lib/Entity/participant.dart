class Participant {
  int id;
  int idUser;
  int idEvent;
  String name;
  String surname;
  String phone;
  String image;

  Participant(
    this.id,
    this.idUser,
    this.idEvent,
    this.name,
    this.surname,
    this.phone,
    this.image,
  );

  Participant.fromJson(Map<String, dynamic> json) {
    id = json['id_participant'];
    idUser = json['id_user'];
    idEvent = json['id_evenement'];
    name = json['name'];
    surname = json['prenom'];
    image = json['image_user'];
    phone = json['tel_user'];

  }
}
