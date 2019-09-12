enum DeadlineStatus{
  overdue,
  nearDealine,
  farDeadline,
  undefined
}

class ToDo{
  var name;
  var description;
  var dueDate;

  DeadlineStatus evalDeadline(){
    if(dueDate == null)
      return DeadlineStatus.undefined;
    

    if(DateTime.now().difference(dueDate).inDays > 3)
      return DeadlineStatus.farDeadline;
    else if(DateTime.now().isBefore(dueDate))
      return DeadlineStatus.nearDealine;
    else
      return DeadlineStatus.overdue;
  }
}