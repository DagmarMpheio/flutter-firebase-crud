class DadorModel {
  String? id;
  String? name;
  String? email;
  String? mobileCode;
  String? telefone;
  String? senha;
  String? provincia;
  String? grupoSanguineo;
  String? profilePicture;

  DadorModel(
      {this.id,
      this.name,
      this.email,
      this.mobileCode,
      this.telefone,
      this.senha,
      this.provincia,
      this.grupoSanguineo,
      this.profilePicture});

  factory DadorModel.fromJson(Map<String, dynamic> json) {
    return DadorModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobileCode: json['mobileCode'],
      telefone: json['telefone'],
      senha: json['senha'],
      provincia: json['provincia'],
      grupoSanguineo: json['grupoSanguineo'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobileCode': mobileCode,
      'telefone': telefone,
      'senha': senha,
      'provincia': provincia,
      'grupoSanguineo': grupoSanguineo,
      'profilePicture': profilePicture,
    };
  }
}
