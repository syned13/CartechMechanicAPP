class Mechanic {
  int mechanicId;
  String name;
  String lastName;
  String email;
  String nationalId;
  String password;
  int score;
  String bio;
  String phoneNumber;

  Mechanic(
      {this.mechanicId,
        this.name,
        this.lastName,
        this.email,
        this.nationalId,
        this.password,
        this.score,
        this.bio,
        this.phoneNumber});

  Mechanic.fromJson(Map<String, dynamic> json) {
    mechanicId = json['mechanic_id'];
    name = json['name'];
    lastName = json['last_name'];
    email = json['email'];
    nationalId = json['national_id'];
    password = json['password'];
    score = json['score'];
    bio = json['bio'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mechanic_id'] = this.mechanicId;
    data['name'] = this.name;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['national_id'] = this.nationalId;
    data['password'] = this.password;
    data['score'] = this.score;
    data['bio'] = this.bio;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}