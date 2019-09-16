import 'package:flutter/material.dart';

enum DeadlineStatus { overdue, nearDealine, farDeadline, undefined }

class ToDo {
  var id;
  var name;
  var description;
  var dueDate;
  var isDone;

  ToDo(
      {@required this.id,
      @required this.name,
      this.description,
      this.dueDate,
      this.isDone});

  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      dueDate: json["dueDate"],
      isDone: json["isDone"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "dueDate": dueDate,
        "isDone": isDone
      };

  DeadlineStatus evalDeadline() {
    if (dueDate == '') return DeadlineStatus.undefined;

    var dueDateParsed = DateTime.parse(dueDate);

    if (dueDateParsed.difference(DateTime.now()).inDays > 3)
      return DeadlineStatus.farDeadline;
    else if (DateTime.now().isBefore(dueDateParsed))
      return DeadlineStatus.nearDealine;
    else
      return DeadlineStatus.overdue;
  }
}
