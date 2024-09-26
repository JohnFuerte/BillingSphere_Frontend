class UserModel {
  String? sId;
  String? fullName;
  String? email;
  String? password;
  String? id;
  String? updatedOn;
  String? token;
  String? userGroup;
  String? dashboardAccess;
  String? dashboardCategory;
  String? backDateEntry;

  UserModel({
    this.sId,
    this.fullName,
    this.email,
    this.password,
    this.id,
    this.updatedOn,
    this.userGroup,
    this.dashboardAccess,
    this.dashboardCategory,
    this.backDateEntry,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
    // updatedOn = json['updatedOn'];
    // userGroup = json['usergroup'];
    // dashboardAccess = json['dashboardAccess'];
    // dashboardCategory = json['dashboardCategory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['email'] = email;
    data['password'] = password;
    data['id'] = id;
    data['updatedOn'] = updatedOn;
    data['token'] = token;
    data['usergroup'] = userGroup;
    data['dashboardAccess'] = dashboardAccess;
    data['dashboardCategory'] = dashboardCategory;
    data['backDateEntry'] = backDateEntry;
    
    return data;
  }
}
