import 'package:flutter/material.dart';


enum DeadlineStatus{
  overdue,
  nearDealine,
  farDeadline,
  undefined
}

class ToDo {
  var id;
  var name;
  var description;
  var dueDate;

  ToDo({
    @required this.id,
    @required this.name,
    this.description,
    this.dueDate,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    dueDate: json["dueDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "dueDate": dueDate,
  };

  DeadlineStatus evalDeadline(){
    if(dueDate == null)
      return DeadlineStatus.undefined;

    var dueDateParsed = DateTime.parse(dueDate);

    if(DateTime.now().difference(dueDateParsed).inDays > 3)
      return DeadlineStatus.farDeadline;
    else if(DateTime.now().isBefore(dueDateParsed))
      return DeadlineStatus.nearDealine;
    else
      return DeadlineStatus.overdue;
  }
}
